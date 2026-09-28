import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function extractParen(str: string, openIdx: number): { content: string; endIndex: number } | null {
	if (str[openIdx] !== "(") return null;
	let depth = 0;
	for (let i = openIdx; i < str.length; i++) {
		if (str[i] === '"') {
			i++;
			while (i < str.length && str[i] !== '"') {
				if (str[i] === "\\") i++;
				i++;
			}
			continue;
		}
		if (str[i] === "(") depth++;
		else if (str[i] === ")") {
			depth--;
			if (depth === 0) {
				return { content: str.slice(openIdx + 1, i), endIndex: i };
			}
		}
	}
	return null;
}

function transformUnderbraces(str: string): string {
	let res = "";
	let i = 0;
	while (i < str.length) {
		const match = str.slice(i).match(/^(underbrace|overbrace)\s*\(/);
		if (match) {
			const type = match[1];
			const openIdx = i + match[0].length - 1;
			const parsedBody = extractParen(str, openIdx);
			if (parsedBody) {
				const after = str.slice(parsedBody.endIndex + 1);
				let label = "";
				let nextIdx = parsedBody.endIndex + 1;
				const labelPrefixMatch = after.match(/^\s*([_^])?\s*\(/);
				if (labelPrefixMatch) {
					const labelOpenIdx = parsedBody.endIndex + 1 + labelPrefixMatch[0].length - 1;
					const parsedLabel = extractParen(str, labelOpenIdx);
					if (parsedLabel) {
						label = parsedLabel.content.trim();
						nextIdx = parsedLabel.endIndex + 1;
					}
				}

				let labelTex = label;
				if (labelTex.startsWith('"') && labelTex.endsWith('"')) {
					labelTex = "\\text{" + labelTex.slice(1, -1) + "}";
				}

				const isOver = type === "overbrace";
				const scriptOp = isOver ? "^" : "_";
				res += `\\${type}{${parsedBody.content}}${label ? `${scriptOp}{${labelTex}}` : ""}`;
				i = nextIdx;
				continue;
			}
		}
		res += str[i];
		i++;
	}
	return res;
}

const GREEK = new Set([
	"alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta",
	"iota", "kappa", "lambda", "mu", "nu", "xi", "pi", "rho", "sigma",
	"tau", "upsilon", "phi", "chi", "psi", "omega",
	"Gamma", "Delta", "Theta", "Lambda", "Xi", "Pi", "Sigma", "Upsilon", "Phi", "Psi", "Omega",
]);

const OP_MAP: Record<string, string> = {
	"join": "\\bowtie",
	"sect": "\\cap",
	"union": "\\cup",
	"subset": "\\subset",
	"supset": "\\supset",
	"subseteq": "\\subseteq",
	"supseteq": "\\supseteq",
	"in": "\\in",
	"notin": "\\notin",
	"approx": "\\approx",
	"equiv": "\\equiv",
	"dots": "\\dots",
	"arrow": "\\rightarrow",
	"arrow.l": "\\leftarrow",
	"arrow.r": "\\rightarrow",
	"arrow.l.r": "\\leftrightarrow",
	"arrow.double": "\\Rightarrow",
	"implies": "\\Rightarrow",
	"iff": "\\Leftrightarrow",
	"forall": "\\forall",
	"exists": "\\exists",
	"times": "\\times",
	"sum": "\\sum",
	"prod": "\\prod",
	"int": "\\int",
	"lim": "\\lim",
};

export function typstToLatexMath(math: string): string {
	let s = transformUnderbraces(math);

	// Convert string literals "..." into \text{...}
	s = s.replace(/"([^"]*)"/g, "\\text{$1}");

	// Relational algebra shorthand: sigma(D=1)(s) -> \sigma_{D=1}(s)
	s = s.replace(/\b(sigma|pi)\(([^)]+)\)/g, "\\$1_{$2}");

	// Convert subscripts like _(B=1) or _(label) to _{B=1}
	s = s.replace(/_\(([^)]+)\)/g, "_{$1}");
	s = s.replace(/\^\(([^)]+)\)/g, "^{$1}");
	s = s.replace(/\^([0-9a-zA-Z]{2,})/g, "^{$1}");

	// Replace Typst operators/keywords
	for (const [typ, tex] of Object.entries(OP_MAP)) {
		const re = new RegExp(`(?<![\\\\a-zA-Z])${typ.replace(".", "\\.")}(?![a-zA-Z])`, "g");
		s = s.replace(re, tex);
	}

	// Greek letters
	for (const g of GREEK) {
		const re = new RegExp(`(?<![\\\\a-zA-Z])${g}(?![a-zA-Z])`, "g");
		s = s.replace(re, "\\" + g);
	}

	return s;
}

function isMathExpression(inner: string): boolean {
	return /[\\_+^=<>≤≥≠≈×÷∈∉∪∩ΣΠ∫√∂⋈]|(\b(join|sect|union|subset|supset|subseteq|supseteq|sigma|pi|alpha|beta|gamma|delta|theta|lambda|mu|phi|omega|underbrace|overbrace|implies|iff|forall|exists)\b)/i.test(inner);
}

export function cleanMarkdown(markdown: string): string {
	// Preserve fenced code blocks and inline code
	const codeBlocks: string[] = [];
	let text = markdown.replace(/```[\s\S]*?```|`[^`\n]+`/g, (match) => {
		codeBlocks.push(match);
		return `\x00CODE${codeBlocks.length - 1}\x00`;
	});

	// Clean HTML
	text = text.replace(/<kbd>(.*?)<\/kbd>/gi, "`$1`");
	text = text.replace(/<br\s*\/?>/gi, "\n");

	// 1. Standalone block Typst / LaTeX math: $ ... $ alone on a line or multiline
	text = text.replace(/^([ \t]*)\$([ \t]+[\s\S]+?[ \t]+)\$([ \t]*)$/gm, (_match, pre, inner, post) => {
		const converted = typstToLatexMath(inner.trim());
		return `${pre}$$\n${converted}\n$$${post}`;
	});

	// 2. Inline math $...$
	text = text.replace(/(?<!\\)\$([^\n$]+?)(?<!\\)\$/g, (match, inner) => {
		// If it looks like currency ($10, $20, $5.50), leave it untouched!
		if (/^\s*\d+(?:\.\d+)?(?:\s*,\s*\d+)*\s*$/.test(inner) || !isMathExpression(inner)) {
			return match;
		}
		const trimmed = inner.trim();
		if (!trimmed) return match;

		const isTypst = /(?:join|sect|union|sigma|pi|underbrace|overbrace|implies|iff|subset|supset|\b(alpha|beta|gamma|delta|epsilon|theta|lambda|mu|pi|sigma|phi|omega)\b)/.test(trimmed);
		if (isTypst) {
			const converted = typstToLatexMath(trimmed);
			if (/\\(underbrace|overbrace)/.test(converted)) {
				return `\n\n$$\n${converted}\n$$\n\n`;
			}
			return `$${converted}$`;
		}
		// Normal LaTeX with possible leading/trailing spaces ($ \sigma $)
		return `$${trimmed}$`;
	});

	text = text.replace(/\x00CODE(\d+)\x00/g, (_, idx) => codeBlocks[Number(idx)]);
	return text;
}

export default function (pi: ExtensionAPI) {
	pi.registerMarkdownTransformer((markdown) => cleanMarkdown(markdown));
}
