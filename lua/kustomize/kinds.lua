local utils = require("kustomize.utils")
local M = {}

---find all 'kind:' keys and the according metadata.name value
---@param bufNr integer
---@return table
M.find_kinds = function(bufNr)
  local q = require("vim.treesitter.query")
  local t = require("vim.treesitter")

  local language_tree = vim.treesitter.get_parser(bufNr)
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()

  -- the "?" in line 16 leads to a match, even if a match for the second "block_mapping_pair" can not be found
  -- e.g. in the case of "Kustomization" resources, where no "name" key is specified
  local query = q.parse(
    "yaml",
    [[
(
(document
(block_node
(block_mapping
(block_mapping_pair
  key: (flow_node) @kind_key_name
  value: (flow_node) @kind_value (#match? @kind_key_name "kind") )
(block_mapping_pair
  key: (flow_node) @metadata (#match? @metadata "metadata")
  value: (block_node
    (block_mapping
      (block_mapping_pair
        key: (flow_node) @key_name
        value: (flow_node) @name_value (#match? @key_name "name$"))))
))))
) @name_value @kind_value
]]
  )
  local kinds = {}
  -- https://alpha2phi.medium.com/neovim-101-tree-sitter-d8c5a714cb03
  for _, captures, _ in query:iter_matches(root, bufNr) do
    -- second return value is col
    local row, _ = captures[1]:start()
    local kind = t.get_node_text(captures[2], bufNr)
    local kind_name = t.get_node_text(captures[5], bufNr)
    -- captures[1] = "kind"
    -- captures[2] = kind_value
    -- captures[3] = "name"
    -- captures[4] = "metadata"
    -- captures[5] = name_value
    table.insert(kinds, { kind, kind_name, row })
  end
  return kinds -- { {"kind", "name", line}, ... }
end

---create a loclist filled with kinds
---@param items table
M.set_list = function(items)
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
      lnum = kind[3],
      text = kind[1] .. " - " .. kind[2],
    }
    table.insert(kinds, item)
  end
  utils.info("found " .. utils.table_length(kinds) .. " resources")
  if utils.table_length(kinds) > 0 then
    M.set_list(kinds)
  end
end

return M
