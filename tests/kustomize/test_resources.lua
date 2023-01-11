local new_set = MiniTest.new_set
local expect, eq = MiniTest.expect, MiniTest.expect.equality

local T = new_set()
local utils = require("kustomize.utils")
local resources = require("kustomize.resources")

local test_data = {
  "---",
  "apiVersion: kustomize.config.k8s.io/v1beta1",
  "kind: Kustomization",
  "commonLabels:",
  "  app.kubernetes.io/name: deployment-test",
  "resources:",
  "  - deployment.yaml",
  "  - namespace.yaml",
}

local want = { "deployment.yaml", "namespace.yaml" }

local create_buffer = function(content)
  local _, bufNr = utils.create_output()
  vim.api.nvim_buf_set_option(bufNr, "filetype", "yaml")
  vim.api.nvim_buf_set_lines(bufNr, -1, -1, true, content)
  return bufNr
end

T["should find resources"] = function()
  local bufNr = create_buffer(test_data)
  local get = resources.get_resources(bufNr)
  eq(want, get)
end

T["should not find resources"] = function()
  local bufNr = create_buffer({ "" })
  local get = resources.get_resources(bufNr)
  eq({}, get)
end

return T
