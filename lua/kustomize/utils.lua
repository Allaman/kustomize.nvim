M = {}

M.warn = function(msg)
  vim.notify(msg, vim.log.levels.WARN, { title = "TodoComments" })
end

M.error = function(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "TodoComments" })
end

M.path_separator = function()
  local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
  if is_windows == true then
    return "\\"
  else
    return "/"
  end
end

M.check_exec = function(command)
  if vim.fn.executable(command) ~= 1 then
    error(command .. " was not found on your path")
    return false
  end
  return true
end

M.is_kustomization_yaml = function(fileName)
  return fileName == "kustomization.yaml" or fileName == "kustomization.yml"
end
return M
