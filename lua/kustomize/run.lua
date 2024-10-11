local utils = require("kustomize.utils")
local path = require("plenary.path")
local M = {}

---comment
---@param cmd string
---@param args table
---@param timeout number
---@return table
---@return table
M.run = function(cmd, args, timeout)
  if not utils.check_exec(cmd) then
    return { "cmd was not found on path" }, {}
  end

  local file_to_validate
  local tmpFile = utils.create_temp_file_string("yaml")
  local bufName = vim.api.nvim_buf_get_name(0)
  local is_file = path:new(bufName):is_file()

  if is_file then
    -- file exists on disk
    file_to_validate = path:new({ bufName, sep = utils.path_separator() }):absolute()
  else
    -- if buffer content is not file on disk
    file_to_validate = tmpFile
    utils.create_file_from_current_buffer_content(tmpFile)
  end

  table.insert(args, file_to_validate)

  utils.info("Running: " .. cmd .. " " .. vim.inspect(args) .. "timeout: " .. timeout)
  local Job = require("plenary.job")
  local job = Job:new({
    command = cmd,
    args = args,
  })
  job:sync(timeout)
  local err, out = job:stderr_result(), job:result()

  -- Removes `file_to_validate` so that a second call does not include the first file_to_validate
  table.remove(args)

  if not is_file then
    utils.delete_file(tmpFile)
  end

  return err, out
end

M.run_checked = function(cmd, args, timeout)
  local err, out = M.run(cmd, args, timeout)

  if next(err) ~= nil then
    local err_msg = table.concat(err, "\n")
    utils.error("Failed " .. cmd .. " with:\n" .. err_msg)
  elseif next(out) ~= nil then
    local out_msg = table.concat(out, "\n")
    utils.warn("Output from " .. cmd .. ":\n" .. out_msg)
  elseif next(out) == nil then
    utils.info("No output captured from " .. cmd)
  end
end

return M
