local eq = MiniTest.expect.equality

local run = require("kustomize.run")
local validation = require("kustomize.config").options.run.validate

local want = {
  "tests/kustomize/test_data/validate/fail.yaml - Deployment nginx-deployment is invalid: problem validating schema. Check JSON formatting: jsonschema: '' does not validate with https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/deployment-apps-v1.json#/additionalProperties: additionalProperties 'labels' not allowed",
}

describe("validate", function()
  it("valid Kubernetes deployment", function()
    table.insert(validation.args, "tests/kustomize/test_data/validate/pass.yaml")
    local _, out = run.run(validation.cmd, validation.args, 5000)
    table.remove(validation.args)
    eq(out, {})
  end)

  it("invalid Kubernetes deployment", function()
    table.insert(validation.args, "tests/kustomize/test_data/validate/fail.yaml")
    local _, out = run.run(validation.cmd, validation.args, 5000)
    table.remove(validation.args)
    eq(out, want)
  end)
end)
