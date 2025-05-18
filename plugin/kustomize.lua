local config = require("kustomize.config")
local utils = require("kustomize.utils")

local function run_complete(argLead)
  local choices = {}
  for key, _ in pairs(config.options.run) do
    table.insert(choices, key)
  end

  -- Filter options based on the current argument lead
  local filtered = vim.tbl_filter(function(option)
    return vim.startswith(option, argLead)
  end, choices)

  return filtered
end

vim.api.nvim_create_user_command("KustomizeRun", function(opts)
  local run = require("kustomize.run")
  local choice = opts.fargs[1]
  local cmd = config.options.run[choice].cmd
  local args = config.options.run[choice].args
  local timeout = config.options.run[choice].timeout or 5000
  run.run_checked(cmd, args, timeout)
end, {
  desc = "Run commands",
  nargs = 1,
  complete = run_complete, -- Use our completion function
})

vim.api.nvim_create_user_command("KustomizeListKinds", function(opts)
  if opts.args ~= "" then
    config.options.kinds = utils.parse_and_merge_config(opts.args, config.options.kinds)
  end
  require("kustomize.kinds").list(config)
  utils.reload_config()
end, {
  desc = "List 'kinds' of resources",
  nargs = "*",
})

vim.api.nvim_create_user_command("KustomizeBuild", function(opts)
  if opts.args ~= "" then
    config.options.build = utils.parse_and_merge_config(opts.args, config.options.build)
  end
  require("kustomize.build").build(config.options.build)
  utils.reload_config()
end, {
  desc = "Build kustomization.yaml file",
  nargs = "*",
})

vim.api.nvim_create_user_command("KustomizeListResources", function()
  require("kustomize.resources").list()
end, {
  desc = "Open a list with all resources in a kustomization.yaml",
  nargs = 0,
})

vim.api.nvim_create_user_command("KustomizePrintResources", function()
  require("kustomize.resources").print()
end, {
  desc = "Print all files in the current kustomization.yaml folder",
  nargs = 0,
})

vim.api.nvim_create_user_command("KustomizeValidate", function()
  local cmd = config.options.run["validate"].cmd
  local args = config.options.run["validate"].args
  require("kustomize.run").run_checked(cmd, args)
end, {
  desc = "Run validate command",
  nargs = 0,
})

vim.api.nvim_create_user_command("KustomizeDeprecations", function()
  local cmd = config.options.run["deprecations"].cmd
  local args = config.options.run["deprecations"].args
  require("kustomize.run").run_checked(cmd, args)
end, {
  desc = "Run deprecations command",
  nargs = 0,
})
