import assert from "node:assert/strict";
import { test } from "node:test";
import { modelHintFor, modelPolicyError, resolveHarness } from "./subagent-model-policy.ts";

test("defaults to pi to preserve model and provider; explicit harness survives", () => {
	for (const provider of ["openai", "anthropic", "zai"]) {
		assert.equal(resolveHarness(provider, "any-model"), "pi");
	}
	assert.equal(resolveHarness("openai", "gpt-6.1-terra", "codex"), "codex");
	assert.equal(modelHintFor("pi", "zai", "glm-5.3"), "zai/glm-5.3");
	assert.equal(modelHintFor("codex", "openai", "gpt-6.1-terra"), "gpt-6.1-terra");
});

const parent = { provider: "openai", id: "gpt-6.1-terra" };
const available = ["gpt-5.6-sol", "gpt-6.1-luna", "gpt-6.1-sol", "glm-6.1"].map(id => ({ provider: "openai", id }));

test("inherits exact selection, permits current tiers, blocks old and foreign models", () => {
	assert.equal(modelPolicyError(parent, parent.id, []), undefined);
	assert.equal(modelPolicyError(parent, `openai/${parent.id}`, []), undefined);
	for (const id of ["gpt-6.1-luna", "openai/gpt-6.1-sol"]) {
		assert.equal(modelPolicyError(parent, id, available), undefined);
	}
	for (const id of ["gpt-5.6-sol", "glm-6.1", "sonnet", "other/gpt-6.1-sol"]) {
		assert.ok(modelPolicyError(parent, id, available));
	}
});

test("latest registered generation, not stale hardcoded IDs, governs tier changes", () => {
	assert.ok(modelPolicyError(parent, "gpt-6.1-luna", [...available, { provider: "openai", id: "gpt-6.2-luna" }]));
	const glm = { provider: "zai", id: "glm-5.3" };
	assert.equal(modelPolicyError(glm, "glm-5.3-flash", [{ ...glm, id: "glm-5.3-flash" }]), undefined);
	assert.ok(modelPolicyError(glm, "glm-4.7-flash", [{ ...glm, id: "glm-4.7-flash" }]));
	const claude = { provider: "anthropic", id: "claude-opus-4-6" };
	assert.equal(modelPolicyError(claude, "claude-haiku-4-6", [{ ...claude, id: "claude-haiku-4-6" }]), undefined);
	assert.ok(modelPolicyError(claude, "claude-haiku-4-5", [{ ...claude, id: "claude-haiku-4-5" }]));
});
