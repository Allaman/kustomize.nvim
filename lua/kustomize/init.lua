local M = {}
local initialConfig = nil -- store the initial config

local utils = require("kustomize.utils")

local config = require("kustomize.config")

local build = require("kustomize.build")
local kinds = require("kustomize.kinds")
local resources = require("kustomize.resources")
local validate = require("kustomize.validate")
local deprecations = require("kustomize.deprecations")

---reload_config reloads the initial config of the plugin
---which the user expects. This reverts any changes to the
---config by calling commands/Lua APIs with arguments
local function reload_config()
  if initialConfig then
    config = vim.deepcopy(initialConfig, { noref = true })
  else
    utils.error("Initial configuration is not available.")
  end
end

---parseArguments processes arguments in the form key=value from either
---a command (e.g. KustomizeListKinds key=val) or from
---a Lua binding (e.g. :lua require("kustomize").kinds({key=val}))
---and returns a table of the form {key=arg} for all args
---@param ... unknown
---@return table
local function parseArguments(...)
  local args = { ... }
  local namedArgs = {}

  for _, arg in ipairs(args) do
    if type(arg) == "table" then
      -- handle Lua calls
      for key, value in pairs(arg) do
        namedArgs[key] = value
      end
    else
      -- handle command calls
      -- Split the argument on the first '=' character
      local key, value = arg:match("^(.-)=(.*)$")
      -- filter value must be of type table
      -- HACK when using kustomize.lua instead of kustomize.vim I can probably solve this more elegant???
      if key == "exclude_pattern" then
        local function eval(s)
          return assert(load(s))()
        end
        local function str2obj(s)
          return eval("return " .. s)
        end
        value = str2obj(value)
      end
      if key and value then
        namedArgs[key] = value
      end
    end
  end

  return namedArgs
end

M.build = function()
  build.build()
end

M.kinds = function(...)
  local namedArgs = parseArguments(...)

  -- overwrite config with provided arguments
  for key, value in pairs(namedArgs) do
    config.options.kinds[key] = value
  end

  kinds.list(config)

  reload_config()
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

M.deprecations = function(...)
  local namedArgs = parseArguments(...)

  -- overwrite config with provided arguments
  for key, value in pairs(namedArgs) do
    config.options.deprecations[key] = value
  end

  deprecations.check(config)

  reload_config()
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

-- reload the initial config which is loaded by setup()

M.setup = function(opts)
  if not utils.is_module_available("plenary") then
    utils.error("Could not load nvim-lua/plenary.nvim")
    return
  end
  -- Overwrite default config with user-supplied options
  for key, value in pairs(opts) do
    config.options[key] = value
  end

  if not initialConfig then
    initialConfig = vim.deepcopy(config, { noref = true }) -- Store the initial options on the first setup call
  end

  if config.options.enable_key_mappings then
    M.set_default_mappings()
  end

  if config.options.enable_lua_snip then
    if not utils.is_module_available("luasnip") then
      utils.error("Could not load L3MON4D3/LuaSnip")
      return
    end
    require("snippets").load_snippets()
  end
end

return M
