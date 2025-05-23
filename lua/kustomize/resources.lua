local utils = require("kustomize.utils")
local scan = require("plenary.scandir")
local path = require("plenary.path")

local M = {}

---find all items of a 'resources:' key in a YAML buffer
---@param bufNr number
---@return table
function M.find_resources(bufNr)
  local q = require("vim.treesitter.query")
  local t = require("vim.treesitter")

  local language_tree = vim.treesitter.get_parser(bufNr)
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()

  local query = q.parse(
    "yaml",
    [[
(
(document
(block_node
(block_mapping
(block_mapping_pair key: (flow_node) @key_name value:
(block_node
(block_sequence
(block_sequence_item
(flow_node)@resource)))))))
  (#match? @key_name "resources")
) @resource
]]
  )
  ---@type table<string>
  local resources = {}
  -- TODO: https://github.com/neovim/neovim/commit/6913c5e1d975a11262d08b3339d50b579e6b6bb8
  -- {all = false} forces the old behavior
  for _, captures, _ in query:iter_matches(root, bufNr, 0, 0, { all = false }) do
    -- resource is second capture
    table.insert(resources, t.get_node_text(captures[2], bufNr))
  end
  return resources
end

M.list = function()
  local bufName = vim.api.nvim_buf_get_name(0)
  local bufNr = vim.api.nvim_win_get_buf(0)
  local fileName = vim.fs.basename(bufName)
  if fileName == nil then
    return
  end
  if not utils.is_kustomization_yaml(fileName) then
    utils.error("buffer is not a kustomization.y(a)ml")
    return
  end

  if not utils.is_treesitter_available(bufNr) then
    utils.error("could not load nvim-treesitter")
    return
  end
  local resources = M.find_resources(bufNr)
  ---@type table<{ filename: string }>
  local files = {}
  for _, r in ipairs(resources) do
    table.insert(files, { filename = M.build_paths(r) })
  end
  if next(files) == nil then
    utils.warn("could not find any resources in " .. bufName)
  else
    M.set_list(files)
  end
end

---create a vim.ui.select popup with found resources
---@param items table{<filename, string>}
M.set_list = function(items)
  -- Make sure items is a valid table
  if not items or type(items) ~= "table" or #items == 0 then
    utils.error("no items provided to select from")
    return
  end

  -- Extract just the filenames for display
  local paths = {}
  for _, item in ipairs(items) do
    if item and type(item) == "table" and item.filename then
      table.insert(paths, item.filename)
    end
  end

  if #paths == 0 then
    utils.error("no valid paths found in the provided items")
    return
  end

  vim.ui.select(paths, {
    prompt = "Select a file or directory:",
    format_item = function(p)
      -- Get the file/dir name for display (not the full path)
      local name = string.match(p, "([^/]+)/?$")
      if not name or name == "" then
        name = p -- Fallback to the full path if extraction fails
      end

      local stat = vim.uv.fs_stat(p)
      if stat and stat.type == "directory" then
        return name .. "/" -- Add trailing slash to indicate directories
      else
        return name
      end
    end,
  }, function(selected)
    if selected then
      local stat = vim.uv.fs_stat(selected)
      if not stat then
        utils.warn("path does not exist: " .. selected)
        return
      end

      if stat.type == "directory" then
        local has_neotree, _ = pcall(require, "neo-tree")
        if has_neotree then
          vim.cmd("Neotree float dir=" .. vim.fn.fnameescape(selected))
        else
          utils.info("Neo-tree not found, falling back to built-in explorer")
          vim.cmd("Explore " .. vim.fn.fnameescape(selected))
        end
      else
        -- For files, open the file
        vim.cmd("edit " .. vim.fn.fnameescape(selected))
      end
    end
  end)
end

---creates an absolute path from a resource item
---@param resource string
---@return any
M.build_paths = function(resource)
  local function join_paths(a, b)
    local file = path:new(a, b)
    local absolute = path:new({ file, sep = utils.path_separator() }):absolute()
    return absolute
  end
  local bufName = vim.api.nvim_buf_get_name(0)
  -- resources are relative to the current kustomization.yaml
  -- so we need to track the current directory to build a valid path
  local dirName = vim.fs.dirname(bufName)
  if path:new(dirName, resource):is_file() or path:new(dirName, resource):is_dir() then
    return join_paths(dirName, resource)
  else
    utils.warn("This is not a valid file or directory: " .. resource)
  end
end

M.print = function()
  local bufName = vim.api.nvim_buf_get_name(0)
  local fileName = vim.fs.basename(bufName)
  if fileName == nil then
    return
  end
  ---@type table<string>
  local resourceList = {}
  if utils.is_kustomization_yaml(fileName) then
    local dirName = vim.fs.dirname(bufName)
    local resources = scan.scan_dir(dirName, { hidden = false, depth = 1, add_dirs = true })
    for _, r in pairs(resources) do
      if not string.find(r, "kustomization") then
        local baseName = vim.fs.basename(r)
        if path:new(r):is_file() then
          table.insert(resourceList, "  - " .. baseName)
        elseif path:new(r):is_dir() then
          table.insert(resourceList, "  - " .. baseName .. "/")
        else
          utils.warn("This is not a valid file or directory: " .. r)
        end
      end
    end
  else
    utils.warn("Buffer is not a kustomization.y(a)ml")
  end
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row, row, true, resourceList)
end

return M
