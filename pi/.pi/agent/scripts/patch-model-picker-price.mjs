#!/usr/bin/env node
// Reapplies the "show price + context window in /model picker" patch.
// pi ships this compiled in node_modules, so `npm update -g` wipes it on every upgrade.
// Run this after any pi update: node ~/dotfiles/pi/.pi/agent/scripts/patch-model-picker-price.mjs
import { execSync } from "node:child_process";
import { readFileSync, writeFileSync } from "node:fs";

const root = execSync("npm root -g").toString().trim();
const file = `${root}/@earendil-works/pi-coding-agent/dist/modes/interactive/components/model-selector.js`;

let src = readFileSync(file, "utf8");

if (src.includes("formatTokenCount")) {
	console.log("Already patched:", file);
	process.exit(0);
}

src = src.replace(
	`import { keyDisplayText, keyHint } from "./keybinding-hints.js";\n`,
	`import { keyDisplayText, keyHint } from "./keybinding-hints.js";\n` +
		`function formatTokenCount(value) {\n` +
		`    if (!Number.isFinite(value))\n` +
		`        return "?";\n` +
		`    return value >= 1000000\n` +
		`        ? \`\${(value / 1000000).toFixed(1)}M\`\n` +
		`        : \`\${Math.round(value / 1000)}k\`;\n` +
		`}\n`,
);

src = src.replace(
	`            const providerBadge = theme.fg("muted", \`[\${item.provider}]\`);\n            const line = \`\${cursor}\${currentMarker}\${modelText} \${providerBadge}\${defaultBadge}\`;`,
	`            const providerBadge = theme.fg("muted", \`[\${item.provider}]\`);\n` +
		`            const cost = item.model.cost;\n` +
		`            const price = cost ? theme.fg("muted", \` · $\${cost.input}/$\${cost.output} per 1M · ctx \${formatTokenCount(item.model.contextWindow)}\`) : "";\n` +
		`            const line = \`\${cursor}\${currentMarker}\${modelText} \${providerBadge}\${price}\${defaultBadge}\`;`,
);

writeFileSync(file, src);
console.log("Patched:", file);
