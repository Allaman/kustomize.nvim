local new_set = MiniTest.new_set
local expect, eq = MiniTest.expect, MiniTest.expect.equality

local T = new_set()
local utils = require("kustomize.utils")
local kinds = require("kustomize.kinds")

local test_data = {
  "---",
  "apiVersion: kustomize.config.k8s.io/v1beta1",
  "kind: Kustomization",
  "commonLabels:",
  "  app.kubernetes.io/part-of: test",
  "resources:",
  "  - deployment.yaml",
  "---",
  "apiVersion: kustomize.config.k8s.io/v1beta1",
  "kind: ServiceAccount",
  "metadata:",
  "  name: test",
  "  kind: ShouldNotMatch",
  "  labels:",
  "    app.kubernetes.io/name: deployment-test",
}

local want = { { "Kustomization", "Kustomization", 3 }, { "ServiceAccount", "test", 10 } }

local create_buffer = function(content)
  local _, bufNr = utils.create_output()
  vim.api.nvim_buf_set_option(bufNr, "filetype", "yaml")
  vim.api.nvim_buf_set_lines(bufNr, -1, -1, true, content)
  return bufNr
end

T["check_success_treesitter"] = function()
  local bufNr = create_buffer(test_data)
  local get = kinds.find_kinds(bufNr)
  eq(want, get)
end

T["check_emptyness_treesitter"] = function()
  local bufNr = create_buffer({ "" })
  local get = kinds.find_kinds(bufNr)
  eq({}, get)
end

T["check_invalidBuffer_treesitter"] = function()
  expect.error(function()
    kinds.find_kinds(1337)
  end)
end

T["check_nil_treesitter"] = function()
  expect.error(function()
    kinds.find_kinds(nil)
  end)
end

T["check_wrong_param_treesitter"] = function()
  expect.error(function()
    kinds.find_kinds("needs a buffer number as input")
  end)
end

return T
