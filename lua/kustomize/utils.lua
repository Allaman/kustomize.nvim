M = {}

M.warn = function(msg)
  vim.notify(msg, vim.log.levels.WARN, { title = "TodoComments" })
end

M.error = function(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "TodoComments" })
end

M.check_exec = function(command)
  if vim.fn.executable(command) ~= 1 then
    error(command .. " was not found on your path")
    return false
  end
  return true
end

return M
