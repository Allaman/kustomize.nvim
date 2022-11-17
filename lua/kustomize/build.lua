M = {}

local Job = require("plenary.job")

local function create_output()
  vim.api.nvim_command("botright vnew")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, "Kustomize #" .. buf)
  vim.api.nvim_buf_set_option(buf, "filetype", "yaml")
  vim.keymap.set("n", "q", ":q<cr>", { buffer = buf })
  return buf
end

M.build = function()
  local bufName = vim.api.nvim_buf_get_name(0)
  local fileName = vim.fs.basename(bufName)
  local buf = create_output()
  if fileName == "kustomization.yaml" then
    local dirName = vim.fs.dirname(bufName)
    Job:new({
      command = "kustomize",
      args = { "build", "." },
      cwd = dirName,
      -- https://github.com/nvim-lua/plenary.nvim/issues/189
      on_stdout = vim.schedule_wrap(function(_, data)
        vim.api.nvim_buf_set_lines(buf, -1, -1, true, { data })
      end),
      on_stderr = function(_, data)
        error(data)
      end,
    }):sync()
  else
    vim.api.nvim_notify("Buffer is not a kustomization.yaml", 1, {})
  end
end

return M
