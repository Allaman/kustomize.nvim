local M = {}

---@class KustomizeWindowConfig
---@field type? "float"|"split"|"vsplit"
---@field width? number Percentage of screen width (for float/vsplit)
---@field height? number Percentage of screen height (for float/split)
---@field border? string Border style: "none", "single", "double", "rounded", etc.
---@field title? string
---@field title_pos? "left"|"center"|"right"
---@field blend? integer Background transparency (0-100)

---@class KustomizeBufferConfig
---@field readonly? boolean
---@field modifiable? boolean
---@field swapfile? boolean

---@class KustomizeKeymapsConfig
---@field close? string|string[]
---@field save? string

---@class KustomizeUIConfig
---@field window? KustomizeWindowConfig
---@field buffer? KustomizeBufferConfig
---@field keymaps? KustomizeKeymapsConfig

---@class KustomizeBuildConfig
---@field ui? KustomizeUIConfig
---@field additional_args? string[]

---@class KustomizeKindsConfig
---@field auto_close? boolean
---@field show_filepath? boolean
---@field show_line? boolean
---@field exclude_pattern? string[]

---@class KustomizeRunCommandConfig
---@field cmd? string
---@field args? string[]
---@field timeout? integer Timeout in milliseconds

---@class KustomizeRunConfig
---@field validate? KustomizeRunCommandConfig
---@field deprecations? KustomizeRunCommandConfig

---@class KustomizeConfig
---@field enable_key_mappings? boolean
---@field enable_lua_snip? boolean
---@field build? KustomizeBuildConfig
---@field kinds? KustomizeKindsConfig
---@field run? KustomizeRunConfig

---@type KustomizeConfig
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
