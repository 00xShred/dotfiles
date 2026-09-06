#!/usr/bin/env node
import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
import { dirname } from "node:path";

const home = process.env.HOME || "/home/0xShred";
const walPath = `${home}/.cache/wal/colors.json`;
const outPath = `${home}/.pi/agent/themes/pywal.json`;

const wal = JSON.parse(readFileSync(walPath, "utf8"));
const c = wal.colors;
const s = wal.special;

const theme = {
  $schema: "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json",
  name: "pywal",
  vars: {
    bg: s.background,
    fg: s.foreground,
    cursor: s.cursor,
    black: c.color0,
    red: c.color1,
    green: c.color2,
    yellow: c.color3,
    magenta: c.color4,
    blue: c.color5,
    pink: c.color6,
    white: c.color7,
    gray: c.color8,
    brightRed: c.color9,
    brightGreen: c.color10,
    brightYellow: c.color11,
    brightMagenta: c.color12,
    brightBlue: c.color13,
    brightPink: c.color14,
    brightWhite: c.color15,
  },
  colors: {
    accent: "blue",
    border: "blue",
    borderAccent: "pink",
    borderMuted: "gray",
    success: "green",
    error: "red",
    warning: "yellow",
    muted: "gray",
    dim: "gray",
    text: "fg",
    thinkingText: "gray",

    selectedBg: "black",
    scrollbarThumb: "gray",
    searchMatchBg: "yellow",
    searchMatchText: "bg",
    userMessageBg: "black",
    userMessageText: "fg",
    customMessageBg: "black",
    customMessageText: "fg",
    customMessageLabel: "blue",
    toolPendingBg: "black",
    toolSuccessBg: "black",
    toolErrorBg: "black",
    toolTitle: "blue",
    toolOutput: "fg",

    mdHeading: "brightYellow",
    mdLink: "blue",
    mdLinkUrl: "gray",
    mdCode: "pink",
    mdCodeBlock: "fg",
    mdCodeBlockBorder: "gray",
    mdQuote: "gray",
    mdQuoteBorder: "gray",
    mdHr: "gray",
    mdListBullet: "pink",

    toolDiffAdded: "green",
    toolDiffRemoved: "red",
    toolDiffContext: "gray",

    syntaxComment: "gray",
    syntaxKeyword: "magenta",
    syntaxFunction: "blue",
    syntaxVariable: "yellow",
    syntaxString: "green",
    syntaxNumber: "pink",
    syntaxType: "brightBlue",
    syntaxOperator: "magenta",
    syntaxPunctuation: "gray",

    thinkingOff: "gray",
    thinkingMinimal: "green",
    thinkingLow: "blue",
    thinkingMedium: "pink",
    thinkingHigh: "magenta",
    thinkingXhigh: "red",
    thinkingMax: "brightRed",
    bashMode: "yellow",
  },
  export: {
    pageBg: s.background,
    cardBg: c.color0,
    infoBg: c.color1,
  },
};

mkdirSync(dirname(outPath), { recursive: true });
writeFileSync(outPath, JSON.stringify(theme, null, 2) + "\n");
console.log(outPath);
