local M = {}

local build = require("kustomize.build")
local kinds = require("kustomize.kinds")
local open = require("kustomize.open")
local resources = require("kustomize.resources")
local validate = require("kustomize.validate")

M.build = function()
  build.build()
end

M.kinds = function()
  kinds.list()
end

M.open = function()
  open.open()
end

M.resources = function()
  resources.resources()
end

M.validate = function()
  validate.validate()
end

M.setup = function()
  vim.keymap.set("n", "<leader>kb", function()
    M.build()
  end, { desc = "Kustomize build" })
  vim.keymap.set("n", "<leader>kk", function()
    M.kinds()
  end, { desc = "List kinds" })
  vim.keymap.set("v", "<leader>ko", function()
    M.open()
  end, { desc = "Open" })
  vim.keymap.set("n", "<leader>kr", function()
    M.resources()
  end, { desc = "Print resources in folder" })
  vim.keymap.set("n", "<leader>kv", function()
    M.validate()
  end, { desc = "Validate manifests" })
end

return M
