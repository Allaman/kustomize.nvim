local utils = require("kustomize.utils")
local ui = require("kustomize.ui")
local M = {}

---run 'kustomize build' in the provided directory
---@param dirName string
---@param additional_args table
---@return table
---@return table
local function kustomize_build(dirName, additional_args)
  local Job = require("plenary.job")
  local job = Job:new({
    command = "kustomize",
    args = vim.list_extend({ "build", "." }, additional_args),
    cwd = dirName,
  })
  job:sync()
  return job:stderr_result(), job:result()
end

---run kustomize_build and display the result in a new buffer
M.build = function(config)
  if not utils.check_exec("kustomize") then
    utils.error("kustomize was not found on your PATH")
    return
  end
  local bufName = vim.api.nvim_buf_get_name(0)
  local dirName = vim.fs.dirname(bufName)
  if dirName == nil then
    return
  end
  local additional_args = config.additional_args or {}
  local err, manifest = kustomize_build(dirName, additional_args)
  -- https://stackoverflow.com/questions/1252539/most-efficient-way-to-determine-if-a-lua-table-is-empty-contains-no-entries
  if next(err) ~= nil then
    local err_msg = table.concat(err, "\n")
    if err_msg:match("^# Warning") then
      utils.warn(err_msg)
    else
      utils.error("Failed with error " .. err_msg)
      return
    end
  end
  ui.display_output(manifest, config.ui)
end

if _TEST then
  -- export function only for unit testing
  M._kustomize_build = kustomize_build
end

return M
