local utils = require("kustomize.utils")
local M = {}

M.find_kinds = function(bufNr)
  local q = require("vim.treesitter.query")

  local language_tree = vim.treesitter.get_parser(bufNr)
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()

  local query = vim.treesitter.parse_query(
    "yaml",
    [[
(
(document
(block_node
(block_mapping
(block_mapping_pair key: (flow_node) @key_name value: (flow_node) @value_name))))
  (#match? @key_name "kind")
) @value_name
]]
  )
  local kinds = {}
  for _, captures, _ in query:iter_matches(root, bufNr) do
    -- value_name is second capture
    table.insert(kinds, q.get_node_text(captures[2], bufNr))
  end
  return kinds
end

M.list = function()
  local bufNr = vim.api.nvim_win_get_buf(0)
  local ft = vim.api.nvim_buf_get_option(bufNr, "ft")
  if ft ~= "yaml" then
    utils.error("Expecting yaml file")
    return
  end
  local kinds = {}
  if not utils.is_treesitter_available(bufNr) then
    utils.error("cannot load nvim-treesitter")
    return
  end
  kinds = M.find_kinds(bufNr)
  local win, buf = utils.create_output()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, "Kinds #" .. buf)
  utils.delete_output_keybinding(win, buf)
  vim.api.nvim_buf_set_lines(buf, 0, 0, true, kinds)
end

return M
