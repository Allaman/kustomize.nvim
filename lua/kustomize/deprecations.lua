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
  -- TODO: move to init.lua?
  if not utils.is_module_available("plenary") then
    utils.error("Could not load https://github.com/nvim-lua/plenary.nvim")
  end
  if not utils.check_exec("kubent") then
    utils.error("kubent" .. " was not found on your path")
    return
  end
  local fileToValidate
  local t = os.tmpname()
  local tmpFile = t .. ".yaml"
  local bufName = vim.api.nvim_buf_get_name(0)
  if path:new(bufName):is_file() then
    -- file exists on disk
    fileToValidate = path:new({ bufName, sep = utils.path_separator() }):absolute()
  else
    -- if buffer content is not file on disk
    -- TODO: move to utils as it is also used in validation.lua
    local bufferData = vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {})
    fileToValidate = tmpFile
    local f = io.open(tmpFile, "w+b")
    if f ~= nil then
      local data = table.concat(bufferData, "\n")
      f:write(data)
      f:flush()
      if not f:close() then
        utils.warn("temporary file handler could not be closed")
      end
    end
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
  -- can create an empty file http://www.lua.org/manual/5.1/manual.html#pdf-os.tmpname
  -- TODO: error handlin?
  os.remove(t)
  os.remove(tmpFile)
end

return M
