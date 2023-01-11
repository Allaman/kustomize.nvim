local M = {}

M.warn = function(msg)
  vim.notify(msg, vim.log.levels.WARN, { title = "Kustomize.nvim" })
end

M.error = function(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "Kustomize.nvim" })
end

M.path_separator = function()
  local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("unix") == 1
  if is_windows == true then
    return "\\"
  else
    return "/"
  end
end

M.delete_output = function(win, buf)
  vim.api.nvim_win_close(win, "force")
  vim.api.nvim_buf_delete(buf, { force = true })
end

M.delete_output_keybinding = function(win, buf)
  vim.keymap.set("n", "q", function()
    M.delete_output(win, buf)
  end, { buffer = buf })
end

M.create_output = function()
  vim.api.nvim_command("vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  return win, buf
end

M.is_treesitter_available = function(bufNr)
  local ok, _ = pcall(require, "nvim-treesitter")
  if not ok then
    return false
  end

  local highlighter = require("vim.treesitter.highlighter")
  if not highlighter.active[bufNr] then
    return false
  end
  return true
end

M.check_exec = function(command)
  if vim.fn.executable(command) ~= 1 then
    return false
  end
  return true
end

M.is_kustomization_yaml = function(fileName)
  return fileName == "kustomization.yaml" or fileName == "kustomization.yml"
end

M.is_module_available = function(module)
  local ok = pcall(require, module)
  if not ok then
    return false
  end
  return true
end

return M
