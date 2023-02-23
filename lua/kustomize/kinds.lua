local utils = require("kustomize.utils")
local M = {}

---find all 'kind:' keys in a YAML buffer
---@param bufNr integer
---@return table
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
(block_mapping_pair key: (flow_node) @key_name value: (flow_node) @value_name) (#offset! @value_name))))
  (#match? @key_name "kind")
) @value_name
]]
  )
  local kinds = {}
  -- https://alpha2phi.medium.com/neovim-101-tree-sitter-d8c5a714cb03
  for _, captures, _ in query:iter_matches(root, bufNr) do
    -- second return value is col
    local row, _, _ = captures[1]:start()
    -- value_name is second capture
    table.insert(kinds, { q.get_node_text(captures[2], bufNr), row })
  end
  return kinds -- { {"kind", line}, ... }
end

---create a loclist filled with kinds
---@param items table
M.set_list = function(items)
  utils.info("found " .. utils.table_length(items) .. " resources")
  vim.fn.setloclist(0, {}, " ", { title = "Kustomize", items = items })
  -- vim.cmd.lopen({ args = { '"5"' } }) not working
  vim.cmd("lopen 20")
end

M.list = function()
  local bufNr = vim.api.nvim_win_get_buf(0)
  local ft = vim.api.nvim_buf_get_option(bufNr, "ft")
  if ft ~= "yaml" then
    utils.error("Expecting yaml file")
    return
  end
  if not utils.is_treesitter_available(bufNr) then
    utils.error("cannot load nvim-treesitter")
    return
  end
  local kinds_list = M.find_kinds(bufNr)
  local kinds = {}
  for _, kind in ipairs(kinds_list) do
    local item = {
      bufnr = bufNr,
      lnum = kind[2],
      text = kind[1],
    }
    table.insert(kinds, item)
  end
  M.set_list(kinds)
end

return M
