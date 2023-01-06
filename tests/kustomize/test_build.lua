local eq = MiniTest.expect.equality

local build = require("kustomize.build")

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

local want2 = {
  "Error: accumulating resources: accumulation err='accumulating resources from 'serviceaccount.yaml': evalsymlink failure on '/Users/michael/workspace/github.com/allaman/kustomize.nvim/tests/kustomize/test_data/build/fail/serviceaccount.yaml' : lstat /Users/michael/workspace/github.com/allaman/kustomize.nvim/tests/kustomize/test_data/build/fail/serviceaccount.yaml: no such file or directory': must build at directory: not a valid directory: evalsymlink failure on '/Users/michael/workspace/github.com/allaman/kustomize.nvim/tests/kustomize/test_data/build/fail/serviceaccount.yaml' : lstat /Users/michael/workspace/github.com/allaman/kustomize.nvim/tests/kustomize/test_data/build/fail/serviceaccount.yaml: no such file or directory",
}

describe("kustomize build", function()
  it("valid kustomization.yaml", function()
    local err, get = build.kustomize_build("tests/kustomize/test_data/build/pass")
    eq(err, {})
    eq(get, want1)
  end)

  it("missing resources", function()
    local err, get = build.kustomize_build("tests/kustomize/test_data/build/fail")
    eq(err, want2)
    eq(get, {})
  end)
end)
