local new_set = MiniTest.new_set
local expect, eq = MiniTest.expect, MiniTest.expect.equality

-- local T = new_set()
local utils = require("kustomize.utils")

-- Only works as expected when adding `error()` call to check_command()
-- but this message is not redirected to 'noice' and not "pretty"
-- T["check_exec"] = function()
--   expect.error(function()
--     utils.check_exec("nvimmmm")
--   end)
-- end

-- NOTE: 'mini.test' supports emulation of busted-style testing by default.
-- NOTE: when using this style, no test set should be returned

describe("utils.lua:", function()
  it("should find 'nvim' in PATH - we assume nvim is installed", function()
    assert(utils.check_exec("nvim"))
  end)

  it("should not find 'nvimmmmmm' in PATH", function()
    assert(not utils.check_exec("nviam"))
  end)

  it("should load module mini.test", function()
    assert(utils.is_module_available("mini.test"))
  end)

  it("should load module fooo", function()
    assert(not utils.is_module_available("foo"))
  end)

  it("should count table entries", function()
    local want = 3
    local get = utils.table_length({ "one", "two", "three" })
    eq(want, get)
  end)
end)

describe("parse arguments", function()
  it("valid", function()
    local args = "show_line=true show_filepath=true exclude_pattern=CronJob,ServiceAccount"
    local get = utils.parseArguments(args)
    eq(get, {
      exclude_pattern = { "CronJob", "ServiceAccount" },
      show_filepath = true,
      show_line = true,
    })
  end)
end)

-- return T
