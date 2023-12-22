local utils = require("kustomize.utils")
local path = require("plenary.path")
local M = {}

---run 'kubent' command on the input file
---@param config table
---@param input string
---@return table, table
M.run_deprecations_check = function(config, input)
  local kube_version = config.options.deprecations.kube_version
  local Job = require("plenary.job")
  local job = Job:new({
    command = "kubent",
    args = { "-t", kube_version, "-c=false", "--helm3=false", "-l=error", "-e", "-f", input },
  })
  job:sync()
  return job:stderr_result(), job:result()
end

M.check = function(config)
  if not utils.check_exec("kubent") then
    utils.error("kubent" .. " was not found on your path")
    return
  end
  local fileToValidate
  local tmpFile = utils.create_temp_file_string("yaml")
  local bufName = vim.api.nvim_buf_get_name(0)
  local is_file = path:new(bufName):is_file()
  if is_file then
    -- file exists on disk
    fileToValidate = path:new({ bufName, sep = utils.path_separator() }):absolute()
  else
    -- if buffer content is not file on disk
    fileToValidate = tmpFile
    utils.create_file_from_current_buffer_content(tmpFile)
  end
  local err, out = M.run_deprecations_check(config, fileToValidate)
  if next(err) ~= nil then
    local err_msg = table.concat(err, "\n")
    utils.error("Failed with: " .. err_msg)
  elseif next(out) ~= nil then
    local out_msg = table.concat(out, "\n")
    utils.info("Deprecations found:\n" .. out_msg)
  elseif next(out) == nil then
    utils.info("No deprecations found!")
  end
  if not is_file then
    utils.delete_file(tmpFile)
  end
end

return M
