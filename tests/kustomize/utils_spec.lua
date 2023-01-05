utils = require("kustomize.utils")
describe("utils.lua:", function()
  it("should find 'nvim' in PATH - we assume nvim is installed", function()
    assert(utils.check_exec("nvim"))
  end)

  it("should not find 'nvimmmmmm' in PATH", function()
    assert(not utils.check_exec("nviam"))
  end)
