KUSTOMIZE_INITIAL_CONFIG = nil -- to store the initial config
local M = {}

local utils = require("kustomize.utils")
local config = require("kustomize.config")
local run = require("kustomize.run")

M.set_default_mappings = function()
  vim.keymap.set("n", "<leader>kb", "<cmd>KustomizeBuild<cr>", { desc = "Kustomize build" })

  vim.keymap.set("n", "<leader>kk", "<cmd>KustomizeListKinds<cr>", { desc = "List kinds" })

  vim.keymap.set("n", "<leader>kl", "<cmd>KustomizeListResources<cr>", { desc = "List resources" })

  vim.keymap.set("n", "<leader>kp", "<cmd>KustomizePrintResources<cr>", { desc = "Print resources in folder" })

  vim.keymap.set("n", "<leader>kv", function()
    local validate = config.options.run.validate
    run.run_checked(validate.cmd, validate.args, validate.timeout or 5000)
  end, { desc = "Validate manifests" })

  vim.keymap.set("n", "<leader>kd", function()
    local deprecate = config.options.run.deprecations
    run.run_checked(deprecate.cmd, deprecate.args, deprecate.timeout or 5000)
  end, { desc = "Check for deprecations" })
end

M.setup = function(opts)
  if not utils.is_module_available("plenary") then
    utils.error("Could not load nvim-lua/plenary.nvim")
    return
  end

  -- merge user options with default options
  config.options = vim.tbl_deep_extend("force", config.options, opts)

  if not KUSTOMIZE_INITIAL_CONFIG then
    KUSTOMIZE_INITIAL_CONFIG = vim.deepcopy(config, true) -- Store the initial options on the first setup call
  end

  if config.options.enable_key_mappings then
    M.set_default_mappings()
  end

  if config.options.kinds.auto_close then
    utils.auto_close_loclist()
  end

  if config.options.enable_lua_snip then
    if not utils.is_module_available("luasnip") then
      utils.error("Could not load L3MON4D3/LuaSnip")
      return
    end
    require("luasnip_kustomize_snippets").load_snippets()
  end
end

return M
