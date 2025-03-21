local M = {}

M.options = {
  enable_key_mappings = true,
  enable_lua_snip = false,
  build = { additional_args = {} },
  kinds = { auto_close = false, show_filepath = true, show_line = true, exclude_pattern = {} },
  -- the last argument of a run command is always a file with the current buffer's content
  run = {
    validate = {
      cmd = "kubeconform",
      args = {
        "--strict",
        "--ignore-missing-schemas",
        "-schema-location",
        "default",
        "-schema-location",
        "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json",
        -- "-schema-location",
        -- "https://json.schemastore.org/kustomization.json",
      },
    },
    deprecations = {
      cmd = "kubent",
      args = { "-t", "1.26", "-c=false", "--helm3=false", "-l=error", "-e", "-f" },
    },
  },
}

return M
