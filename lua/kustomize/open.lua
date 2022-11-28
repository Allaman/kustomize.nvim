local utils = require("kustomize.utils")
M = {}

local function get_visual_selection()
  -- v is like '< except it's always updated
  local vstart = vim.fn.getpos("v")
  -- . is line '> and is the current cursor position aka the end of the visual selection
  local vend = vim.fn.getpos(".")
  local column_start = vstart[3]
  local line_start = vstart[2]
  local column_end = vend[3]
  local line_end = vend[2]
  local number_lines = math.abs(line_end - line_start) + 1
  local selectedString
  if number_lines == 1 then
    selectedString = vim.api.nvim_buf_get_text(0, line_start - 1, column_start - 1, line_end - 1, column_end, {})
  else
    utils.error("Only one line selection is supported")
  end
  return table.concat(selectedString, "\n")
end

local function join_paths(a, b)
  local path = require("plenary.path")
  local file = path:new(a, b)
  local absolute = path:new({ file, sep = utils.path_separator() }):absolute()
  return absolute
end

M.open = function()
  if not (utils.check_plenary()) then
    return
  end
  local path = require("plenary.path")
  local selectedString = get_visual_selection()
  if not selectedString then
    return
  end

  local bufName = vim.api.nvim_buf_get_name(0)
  local fileName = vim.fs.basename(bufName)
  local dirName = vim.fs.dirname(bufName)

  if utils.is_kustomization_yaml(fileName) then
    if path:new(dirName, selectedString):is_file() then
      local absolute = join_paths(dirName, selectedString)
      vim.api.nvim_command("edit " .. absolute)
    elseif path:new(dirName, selectedString):is_dir() then
      local absolute = join_paths(dirName, selectedString)
      vim.api.nvim_command("E " .. absolute)
    else
      utils.warn("This is not a valid file or directory: " .. selectedString)
    end
  else
    utils.error("Buffer is not a kustomization.y(a)ml")
  end
end

return M
