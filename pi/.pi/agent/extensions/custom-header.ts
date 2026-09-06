/**
 * Custom Header Extension
 *
 * Replaces the built-in startup header with a centered custom logo.
 * Edit the `buildHeader()` function below to change what's shown at startup.
 *
 * Usage: Just edit this file and run /reload in pi.
 * To restore the built-in header: rename/delete this file and /reload.
 */

import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";
import { VERSION } from "@earendil-works/pi-coding-agent";
import { visibleWidth } from "@earendil-works/pi-tui";

/**
 * Build the header text. This is what you customize.
 *
 * To customize, edit the `art` array and subtitle below.
 */
function buildHeader(theme: Theme): string[] {
	const top = theme.fg("muted", "   Γ, x : Prompt ⊢ thought : Solution");
	const bar = theme.fg("dim", "  ──────────────────────────────────── ") + theme.fg("muted", "(deduce)");
	const bot = theme.bold(theme.fg("success", "                ⊢ π = π ∎"));

	return ["", top, bar, bot, ""];
}

function centerLines(lines: string[], width: number): string[] {
	const blockWidth = Math.max(...lines.map((line) => visibleWidth(line)));
	const padding = Math.max(0, Math.floor((width - blockWidth) / 2));
	const indent = " ".repeat(padding);

	return lines.map((line) => (line ? indent + line : ""));
}


export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		if (!ctx.hasUI) return;

		ctx.ui.setHeader((_tui, theme) => ({
			render(width: number): string[] {
				return centerLines(buildHeader(theme), width);
			},
			invalidate() {},
		}));
	});

	// Command to restore the built-in header
	pi.registerCommand("builtin-header", {
		description: "Restore the built-in startup header",
		handler: async (_args, ctx) => {
			ctx.ui.setHeader(undefined);
			ctx.ui.notify("Built-in header restored", "info");
		},
	});
}
