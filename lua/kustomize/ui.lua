-- Enhanced kustomize output display with configurable options
-- Modified to handle the specific input format from your paste
local M = {}

-- Internal state
local state = {
  last_buf = nil,
  last_win = nil,
}

-- Helper function to set up keymaps
local function setup_keymap(buf, key, action)
  if action == "close" then
    vim.api.nvim_buf_set_keymap(
      buf,
      "n",
      key,
      "<cmd>lua vim.api.nvim_win_close(0, true)<cr>",
      { noremap = true, desc = "Close window" }
    )
  elseif action == "save" then
    vim.api.nvim_buf_set_keymap(
      buf,
      "n",
      key,
      "<cmd>lua require('kustomize.ui').save_output()<cr>",
      { noremap = true, desc = "Save kustomize output" }
    )
  end
end

-- Function to display kustomize output with current configuration
M.display_output = function(content, config)
  -- Close previous window if it exists and is valid
  if state.last_win and vim.api.nvim_win_is_valid(state.last_win) then
    vim.api.nvim_win_close(state.last_win, true)
  end

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.api.nvim_set_option_value("filetype", "yaml", { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  vim.api.nvim_set_option_value("modifiable", config.buffer.modifiable, { buf = buf })
  vim.api.nvim_set_option_value("readonly", config.buffer.readonly, { buf = buf })
  vim.api.nvim_set_option_value("swapfile", config.buffer.swapfile, { buf = buf })

  -- Set buffer name
  vim.api.nvim_buf_set_name(buf, config.window.title .. " #" .. buf)

  -- Get window configuration
  local win_opts = {}
  local win

  if config.window.type == "float" then
    -- Calculate dimensions for floating window
    local width = math.floor(vim.o.columns * config.window.width)
    local height = math.floor(vim.o.lines * config.window.height)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    win_opts = {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = config.window.border,
      title = config.window.title,
      title_pos = config.window.title_pos,
    }

    win = vim.api.nvim_open_win(buf, true, win_opts)

    -- Set window options for floating window
    vim.api.nvim_set_option_value("winblend", config.window.blend, { win = win })
    vim.api.nvim_set_option_value("cursorline", true, { win = win })
  elseif config.window.type == "vsplit" then
    local width = math.floor(vim.o.columns * config.window.width)
    vim.cmd(width .. "vsplit")
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
  else
    local height = math.floor(vim.o.lines * config.window.height)
    vim.cmd(height .. "split")
    win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
  end

  -- Set up keymappings
  for action, keys in pairs(config.keymaps) do
    if type(keys) == "table" then
      for _, key in ipairs(keys) do
        setup_keymap(buf, key, action)
      end
    else
      setup_keymap(buf, keys, action)
    end
  end

  -- Store the buffer and window
  state.last_buf = buf
  state.last_win = win

  return buf, win
end

-- Save the current output to a file
M.save_output = function()
  if state.last_buf and vim.api.nvim_buf_is_valid(state.last_buf) then
    vim.ui.input({
      prompt = "Save to file: ",
      default = "kustomize-output.yaml",
    }, function(filename)
      if filename then
        local lines = vim.api.nvim_buf_get_lines(state.last_buf, 0, -1, false)
        vim.fn.writefile(lines, filename)
        vim.notify("Saved to " .. filename, vim.log.levels.INFO)
      end
    end)
  end
end

return M
