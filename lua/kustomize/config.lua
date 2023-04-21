local M = {}

M.options = {
  enable_key_mappings = true,
  validate = { kubeconform_args = { "--strict", "--ignore-missing-schemas" } },
}

return M
