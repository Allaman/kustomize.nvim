local utils = require("kustomize.utils")
local M = {}

M.list = function()
  local bufnr = vim.api.nvim_win_get_buf(0)
  local ft = vim.api.nvim_buf_get_option(bufnr, "ft")
  if ft ~= "yaml" then
    error("Expecting yaml file")
  end
  local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local kinds = {}
  for _, line in pairs(content) do
    local kind = string.match(line, "^kind:%s*(%a+).*")
    table.insert(kinds, kind)
  end
  local win, buf = utils.create_output()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, "Kinds #" .. buf)
  vim.keymap.set("n", "q", function()
    utils.delete_output(win, buf)
  end, { buffer = buf })
  vim.api.nvim_buf_set_lines(buf, 0, 0, true, kinds)
end

return M
