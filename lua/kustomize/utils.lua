local M = {}

---info notification
---@param msg string
M.info = function(msg)
  vim.notify(msg, vim.log.levels.INFO, { title = "Kustomize.nvim" })
end

---warning notification
---@param msg string
M.warn = function(msg)
  vim.notify(msg, vim.log.levels.WARN, { title = "Kustomize.nvim" })
end

---error notification
---@param msg string
M.error = function(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "Kustomize.nvim" })
end

---checks if a string is empty
---@param s string
---@return boolean
M.isempty = function(s)
  return s == nil or s == ""
end

---returns the number of items in a table
---@param t table
---@return integer
M.table_length = function(t)
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

---returns OS dependant path separator
---@return string
M.path_separator = function()
  local is_windows = vim.fn.has("win32") == 1
  if is_windows == true then
    return "\\"
  else
    return "/"
  end
end

---delete a buffer
---@param win integer
---@param buf integer
M.delete_output = function(win, buf)
  vim.api.nvim_win_close(win, true)
  vim.api.nvim_buf_delete(buf, { force = true })
end

---create keybinding for a buffer
---@param win integer
---@param buf integer
M.delete_output_keybinding = function(win, buf)
  vim.keymap.set("n", "q", function()
    M.delete_output(win, buf)
  end, { buffer = buf })
end

---create a vsplit buffer in the current window
---@return integer
---@return integer
M.create_output = function()
  vim.api.nvim_command("vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  return win, buf
end

---checks if treesitter is available
---@param bufNr integer
---@return boolean
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

---checks if a command is available on the host
---@param command string
---@return boolean
M.check_exec = function(command)
  if vim.fn.executable(command) ~= 1 then
    return false
  end
  return true
end

---checks if fileName is a Kustomization file
---@param fileName string
---@return boolean
M.is_kustomization_yaml = function(fileName)
  return fileName == "kustomization.yaml" or fileName == "kustomization.yml"
end

---checks if a module is available
---@param module string
---@return boolean
M.is_module_available = function(module)
  local ok = pcall(require, module)
  if not ok then
    return false
  end
  return true
end

--- Check if the minimum Neovim version is satisfied
--- Expects only the minor version, e.g. "9" for 0.9.1
---@param version number
---@return boolean
M.is_neovim_version_satisfied = function(version)
  return version <= tonumber(vim.version().minor)
end

---create_temp_file creates a temporary file name
---@param extension string|nil
---@return string
M.create_temp_file_string = function(extension)
  local t = os.tmpname()
  -- could create an empty file http://www.lua.org/manual/5.1/manual.html#pdf-os.tmpname
  os.remove(t)
  if extension == nil then
    return t
  end
  return t .. "." .. extension
end

---delete_file deletes a file
---@param file string
M.delete_file = function(file)
  local ok, message
  -- can create an empty file http://www.lua.org/manual/5.1/manual.html#pdf-os.tmpname
  ok, message = os.remove(file)
  if not ok then
    assert(type(message) == "string")
    M.error("could not delete file: " .. message)
  end
end

---create_file_from_current_buffer_content creates a file with the current buffer's content
---@param file_name string
M.create_file_from_current_buffer_content = function(file_name)
  local bufferData = vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {})
  local f, message = io.open(file_name, "w+b")
  if f ~= nil then
    local data = table.concat(bufferData, "\n")
    f:write(data)
    f:flush()
    if not f:close() then
      M.warn("temporary file handler could not be closed")
    end
  else
    assert(type(message) == "string")
    M.error("could not open file: " .. message)
    return
  end
end

-- Helper function to set a nested value in a table
local function set_nested_value(tbl, path, value)
  local current = tbl
  local path_parts = vim.split(path, ".", { plain = true })

  for i = 1, #path_parts - 1 do
    local key = path_parts[i]
    if current[key] == nil then
      current[key] = {}
    elseif type(current[key]) ~= "table" then
      current[key] = {}
    end
    current = current[key]
  end

  local final_key = path_parts[#path_parts]
  current[final_key] = value
end

-- Convert string values to appropriate types
local function convert_value(value)
  -- Handle boolean values
  if value == "true" then
    return true
  elseif value == "false" then
    return false
  end

  -- Handle numeric values
  local num_value = tonumber(value)
  if num_value then
    return num_value
  end

  -- Return the original string for everything else
  return value
end

-- Parse arguments string and merge with the build configuration
function M.parse_and_merge_config(args_str, build_config)
  -- If no arguments, return the build config unchanged
  if not args_str or args_str == "" then
    return vim.deepcopy(build_config)
  end

  local modified_config = vim.deepcopy(build_config)
  local args_list = vim.split(args_str, " ", { trimempty = true })

  for _, arg in ipairs(args_list) do
    -- Check if the argument contains a key=value pair
    local eq_pos = arg:find("=")
    if not eq_pos then
      M.warn("Invalid argument format (missing =): " .. arg)
      goto continue
    end

    local key = arg:sub(1, eq_pos - 1)
    local value = arg:sub(eq_pos + 1)

    -- Special handling for additional_args to ensure it's always a table
    if key == "additional_args" then
      -- Split by comma if present, otherwise make a single-element table
      local args_table = {}
      if value:find(",") then
        args_table = vim.split(value, ",", { plain = true })
      else
        table.insert(args_table, value)
      end
      value = args_table
    else
      -- Handle list values (comma-separated) for other keys
      if value:find(",") then
        local list_values = vim.split(value, ",", { plain = true })
        -- Convert each value in the list
        for i, item in ipairs(list_values) do
          list_values[i] = convert_value(item)
        end
        value = list_values
      else
        value = convert_value(value)
      end
    end

    -- Set the value in the config
    set_nested_value(modified_config, key, value)

    ::continue::
  end

  return modified_config
end

---reload_config reloads the initial config of the plugin
---which the user expects. This reverts any changes to the
---config by calling commands/Lua APIs with arguments
M.reload_config = function()
  local config = require("kustomize.config")

  if KUSTOMIZE_INITIAL_CONFIG then
    -- in place modification instead of
    -- config = vim.deepcopy(KUSTOMIZE_INITIAL_CONFIG)
    for k, v in pairs(KUSTOMIZE_INITIAL_CONFIG) do
      config[k] = vim.deepcopy(v)
    end
  else
    M.error("Initial configuration is not available.")
  end
end

M.auto_close_loclist = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
      -- Check if this is a location list (not a quickfix list)
      local is_loclist = vim.fn.getwininfo(vim.fn.win_getid())[1].loclist == 1

      if is_loclist then
        -- Get the location list title
        local loc_title = vim.fn.getloclist(0, { title = 0 }).title

        -- Check if the title contains your plugin's name or identifier
        if loc_title:match("Kustomize") then
          vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:lclose<CR>", { noremap = true, silent = true })
        end
      end
    end,
  })
end

return M
