local utils = require("kustomize.utils")
local scan = require("plenary.scandir")
local path = require("plenary.path")

local M = {}

M.resources = function()
  if not utils.is_module_available("plenary") then
    utils.error("Could not load https://github.com/nvim-lua/plenary.nvim")
    return
  end
  local bufName = vim.api.nvim_buf_get_name(0)
  local fileName = vim.fs.basename(bufName)
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
