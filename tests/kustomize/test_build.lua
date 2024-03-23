local eq = MiniTest.expect.equality
local neq = MiniTest.expect.no_equality

local build = require("kustomize.build")
local config = require("kustomize.config")

local want1 = {
  "apiVersion: v1",
  "kind: ServiceAccount",
  "metadata:",
  "  name: bar",
  "  namespace: foo",
  "---",
  "apiVersion: v1",
  "kind: ServiceAccount",
  "metadata:",
  "  name: bar2",
  "  namespace: foo",
}

local want2 = "no such file or directory"

describe("kustomize build", function()
  it("valid kustomization.yaml", function()
    local err2, get2 = build.kustomize_build("tests/kustomize/test_data/build/pass", config)
    eq(err2, {})
    eq(get2, want1)
  end)

  it("missing resources", function()
    local err2, get2 = build.kustomize_build("tests/kustomize/test_data/build/fail", config)
    local err_string = table.concat(err2, "\n")
    local match = string.find(err_string, want2)
    neq(match, {})
    eq(get2, {})
  end)
end)
