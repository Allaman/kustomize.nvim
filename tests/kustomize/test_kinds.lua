local new_set = MiniTest.new_set
local expect, eq = MiniTest.expect, MiniTest.expect.equality

local T = new_set()
local kinds = require("kustomize.kinds")

local test_data = {
  "---",
  "apiVersion: kustomize.config.k8s.io/v1beta1",
  "kind: Kustomization",
  "commonLabels:",
  "  app.kubernetes.io/name: deployment-test",
  "resources:",
  "  - deployment.yaml",
  "---",
  "apiVersion: kustomize.config.k8s.io/v1beta1",
  "kind: ServiceAccount",
  "metadata:",
  "  name: test",
  "  labels:",
  "    app.kubernetes.io/name: deployment-test",
}

local want = { "Kustomization", "ServiceAccount" }

T["check_success"] = function()
  local get = kinds.find_kinds(test_data)
  eq(want, get)
end

T["check_emptyness"] = function()
  local get = kinds.find_kinds({})
  eq({}, get)
end

T["check_rubbish"] = function()
  local get = kinds.find_kinds({ "asfasfasf" })
  eq({}, get)
end

T["check_nil"] = function()
  local get = kinds.find_kinds({})
  eq({}, get)
end

T["check_wrong_param"] = function()
  expect.error(function()
    kinds.find_kinds("needs a table as input")
  end)
end

return T
