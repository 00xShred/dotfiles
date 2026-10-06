/**
 * /quotas — combined provider quota view.
 *
 * Reuses the quota fetchers the installed provider packages already ship
 * instead of reimplementing their endpoints:
 * - antigravity: pi-antigravity fetchAccountUsage/formatUsageSummary
 * - commandcode: pi-commandcode-provider fetchCommandCodeQuota/formatQuota
 * - anthropic:   OAuth unified rate-limit headers, probed by a 1-token haiku
 *                request (no standalone quota endpoint exists) — used only
 *                when the anthropic provider is on OAuth, not an API key.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
// pi-antigravity / pi-commandcode-provider live in pi's npm dir
// (~/.pi/agent/npm/node_modules). Extensions load through jiti without that on
// their resolution paths, so import by absolute path via the home anchor.
import { homedir } from "node:os";

const npmMod = (spec: string) => `${homedir()}/.pi/agent/npm/node_modules/${spec}`;
// ponytail: absolute-path imports break on nonstandard installs; move fetch
// logic into a pi package if that ever matters.

interface ModelRegistryLike {
	getApiKeyForProvider(provider: string): Promise<string | undefined>;
	getProviderAuth(provider: string): Promise<{ auth: { apiKey?: string } } | undefined>;
	isUsingOAuth?(provider: string): boolean;
}
const {
	fetchAccountUsage,
	formatUsageSummary,
	resolveApiKeyFromContext,
} = await import(npmMod("pi-antigravity/src/usage/usage.ts"));
const { fetchCommandCodeQuota } = await import(npmMod("pi-commandcode-provider/src/quota.ts"));
const { formatQuota } = await import(npmMod("pi-commandcode-provider/src/quota-format.ts"));
const { pickCommandCodeApiKey } = await import(npmMod("pi-commandcode-provider/src/converters.ts"));

async function maybeSection(name: string, fn: () => Promise<string>): Promise<string> {
	try {
		const body = await fn();
		return body ? `── ${name} ──\n${body}` : "";
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		return `── ${name} ──\n  unavailable: ${msg.slice(0, 200)}`;
	}
}

function formatReset(seconds: string | undefined): string {
	if (!seconds) return "n/a";
	const delta = Number(seconds) * 1000 - Date.now();
	if (!Number.isFinite(delta)) return "n/a";
	if (delta <= 0) return "now";
	const mins = Math.round(delta / 60000);
	const h = Math.floor(mins / 60);
	const m = mins % 60;
	return h > 0 ? `${h}h${m}m` : `${m}m`;
}

interface AnthropicLimits {
	fiveHour?: { used: number; reset: string };
	sevenDay?: { used: number; reset: string };
	status?: string;
}

/** Anthropic only exposes subscription limits as response headers on a real
 *  inference call; a 1-token haiku request is the cheapest probe. */
async function fetchAnthropicLimits(token: string): Promise<AnthropicLimits> {
	const res = await fetch("https://api.anthropic.com/v1/messages", {
		method: "POST",
		headers: {
			Authorization: `Bearer ${token}`,
			"anthropic-version": "2023-06-01",
			"content-type": "application/json",
			"User-Agent": "claude-cli/2.1.0 (external, cli)",
			"anthropic-beta": "oauth-2025-04-20",
		},
		body: JSON.stringify({
			model: "claude-haiku-4-5",
			max_tokens: 1,
			messages: [{ role: "user", content: "hi" }],
		}),
	});
	// consume body so the socket is released
	await res.text();
	const h = (name: string) => res.headers.get(`anthropic-ratelimit-unified-${name}`) ?? undefined;
	if (!h("status") && !h("5h-utilization")) {
		throw new Error(`no ratelimit headers (status ${res.status}); API-key auth?`);
	}
	const pct = (v?: string) => (v === undefined ? undefined : Math.round(Number(v) * 100));
	return {
		status: h("status"),
		fiveHour: h("5h-utilization")
			? { used: pct(h("5h-utilization")) ?? 0, reset: h("5h-reset") ?? "" }
			: undefined,
		sevenDay: h("7d-utilization")
			? { used: pct(h("7d-utilization")) ?? 0, reset: h("7d-reset") ?? "" }
			: undefined,
	};
}

function bar(usedPercent: number, width = 20): string {
	const filled = Math.max(0, Math.min(width, Math.round((usedPercent / 100) * width)));
	return `[${"#".repeat(filled)}${"-".repeat(width - filled)}] ${String(usedPercent).padStart(3)}% used`;
}

function formatAnthropic(l: AnthropicLimits): string {
	const lines = [`status: ${l.status ?? "?"}`];
	if (l.fiveHour) lines.push(`  5h   ${bar(l.fiveHour.used)}  resets ${formatReset(l.fiveHour.reset)}`);
	if (l.sevenDay) lines.push(`  7d   ${bar(l.sevenDay.used)}  resets ${formatReset(l.sevenDay.reset)}`);
	return lines.join("\n");
}

export default function (pi: ExtensionAPI) {
	pi.registerCommand("quotas", {
		description: "Show remaining quota/usage for all configured providers",
		handler: async (_args, ctx) => {
			const parts: string[] = [];

			// antigravity reuses pi-antigravity's own summary code
			parts.push(
				await maybeSection("antigravity", async () => {
					const apiKey = await resolveApiKeyFromContext(ctx);
					if (!apiKey) return "no credentials (/login antigravity first)";
					const usage = await fetchAccountUsage(apiKey);
					return formatUsageSummary(usage);
				}),
			);

			// commandcode reuses pi-commandcode-provider's fetcher + formatter
			parts.push(
				await maybeSection("commandcode", async () => {
					const registryKey = await ctx.modelRegistry.getApiKeyForProvider("commandcode");
					const apiKey = pickCommandCodeApiKey(registryKey, undefined);
					if (!apiKey) return "no credentials";
					const result = await fetchCommandCodeQuota({ apiKey });
					if (!result.ok) return `unavailable: ${result.error.message}`;
					return formatQuota(result.quota);
				}),
			);

			// anthropic: only meaningful for subscription OAuth; skip on API key
			parts.push(
				await maybeSection("anthropic", async () => {
					const reg = ctx.modelRegistry as ModelRegistryLike;
					if (reg.isUsingOAuth && !reg.isUsingOAuth("anthropic")) {
						return "API-key auth: pay-per-token, no subscription quota";
					}
					// OAuth toAuth yields the access token as apiKey
					const auth = await reg.getProviderAuth("anthropic");
					const token = auth?.auth.apiKey;
					if (!token) return "no OAuth credentials";
					const limits = await fetchAnthropicLimits(token);
					return formatAnthropic(limits);
				}),
			);

			const text = parts.filter(Boolean).join("\n\n");
			ctx.ui.notify(text || "No providers configured.", "info");
		},
	});
}
