/**
 * /quotas — combined provider quota view.
 *
 * Reuses the quota fetchers the installed provider packages already ship
 * instead of reimplementing their endpoints:
 * - antigravity: pi-antigravity fetchAccountUsage/formatUsageSummary
 * - commandcode: pi-commandcode-provider fetchCommandCodeQuota/formatQuota
 * - anthropic: `claude -p /usage` (Claude Code CLI)
 * - deepseek / moonshotai: pay-per-token balance endpoints.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
// pi-antigravity / pi-commandcode-provider live in pi's npm dir
// (~/.pi/agent/npm/node_modules). Extensions load through jiti without that on
// their resolution paths, so import by absolute path via the home anchor.
import { execFile, spawn } from "node:child_process";
import { homedir } from "node:os";

const npmMod = (spec: string) => `${homedir()}/.pi/agent/npm/node_modules/${spec}`;
// ponytail: absolute-path imports break on nonstandard installs; move fetch
// logic into a pi package if that ever matters.

const {
	fetchAccountUsage,
	formatUsageSummary,
	resolveApiKeyFromContext,
} = await import(npmMod("pi-antigravity/src/usage/usage.ts"));
const { fetchCommandCodeQuota } = await import(npmMod("pi-commandcode-provider/src/quota.ts"));
const { formatQuota } = await import(npmMod("pi-commandcode-provider/src/quota-format.ts"));
const { pickCommandCodeApiKey } = await import(npmMod("pi-commandcode-provider/src/api-key.ts"));

async function maybeSection(name: string, fn: () => Promise<string>): Promise<string> {
	try {
		const body = await fn();
		return body ? `── ${name} ──\n${body}` : "";
	} catch (error) {
		const msg = error instanceof Error ? error.message : String(error);
		return `── ${name} ──\n  unavailable: ${msg.slice(0, 200)}`;
	}
}

const fmtReset = (ts: number | null) => {
	if (!ts) return "";
	const m = Math.max(0, Math.round((ts * 1000 - Date.now()) / 60000));
	return ` · resets ${m >= 1440 ? `${Math.floor(m / 1440)}d ${Math.floor((m % 1440) / 60)}h` : `${Math.floor(m / 60)}h ${m % 60}m`}`;
};

async function getJson(url: string, key: string): Promise<any> {
	const res = await fetch(url, { headers: { Authorization: `Bearer ${key}` }, signal: AbortSignal.timeout(10000) });
	if (!res.ok) throw new Error(`HTTP ${res.status}`);
	return res.json();
}

/** ChatGPT plan limits via `codex app-server` JSON-RPC (no model call). */
const codexUsage = () =>
	new Promise<string>((resolve, reject) => {
		const proc = spawn("codex", ["app-server"], { cwd: homedir() });
		const send = (o: any) => proc.stdin.write(JSON.stringify(o) + "\n");
		let buf = "";
		const fail = (e: Error) => (proc.kill(), reject(e));
		proc.on("error", fail);
		const timer = setTimeout(() => fail(new Error("timeout")), 15000);
		proc.stdout.on("data", (d) => {
			buf += d;
			for (const line of buf.split("\n").filter((l) => l.trim())) {
				let msg: any;
				try {
					msg = JSON.parse(line);
				} catch {
					continue;
				}
				if (msg.id === 1) {
					send({ jsonrpc: "2.0", method: "initialized" });
					send({ jsonrpc: "2.0", id: 2, method: "account/rateLimits/read", params: {} });
				}
				if (msg.id === 2) {
					clearTimeout(timer);
					proc.kill();
					const r = msg.result?.rateLimits;
					if (!r) return resolve("");
					const win = (w: any, name: string) => (w ? `  ${name} ${w.usedPercent}% used${fmtReset(w.resetsAt)}` : null);
					const lines = [win(r.primary, "5h   "), win(r.secondary, "Weekly")].filter(Boolean);
					if (r.credits?.hasCredits) lines.push(`  Credits $${r.credits.balance} left`);
					resolve(lines.join("\n"));
				}
			}
			buf = buf.slice(buf.lastIndexOf("\n") + 1);
		});
		send({ jsonrpc: "2.0", id: 1, method: "initialize", params: { clientInfo: { name: "pi-quotas", title: "pi-quotas", version: "0.0.1" } } });
	});

/** GLM coding-plan quota via z.ai's undocumented monitor endpoint. */
const glmUsage = (apiKey: string) =>
	getJson("https://api.z.ai/api/monitor/usage/quota/limit", apiKey).then((j) => {
		if (!j.success) throw new Error(j.msg ?? "unknown error");
		const unit = { 2: "m", 3: "h", 5: "d", 6: "wk" } as Record<number, string>;
		const lines = (j.data.limits ?? []).map((l: any) =>
			`  ${l.number}${unit[l.unit] ?? `u${l.unit}`}  ${l.currentValue}/${l.usage} credits (${l.percentage}%) · ${fmtReset(l.nextResetTime / 1000)}`,
		);
		if (j.data.level) lines.push(`  Plan ${j.data.level}`);
		return lines.join("\n");
	});

/** `claude -p /usage` is answered locally by Claude Code (no model call). */
const claudeUsage = () =>
	new Promise<string>((resolve, reject) =>
		execFile("claude", ["-p", "/usage"], { timeout: 30000, cwd: homedir() }, (err, out) =>
			err ? reject(err) : resolve(out.split("\n").filter((l) => /^Current .*used/.test(l)).map((l) => "  " + l).join("\n")),
		),
	);

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

			parts.push(
				await maybeSection("commandcode", async () => {
					const registryKey = await ctx.modelRegistry.getApiKeyForProvider("commandcode");
					const apiKey = pickCommandCodeApiKey(registryKey, undefined);
					if (!apiKey) return "no credentials";
					const result = await fetchCommandCodeQuota({ apiKey });
					if (!result.ok) return `unavailable: ${result.error.message}`;
					const { credits: c, summary: u } = result.quota;
					const names = { fiveHour: "5h    ", weekly: "Weekly" };
					const lines = (c?.windowLimits ?? []).map(
						(w: any) => `  ${names[w.window as "fiveHour"]} $${w.used.toFixed(2)} / $${w.cap.toFixed(2)}${fmtReset(w.resetAt)}`,
					);
					if (c) lines.push(`  Credits $${c.remainingCredits.toFixed(2)} left`);
					if (u) lines.push(`  Period  $${u.totalCost.toFixed(2)} · ${u.totalCount} req`);
					return lines.join("\n");
				}),
			);

			parts.push(
				await maybeSection("chatgpt", async () => {
					const auth = await ctx.modelRegistry.getApiKeyForProvider("openai");
					if (!auth) return "no credentials (codex login first)";
					return codexUsage();
				}),
			);

			parts.push(
				await maybeSection("glm (z.ai)", async () => {
					const apiKey = await ctx.modelRegistry.getApiKeyForProvider("zai");
					if (!apiKey) return "no credentials";
					return glmUsage(apiKey);
				}),
			);

			parts.push(await maybeSection("anthropic", claudeUsage));

			// pay-per-token API balances
			const balance = async (name: string, url: string, fmt: (j: any) => string) =>
				parts.push(
					await maybeSection(name, async () => {
						const key = await ctx.modelRegistry.getApiKeyForProvider(name);
						return key ? "  " + fmt(await getJson(url, key)) : "";
					}),
				);
			await balance("deepseek", "https://api.deepseek.com/user/balance", (j) =>
				j.balance_infos.map((b: any) => `${b.total_balance} ${b.currency}`).join(" · ") +
				(j.is_available ? "" : " (unavailable)"),
			);
			await balance("moonshotai", "https://api.moonshot.ai/v1/users/me/balance", (j) =>
				`$${j.data.available_balance.toFixed(2)} available` +
				(j.data.cash_balance !== j.data.available_balance ? ` (cash ${j.data.cash_balance.toFixed(2)})` : ""),
			);

			const text = parts.filter(Boolean).join("\n\n");
			ctx.ui.notify(text || "No providers configured.", "info");
		},
	});
}
