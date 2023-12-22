local M = {}

local utils = require("kustomize.utils")

local config = require("kustomize.config")

local build = require("kustomize.build")
local kinds = require("kustomize.kinds")
local resources = require("kustomize.resources")
local validate = require("kustomize.validate")
local deprecations = require("kustomize.deprecations")

M.build = function()
  build.build()
end

M.kinds = function()
  kinds.list(config)
end

M.list_resources = function()
  resources.list()
end

M.print_resources = function()
  resources.print()
end

M.validate = function()
  validate.validate(config)
end

M.deprecations = function()
  deprecations.check(config)
end

M.set_default_mappings = function()
  vim.keymap.set("n", "<leader>kb", function()
    M.build()
  end, { desc = "Kustomize build" })

  vim.keymap.set("n", "<leader>kk", function()
    M.kinds()
  end, { desc = "List kinds" })

  vim.keymap.set("n", "<leader>kl", function()
    M.list_resources()
  end, { desc = "List resources" })

  vim.keymap.set("n", "<leader>kp", function()
    M.print_resources()
  end, { desc = "Print resources in folder" })

  vim.keymap.set("n", "<leader>kv", function()
    M.validate()
  end, { desc = "Validate manifests" })

  vim.keymap.set("n", "<leader>kd", function()
    M.deprecations()
  end, { desc = "Check for deprecations" })
end

M.setup = function(opts)
  if not utils.is_module_available("plenary") then
    utils.error("Could not load https://github.com/nvim-lua/plenary.nvim")
    return
  end
  -- Overwrite default config with user-supplied options
  for key, value in pairs(opts) do
    config.options[key] = value
  end

  if config.options.enable_key_mappings then
    M.set_default_mappings()
  end
end

return M
