local utils = require("kustomize.utils")
local config = require("kustomize.config")
local M = {}

---configure buffer for output
---@return integer
local function configure_buffer()
  local win, buf = utils.create_output()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, "Kustomize #" .. buf)
  vim.api.nvim_set_option_value("filetype", "yaml", { buf = buf })
  utils.delete_output_keybinding(win, buf)
  return buf
end

---run 'kustomize build' in the provided directory
---@param dirName string
---@return table
---@return table
local function kustomize_build(dirName)
  local additional_args = config.options.build.additional_args
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
M.build = function()
  if not utils.check_exec("kustomize") then
    utils.error("kustomize was not found on your PATH")
    return
  end
  local bufName = vim.api.nvim_buf_get_name(0)
  local dirName = vim.fs.dirname(bufName)
  if dirName == nil then
    return
  end
  local err, manifest = kustomize_build(dirName)
  -- https://stackoverflow.com/questions/1252539/most-efficient-way-to-determine-if-a-lua-table-is-empty-contains-no-entries
  if next(err) ~= nil then
    local err_msg = table.concat(err, "\n")
    utils.error("Failed with error " .. err_msg)
    return
  end
  local buf = configure_buffer()
  vim.api.nvim_buf_set_lines(buf, -1, -1, true, manifest)
end

if _TEST then
  -- export function only for unit testing
  M._kustomize_build = kustomize_build
end

return M
