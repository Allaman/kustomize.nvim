local M = {}

M.options = {
  enable_key_mappings = true,
  enable_lua_snip = false,
  validate = { kubeconform_args = { "--strict", "--ignore-missing-schemas" } },
  deprecations = { kube_version = "1.25" },
  kinds = { show_filepath = true, show_line = true, exclude_pattern = "" },
}

return M
