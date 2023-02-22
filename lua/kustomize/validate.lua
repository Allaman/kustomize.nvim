local utils = require("kustomize.utils")
local path = require("plenary.path")
local M = {}

---run 'kubeconform' on the input file
---@param fileToValidate string
---@return table
M.run_validation = function(fileToValidate)
  local Job = require("plenary.job")
  local job = Job:new({
    command = "kubeconform",
    args = { "--ignore-missing-schemas", "--strict", fileToValidate },
  })
  job:sync()
  return job:result()
end

M.validate = function()
  -- TODO: move to init.lua?
  if not utils.is_module_available("plenary") then
    utils.error("Could not load https://github.com/nvim-lua/plenary.nvim")
  end
  if not utils.check_exec("kubeconform") then
    utils.error("kubeconform" .. " was not found on your path")
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
  local out = M.run_validation(fileToValidate)
  local err_msg = table.concat(out, "\n")
  if not utils.isempty(err_msg) then
    utils.error("Failed with: " .. err_msg)
  else
    utils.info("no issues found")
  end
  -- can create an empty file http://www.lua.org/manual/5.1/manual.html#pdf-os.tmpname
  -- TODO: error handlin?
  os.remove(t)
  os.remove(tmpFile)
end

return M
