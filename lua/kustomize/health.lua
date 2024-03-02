local M = {}

local utils = require("kustomize.utils")

local health = vim.health
local _ok = health.ok
local _warn = health.warn
local _error = health.error

local programs = {
  kustomize = {
    required = false,
    desc = "required for building Kubernetes manifests from a kustomization.yaml",
  },
  kubeconform = {
    required = false,
    desc = "required for validating Kubernetes manifests",
  },
  kubent = {
    required = false,
    desc = "required for checking Kubernetes manifests for deprecations",
  },
}

local exec_not_found_template = "'%s' executable not found - %s"
local exec_found_template = "'%s' executable found"

M.check = function()
  vim.health.start("System configuration")

  if not utils.is_neovim_version_satisfied(9) then
    _warn("This config probably won't work very well with Neovim < 0.9")
  else
    _ok("This config will work with your Neovim version")
  end

  if not utils.is_module_available("plenary") then
    _error("this plugin requires nvim-lua/plenary.nvim")
  else
    _ok("nvim-lua/plenary.nvim found")
  end

  if not utils.is_module_available("plenary") then
    _error("this plugin requires nvim-lua/plenary.nvim")
  else
    _ok("nvim-lua/plenary.nvim found")
  end

  if not utils.is_module_available("luasnip") then
    _warn("this plugin (optionally) requires L3MON4D3/LuaSnip for LuaSnip integration")
  else
    _ok("L3MON4D3/LuaSnip found")
  end

  local ok, _ = pcall(require, "nvim-treesitter")
  if not ok then
    _error("this plugin requires nvim-treesitter/nvim-treesitter")
  else
    _ok("nvim-treesitter/nvim-treesitter found")
  end

  for k, v in pairs(programs) do
    if not utils.is_executable_available(k) then
      if v.required then
        _error(string.format(exec_not_found_template, k, v.desc))
      else
        _warn(string.format(exec_not_found_template, k, v.desc))
      end
    else
      _ok(string.format(exec_found_template, k))
    end
  end
end

return M
