import { execFileSync } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";

// Fast pre-filter regex: matches candidate commands supported by RTK before invoking subprocess
const RTK_CANDIDATE_REGEX =
	/\b(cargo|git|gh|glab|pnpm|npm|npx|pytest|vitest|jest|tsc|lint|prettier|format|docker|kubectl|psql|aws|go|golangci-lint|ruff|mypy|rubocop|rspec|rake|pip|ls|tree|find|grep|diff|curl|wget|wc|next|prisma)\b/;

function hasRtk(): boolean {
	try {
		execFileSync("rtk", ["--version"], { stdio: "ignore" });
		return true;
	} catch {
		return false;
	}
}

function rewriteCommand(cmd: string): string | null {
	try {
		const out = execFileSync("rtk", ["hook", "check", cmd], {
			encoding: "utf-8",
			timeout: 1000,
			stdio: ["ignore", "pipe", "ignore"],
		}).trim();
		if (out && out !== cmd && !out.startsWith("No rewrite")) {
			return out;
		}
	} catch {
		// Non-zero exit code means no rewrite available, syntax issue, or timeout
	}
	return null;
}

export default function (pi: ExtensionAPI) {
	if (!hasRtk()) return;

	let enabled = true;

	pi.registerFlag("no-rtk", {
		description: "Disable automatic RTK command proxying and output compression.",
		type: "boolean",
		default: false,
	});

	pi.on("session_start", async (event, ctx) => {
		if (event.reason === "startup" && pi.getFlag("--no-rtk") === true) {
			enabled = false;
		}
		if (ctx.hasUI) {
			const text = enabled ? ctx.ui.theme.fg("dim", "rtk") : ctx.ui.theme.fg("dim", "rtk:off");
			ctx.ui.setStatus("rtk", text);
		}
	});

	pi.registerCommand("rtk", {
		description: "Toggle automatic RTK command rewriting or view token savings (/rtk, /rtk gain).",
		handler: async (args, ctx) => {
			const sub = args?.trim().toLowerCase();
			if (sub === "gain" || sub === "stats") {
				try {
					const gain = execFileSync("rtk", ["gain"], { encoding: "utf-8", timeout: 2000 });
					if (ctx.hasUI) {
						ctx.ui.notify(gain.trim(), "info");
					}
				} catch (err: any) {
					if (ctx.hasUI) {
						ctx.ui.notify(`Failed to fetch RTK gain: ${err.message}`, "error");
					}
				}
				return;
			}

			enabled = !enabled;
			if (ctx.hasUI) {
				const text = enabled ? ctx.ui.theme.fg("dim", "rtk") : ctx.ui.theme.fg("dim", "rtk:off");
				ctx.ui.setStatus("rtk", text);
				ctx.ui.notify(`RTK proxying ${enabled ? "enabled" : "disabled"}.`, "info");
			}
		},
	});

	pi.on("tool_call", async (event) => {
		if (!enabled) return;
		if (!isToolCallEventType("bash", event)) return;

		const original = event.input.command;
		if (typeof original !== "string" || !original.trim()) return;

		// Skip if already invoking rtk or explicitly bypassed via environment marker
		if (original.startsWith("rtk ") || original.includes(" rtk ") || /\b(NO_RTK|RAW)=1\b/.test(original)) {
			return;
		}

		// Fast regex pre-filter to avoid unnecessary subprocess launches
		if (!RTK_CANDIDATE_REGEX.test(original)) {
			return;
		}

		const rewritten = rewriteCommand(original);
		if (rewritten) {
			event.input.command = rewritten;
		}
	});
}
