#!/usr/bin/env node
// Reapplies the "show price + context window in /model picker" patch.
// pi ships this compiled into a hashed dist/bundle/chunks/*.js file, so
// `npm update -g` (new hash) or a fresh install wipes it every time.
// Run this after any pi update: node ~/dotfiles/pi/.pi/agent/scripts/patch-model-picker-price.mjs
import { execSync } from "node:child_process";
import { readFileSync, writeFileSync, readdirSync } from "node:fs";

const root = execSync("npm root -g").toString().trim();
const chunksDir = `${root}/@earendil-works/pi-coding-agent/dist/bundle/chunks`;

// Minified anchor: the `line=` build-up right after `providerBadge=...` in the
// /model picker's updateList(). Contains no helper fn call, so it's self-contained.
const anchor =
	'providerBadge=theme.fg("muted",`[${item.provider}]`),line=`${cursor}${currentMarker}${modelText} ${providerBadge}${defaultBadge}`;';
const patched =
	'providerBadge=theme.fg("muted",`[${item.provider}]`),' +
	"price=item.model.cost?theme.fg(\"muted\",` · $${item.model.cost.input}/$${item.model.cost.output} per 1M · ctx ${item.model.contextWindow>=1e6?(item.model.contextWindow/1e6).toFixed(1)+\"M\":Math.round(item.model.contextWindow/1e3)+\"k\"}`):\"\"," +
	'line=`${cursor}${currentMarker}${modelText} ${providerBadge}${price}${defaultBadge}`;';

let applied = 0;
for (const name of readdirSync(chunksDir)) {
	if (!name.endsWith(".js")) continue;
	const file = `${chunksDir}/${name}`;
	const src = readFileSync(file, "utf8");
	if (src.includes(patched)) {
		console.log("Already patched:", file);
		applied++;
	} else if (src.includes(anchor)) {
		// Replacer fn avoids String#replace treating `$$` in `patched` as a special substitution token.
		writeFileSync(file, src.replace(anchor, () => patched));
		console.log("Patched:", file);
		applied++;
	}
}

if (!applied) {
	console.error("Anchor not found in any chunk under", chunksDir, "- pi's bundle layout likely changed, update the anchor.");
	process.exit(1);
}
