local utils = require("kustomize.utils")
local M = {}

M.find_kinds = function(content)
  local kinds = {}
  for _, line in pairs(content) do
    local kind = string.match(line, "^kind:%s*(%a+).*")
    table.insert(kinds, kind)
  end
  return kinds
end

M.list = function()
  local bufnr = vim.api.nvim_win_get_buf(0)
  local ft = vim.api.nvim_buf_get_option(bufnr, "ft")
  if ft ~= "yaml" then
    error("Expecting yaml file")
  end
  local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local kinds = M.find_kinds(content)
  local win, buf = utils.create_output()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, "Kinds #" .. buf)
  utils.delete_output_keybinding(win, buf)
  vim.api.nvim_buf_set_lines(buf, 0, 0, true, kinds)
end

return M
