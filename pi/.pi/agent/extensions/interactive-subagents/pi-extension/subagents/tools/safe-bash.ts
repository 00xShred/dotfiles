/**
 * Safe bash extension for the worker subagent.
 * Wraps the built-in bash tool with dangerous command blocking.
 *
 * Loaded into a child pi process via `--extension` when an agent's `tools`
 * frontmatter lists `safe_bash`. See CUSTOM_TOOL_EXTENSIONS in ../index.ts.
 */
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { createBashTool } from "@earendil-works/pi-coding-agent";
import { Type } from "@sinclair/typebox";

const DANGEROUS_PATTERNS = [
	/\brm\s+(-[a-zA-Z]*f[a-zA-Z]*\s+)?(-[a-zA-Z]*r[a-zA-Z]*\s+)?(\/|~\/?\s|~\/?\b)/,
	/\brm\s+(-[a-zA-Z]*r[a-zA-Z]*\s+)?(-[a-zA-Z]*f[a-zA-Z]*\s+)?(\/|~\/?\s|~\/?\b)/,
	/\bsudo\b/,
	/\bmkfs\b/,
	/\bdd\s+if=/,
	/:\(\)\s*\{\s*:\|:&\s*\}\s*;:/,
	/>\s*\/dev\/[sh]d[a-z]/,
	/\bchmod\s+(-[a-zA-Z]+\s+)?777\s+\//,
	/\bchown\s+(-[a-zA-Z]+\s+)?root/,
	/\bcurl\s.*\|\s*(ba)?sh/,
	/\bwget\s.*\|\s*(ba)?sh/,
	/\bshutdown\b/,
	/\breboot\b/,
	/\binit\s+0\b/,
	/\bkill\s+-9\s+1\b/,
	/\bkillall\b/,
];

const READ_ONLY_GIT = new Set(["clone", "status", "log", "diff", "show", "ls-files", "rev-parse", "describe"]);

function isGitMutation(command: string): boolean {
	const normalized = command.replace(/\\\n/g, " ");
	if (!/\bgit\b/.test(normalized)) return false;
	for (const segment of normalized.split(/&&|\|\||[;|]/)) {
		const match = segment.match(/\bgit\s+(?:-[^\s]+\s+)*([a-z-]+)/);
		if (!match) continue;
		const subcommand = match[1];
		if (READ_ONLY_GIT.has(subcommand)) continue;
		if (subcommand === "branch" && segment.trim().split(/\s+/).slice(2).every((arg) => arg.startsWith("-") && !/^-[dDmcC]$/.test(arg))) continue;
		if (subcommand === "remote" && /\bgit\s+remote(?:\s+(-v|--verbose|show|get-url))?(?:\s|$)/.test(segment)) continue;
		return true;
	}
	return false;
}

function isDangerous(command: string): string | null {
	const normalized = command.replace(/\\\n/g, " ");
	if (isGitMutation(normalized)) return "Git mutations are disabled for subagents; run them manually in your terminal.";
	for (const pattern of DANGEROUS_PATTERNS) {
		if (pattern.test(normalized)) {
			return `Command blocked by safe_bash: matches dangerous pattern ${pattern}`;
		}
	}
	return null;
}

export default function (pi: ExtensionAPI) {
	const bashTool = createBashTool(process.cwd());

	pi.registerTool({
		name: "safe_bash",
		label: "Safe Bash",
		description:
			"Execute a bash command. Blocks dangerous commands (rm -rf /, sudo, mkfs, etc.).",
		parameters: Type.Object({
			command: Type.String({ description: "Bash command to execute" }),
			timeout: Type.Optional(
				Type.Number({ description: "Timeout in seconds (optional)" }),
			),
		}),
		async execute(toolCallId, params, signal, onUpdate, ctx) {
			const danger = isDangerous(params.command);
			if (danger) {
				throw new Error(danger);
			}
			return bashTool.execute(toolCallId, params, signal, onUpdate);
		},
	});
}
