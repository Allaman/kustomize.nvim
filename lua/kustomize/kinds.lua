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

  local query_without_namespace = q.parse(
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

  local query_with_namespace = q.parse(
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
        key: (flow_node) @name_key_name
        value: (flow_node) @name_value (#match? @name_key_name "name$"))
      (block_mapping_pair
        key: (flow_node) @namespace_key_name
        value: (flow_node) @namespace_value (#match? @namespace_key_name "namespace"))
      )
    )
))))
) @name_value @kind_value @namespace_value
]]
  )

  local kinds = {}
  local matched_rows = {} -- Track the rows that have been matched
  local unsorted_matches = {} -- Temporarily store matches here

  -- Iterate over the first query matches
  for _, captures, _ in query_with_namespace:iter_matches(root, bufNr) do
    local row, _ = captures[1]:start()
    local kind = t.get_node_text(captures[2], bufNr)
    local kind_name = t.get_node_text(captures[5], bufNr)
    local namespace = t.get_node_text(captures[7], bufNr)
    table.insert(unsorted_matches, { kind, kind_name, namespace, row })
    matched_rows[row] = true
  end

  -- Iterate over the second query matches
  for _, captures, _ in query_without_namespace:iter_matches(root, bufNr) do
    local row, _ = captures[1]:start()
    if not matched_rows[row] then -- Only process if row hasn't been matched already
      local kind = t.get_node_text(captures[2], bufNr)
      local kind_name = t.get_node_text(captures[5], bufNr)
      table.insert(unsorted_matches, { kind, kind_name, "", row }) -- Empty namespace
    end
  end

  -- Sort the matches by row number and populate the 'kinds' table
  table.sort(unsorted_matches, function(a, b)
    return a[4] < b[4]
  end)
  for _, match in ipairs(unsorted_matches) do
    table.insert(kinds, match)
  end

  return kinds -- { {"kind", "name", "namespace", line}, ... }
end

---create a loclist filled with kinds
---@param items table
M.set_list = function(items)
  vim.fn.setloclist(0, {}, " ", { title = "Kustomize", items = items })
  -- vim.cmd.lopen({ args = { '"5"' } }) not working
  vim.cmd("lopen 20")
end

M.list = function(config)
  local show_filepath = config.options.kinds.show_filepath
  local show_line = config.options.kinds.show_line
  local bufNr = vim.api.nvim_win_get_buf(0)
  if not utils.is_treesitter_available(bufNr) then
    utils.error("cannot load nvim-treesitter")
    return
  end
  local kinds_list = M.find_kinds(bufNr)
  local kinds = {}
  for _, kind in ipairs(kinds_list) do
    local item = {
      bufnr = bufNr,
      lnum = kind[4],
      text = kind[1] .. " - " .. kind[2],
    }
    if kind[3] ~= "" then
      item.text = item.text .. " - " .. kind[3]
    end
    if not show_filepath then
      item.bufnr = ""
    end
    if not show_line then
      item.lnum = 0
    end
    table.insert(kinds, item)
  end
  utils.info("found " .. utils.table_length(kinds) .. " resources")
  if utils.table_length(kinds) > 0 then
    M.set_list(kinds)
  end
end

return M
