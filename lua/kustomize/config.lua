local M = {}

M.options = {
  enable_key_mappings = true,
  enable_lua_snip = false,
  build = {
    ui = {
      window = {
        type = "vsplit", -- "float", "split", or "vsplit"
        width = 0.5, -- For float/vsplit: percentage of screen width
        height = 0.8, -- For float/split: percentage of screen height
        border = "rounded", -- Border style: "none", "single", "double", "rounded", etc.
        title = " Kustomize ",
        title_pos = "center", -- "left", "center", "right"
        blend = 0, -- Background transparency (0-100)
      },
      buffer = {
        readonly = true,
        modifiable = false,
        swapfile = false,
      },
      -- Keybindings
      keymaps = {
        close = { "q", "<Esc>" },
        save = "s",
      },
    },
    additional_args = {},
  },
  kinds = { auto_close = false, show_filepath = true, show_line = true, exclude_pattern = {} },
  -- the last argument of a run command is always a file with the current buffer's content
  run = {
    validate = {
      cmd = "kubeconform",
      args = {
        "-strict",
        "-schema-location",
        "default",
        "-schema-location",
        "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json",
        "-schema-location",
        "https://json.schemastore.org/kustomization.json", -- for kustomize.config.k8s.io/v1beta1 which is not included above
      },
    },
    deprecations = {
      cmd = "kubent",
      args = { "-t", "1.27", "-c=false", "--helm3=false", "-l=error", "-e", "-f" },
    },
  },
}

return M
