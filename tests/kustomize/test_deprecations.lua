local eq = MiniTest.expect.equality

local run = require("kustomize.run")
local deprecations = require("kustomize.config").options.run.deprecations

local want = {
  "__________________________________________________________________________________________",
  ">>> Deprecated APIs removed in 1.22 <<<",
  "------------------------------------------------------------------------------------------",
  "KIND      NAMESPACE     NAME              API_VERSION                 REPLACE_WITH (SINCE)",
  "Ingress   <undefined>   deployment-test   networking.k8s.io/v1beta1   networking.k8s.io/v1 (1.19.0)",
}

describe("no deprecations", function()
  it("No deprecations for 1.25", function()
    table.insert(deprecations.args, "tests/kustomize/test_data/depreatations/pass.yaml")
    local _, out = run.run(deprecations.cmd, deprecations.args, 5000)
    table.remove(deprecations.args)
    eq(out, {})
  end)

  it("Deprecation found for 1.25", function()
    table.insert(deprecations.args, "tests/kustomize/test_data/deprecations/fail.yaml")
    local _, out = run.run(deprecations.cmd, deprecations.args, 5000)
    table.remove(deprecations.args)
    eq(out, out)
  end)

  it("No deprecations for 1.18", function()
    deprecations.args = {
      "-t",
      "1.18",
      "-c=false",
      "--helm3=false",
      "-l=error",
      "-e",
      "-f",
      "tests/kustomize/test_data/deprecations/fail.yaml",
    }
    local _, out = run.run(deprecations.cmd, deprecations.args, 5000)
    table.remove(deprecations.args)
    eq(out, {})
  end)

  it("Wrong argument", function()
    table.insert(deprecations.args, "--output json") -- prevent colored output
    table.insert(deprecations.args, "--foo")
    table.insert(deprecations.args, "tests/kustomize/test_data/deprecations/fail.yaml")
    local _, out = run.run(deprecations.cmd, deprecations.args, 5000)
    eq(out, { "unknown flag: --foo" })
  end)
end)
