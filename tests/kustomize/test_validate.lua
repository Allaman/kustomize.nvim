local eq = MiniTest.expect.equality

local validate = require("kustomize.validate")
local config = require("kustomize.config")

local want = {
  "tests/kustomize/test_data/validate/fail.yaml - Deployment nginx-deployment is invalid: problem validating schema. Check JSON formatting: jsonschema: '' does not validate with https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master-standalone-strict/deployment-apps-v1.json#/additionalProperties: additionalProperties 'labels' not allowed",
}

describe("validate", function()
  it("valid Kubernetes deployment", function()
    local _, out = validate.run_validation(config, "tests/kustomize/test_data/validate/pass.yaml")
    eq(out, {})
  end)

  it("invalid Kubernetes deployment", function()
    local _, out = validate.run_validation(config, "tests/kustomize/test_data/validate/fail.yaml")
    eq(out, want)
  end)
end)
