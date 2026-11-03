import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";
import { modelHintFor, modelPolicyError, resolveHarness } from "./shared/subagent-model-policy.ts";

// Enforce inheritance and current-family tier changes, not just prompt advice.
export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		if (
			!isToolCallEventType<"subagent_spawn", { model?: string; harness?: string }>(
				"subagent_spawn",
				event,
			)
		)
			return;
		const model = ctx.model;
		if (!model) return { block: true, reason: "No selected chat model to inherit." };
		if (typeof event.input.model === "string" && event.input.model.trim() !== "") {
			const reason = modelPolicyError(model, event.input.model.trim(), ctx.modelRegistry.getAvailable());
			if (reason) return { block: true, reason };
		}
		const harness = resolveHarness(
			model.provider,
			model.id,
			typeof event.input.harness === "string" ? event.input.harness : undefined,
		);
		if ((harness === "codex" && !/^gpt-|^o\d/.test(model.id))
			|| (harness === "claude" && !model.id.includes("claude"))) {
			return { block: true, reason: "Harness cannot preserve the selected model family. Use harness pi." };
		}
		event.input.harness = harness;
		const requested = event.input.model?.trim();
		event.input.model = requested
			? modelHintFor(harness, model.provider, requested.replace(`${model.provider}/`, ""))
			: modelHintFor(harness, model.provider, model.id);
	});
}
