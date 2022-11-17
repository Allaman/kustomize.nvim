local M = {}

M.setup = function()
  vim.keymap.set("n", "<leader>kb", "<cmd>lua require('kustomize.build').build()<cr>", { desc = "Kustomize build" })
  vim.keymap.set("n", "<leader>kk", "<cmd>lua require('kustomize.kinds').list()<cr>", { desc = "List kinds" })
end

return M
