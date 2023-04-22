local eq = MiniTest.expect.equality

local deprecations = require("kustomize.deprecations")
local config = require("kustomize.config")

local want = {
  "__________________________________________________________________________________________",
  ">>> Deprecated APIs removed in 1.22 <<<",
  "------------------------------------------------------------------------------------------",
  "KIND      NAMESPACE     NAME              API_VERSION                 REPLACE_WITH (SINCE)",
  "Ingress   <undefined>   deployment-test   networking.k8s.io/v1beta1   networking.k8s.io/v1 (1.19.0)",
}

describe("no deprecations", function()
  it("No deprecations for 1.25", function()
    local err, out = deprecations.run_deprecations_check(config, "tests/kustomize/test_data/deprecations/pass.yaml")
    eq(out, {})
  end)

  it("Deprecation found for 1.25", function()
    local err, out = deprecations.run_deprecations_check(config, "tests/kustomize/test_data/deprecations/fail.yaml")
    eq(out, want)
  end)

  it("No deprecations for 1.18", function()
    config.options.deprecations.kube_version = "1.18"
    local err, out = deprecations.run_deprecations_check(config, "tests/kustomize/test_data/deprecations/fail.yaml")
    eq(out, {})
  end)
end)
