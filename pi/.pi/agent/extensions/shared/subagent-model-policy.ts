export type Harness = "pi" | "claude" | "codex";

/** In-process children preserve the selected provider and exact model. */
export function resolveHarness(_provider: string, _id: string, explicit?: string): Harness {
	return explicit === "claude" || explicit === "codex" ? explicit : "pi";
}

export function modelHintFor(harness: Harness, provider: string, id: string): string {
	return harness === "pi" ? `${provider}/${id}` : id;
}

function identity(id: string): { family: string; version: number[] } | undefined {
	const name = id.toLowerCase().split("/").at(-1)!;
	// Claude places its tier before the version; other families place it after.
	const match = name.match(/^(claude)(?:-(?:opus|sonnet|haiku))?-(\d+(?:[.-]\d+)*)/)
		?? name.match(/^(gpt|glm|gemini|qwen|deepseek|kimi)[- ]?(?:v|k)?(\d+(?:[.-]\d+)*)/);
	return match ? { family: match[1], version: match[2].split(/[.-]/).map(Number) } : undefined;
}

function compare(a: number[], b: number[]): number {
	for (let i = 0; i < Math.max(a.length, b.length); i++) {
		const difference = (a[i] ?? 0) - (b[i] ?? 0);
		if (difference) return difference;
	}
	return 0;
}

/** Exact inheritance always works; tier changes require a known, current family member. */
export function modelPolicyError(
	parent: { provider: string; id: string },
	requested: string,
	available: ReadonlyArray<{ provider: string; id: string }>,
): string | undefined {
	if (requested === parent.id || requested === `${parent.provider}/${parent.id}`) return;
	const source = identity(parent.id);
	const target = available.find(model => model.provider === parent.provider
		&& (requested === model.id || requested === `${model.provider}/${model.id}`));
	const candidate = target && identity(target.id);
	if (!source || !candidate || source.family !== candidate.family) {
		return "Subagents must stay in the selected model family and provider. Omit model and harness to inherit the chat model.";
	}
	const latest = available.reduce((version, model) => {
		const info = model.provider === parent.provider && identity(model.id);
		return info && info.family === source.family && compare(info.version, version) > 0 ? info.version : version;
	}, source.version);
	if (compare(candidate.version, latest) < 0) {
		return "Tier changes must use the latest available generation in the selected model family. Omit model and harness to inherit the chat model.";
	}
}
