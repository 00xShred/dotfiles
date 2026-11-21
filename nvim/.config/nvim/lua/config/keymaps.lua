-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://www.lazyvim.org/keymaps
-- Add any additional keymaps here

vim.keymap.set({ "n", "x" }, "<leader>ca", function()
  require("tiny-code-action").code_action()
end, { desc = "Code Action" })

-- Quickfix-only code actions: real fixes, no refactor/assist noise from rust-analyzer
vim.keymap.set({ "n", "v" }, "<leader>cq", function()
  vim.lsp.buf.code_action({ context = { only = { "quickfix" } } })
end, { desc = "Code Action (quickfix)" })
