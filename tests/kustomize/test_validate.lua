local eq = MiniTest.expect.equality

local validate = require("kustomize.validate")

local want = {
  "tests/kustomize/test_data/validate/fail.yaml - Deployment nginx-deployment is invalid: For field (root): Additional property labels is not allowed",
}

describe("validate", function()
  it("valid Kubernetes deployment", function()
    local out = validate.run_validation("tests/kustomize/test_data/validate/pass.yaml")
    eq(out, {})
  end)

  it("invalid Kubernetes deployment", function()
    local out = validate.run_validation("tests/kustomize/test_data/validate/fail.yaml")
    eq(out, want)
  end)
end)
