#!/usr/bin/env node
import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
import { dirname } from "node:path";

const home = process.env.HOME || "/home/0xShred";
const walPath = `${home}/.cache/wal/colors.json`;
const outPath = `${home}/.pi/agent/themes/pywal.json`;

const wal = JSON.parse(readFileSync(walPath, "utf8"));
const c = wal.colors;
const s = wal.special;

function getLuminance(hex) {
  const num = parseInt(hex.replace("#", ""), 16);
  const r = (num >> 16) & 255;
  const g = (num >> 8) & 255;
  const b = num & 255;
  return (0.299 * r + 0.587 * g + 0.114 * b) / 255;
}

function adjustBg(hex) {
  const isDark = getLuminance(hex) < 0.5;
  const num = parseInt(hex.replace("#", ""), 16);
  const r = (num >> 16) & 255;
  const g = (num >> 8) & 255;
  const b = num & 255;
  if (isDark) {
    const nr = Math.min(255, r + 24);
    const ng = Math.min(255, g + 24);
    const nb = Math.min(255, b + 32);
    return `#${((1 << 24) + (nr << 16) + (ng << 8) + nb).toString(16).slice(1)}`;
  } else {
    const nr = Math.max(0, r - 25);
    const ng = Math.max(0, g - 25);
    const nb = Math.max(0, b - 25);
    return `#${((1 << 24) + (nr << 16) + (ng << 8) + nb).toString(16).slice(1)}`;
  }
}

const isDark = getLuminance(s.background) < 0.5;
const userMsgBg = adjustBg(s.background);
const userMsgText = isDark ? "#ffffff" : "#000000";

const theme = {
  $schema: "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json",
  name: "pywal",
  vars: {
    bg: s.background,
    fg: s.foreground,
    cursor: s.cursor,
    userMsgBg,
    userMsgText,
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

    selectedBg: "userMsgBg",
    scrollbarThumb: "gray",
    searchMatchBg: "yellow",
    searchMatchText: "bg",
    userMessageBg: "userMsgBg",
    userMessageText: "userMsgText",
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
    cardBg: userMsgBg,
    infoBg: c.color1,
  },
};

mkdirSync(dirname(outPath), { recursive: true });
writeFileSync(outPath, JSON.stringify(theme, null, 2) + "\n");
console.log(outPath);
