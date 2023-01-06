local utils = require("kustomize.utils")
local M = {}

local function configure_buffer()
  local win, buf = utils.create_output()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, "Kustomize #" .. buf)
  vim.api.nvim_buf_set_option(buf, "filetype", "yaml")
  utils.delete_output_keybinding(win, buf)
  return buf
end

M.kustomize_build = function(dirName)
  local Job = require("plenary.job")
  local job = Job:new({
    command = "kustomize",
    args = { "build", "." },
    cwd = dirName,
  })
  job:sync()
  return job:stderr_result(), job:result()
end

M.build = function()
  if not utils.is_module_available("plenary") then
    utils.error("Could not load https://github.com/nvim-lua/plenary.nvim")
    return
  end
  if not utils.check_exec("kustomize") then
    utils.error("kustomize was not found on your PATH")
    return
  end
  local bufName = vim.api.nvim_buf_get_name(0)
  local fileName = vim.fs.basename(bufName)
  if not utils.is_kustomization_yaml(fileName) then
    utils.error("Buffer is not a kustomization.y(a)ml")
  end
  local dirName = vim.fs.dirname(bufName)
  local err, manifest = M.kustomize_build(dirName)
  -- https://stackoverflow.com/questions/1252539/most-efficient-way-to-determine-if-a-lua-table-is-empty-contains-no-entries
  if next(err) ~= nil then
    local err_string = table.concat(err, "\n")
    utils.error("Failed with error " .. err_string .. "\n")
    return
  end
  local buf = configure_buffer()
  vim.api.nvim_buf_set_lines(buf, -1, -1, true, manifest)
end

return M
