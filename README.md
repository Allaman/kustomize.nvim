<h1 align="center">kustomize.nvim</h1>

<div align="center">
  <p>
    <img src="https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white" alt="Neovim"/>
    <img src="https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white" alt="Lua"/>
  </p>
</div>
<div align="center">
  <p>
    <img src="https://github.com/Allaman/kustomize.nvim/actions/workflows/ci.yml/badge.svg" alt="CI"/>
    <img src="https://img.shields.io/github/repo-size/Allaman/kustomize" alt="size"/>
    <img src="https://img.shields.io/github/issues/Allaman/kustomize.nvim.svg" alt="issues"/>
    <img src="https://img.shields.io/github/last-commit/Allaman/kustomize.nvim" alt="last commit"/>
    <img src="https://img.shields.io/github/license/Allaman/kustomize.nvim" alt="license"/>
    <img src="https://img.shields.io/github/v/release/Allaman/kustomize.nvim?sort=semver" alt="release"/>
  </p>
</div>

I work a lot with [Kustomize](https://kustomize.io/) and I love Neovim. So why not write a plugin for some tasks for that I usually switch to a shell.
Jump to the [use cases](#use-cases) to check out what this plugin can do!

## Requirements

- Neovim >= 0.9
- `kustomize` in your PATH to [build manifests](#build-manifests)
- [kubeconform](https://github.com/yannh/kubeconform) in your PATH to [validate manifests](#validate-resources)
- [kubent](https://github.com/doitintl/kube-no-trouble) in your PATH to [check for deprecations](#check-for-deprecations)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) and `yaml` parser
- (optionally) [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) for directory listings in "List Resources"
- (optionally) [LuaSnip](https://github.com/L3MON4D3/LuaSnip) for snippets support (default is disabled)

## Quickstart

With [Lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "allaman/kustomize.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- (optional for better directory handling in "List resources")
    "nvim-neo-tree/neo-tree.nvim"
  }
  ft = "yaml",
  opts = {}
}
```

Run `:checkhealth kustomize` for a health check.

## Default mappings

| Mode | Mapping      | Action                 | Command                    |
| ---- | ------------ | ---------------------- | -------------------------- |
| n    | \<leader\>kb | Kustomize build        | `:KustomizeBuild`          |
| n    | \<leader\>kk | List kinds             | `:KustomizeListKinds`      |
| n    | \<leader\>kp | Print resources        | `:KustomizePrintResources` |
| n    | \<leader\>kl | List resources         | `:KustomizeListResources`  |
| n    | \<leader\>kv | Validate file          | `:KustomizeValidate`       |
| n    | \<leader\>kd | Check API deprecations | `:KustomizeDeprecations`   |
| n    |              | Run custom commands    | `:KustomizeRun <command>`  |

You can define your own keybindings after setting `opts.enable_key_mappings = false`:

```lua
  use({
    "allaman/kustomize.nvim",
    opts = { enable_key_mappings = false },
    config = function(opts)
      require('kustomize').setup({opts})
      -- adjust to your needs if not using the default key mappings
      vim.api.nvim_set_keymap("n", "<leader>kb", "<cmd>KustomizeBuild<cr>", { desc = "Build Kustomize" })
      vim.api.nvim_set_keymap("n", "<leader>kk", "<cmd>KustomizeListKinds<cr>", { desc = "List Kubernetes Kinds" })
      -- ...
    end,
  })
```

## Default configuration

This is the default configuration that can be overwritten, also in parts, by you.

```lua
{
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
```

With Lazy.nvim for instance:

```lua
  opts = { enable_lua_snip = true },
```

## Use cases

### Snippets

If enabled, kustomize.nvim includes some useful snippets for LuaSnip. All snippets start with `kust`.

<details>
<summary>Showcase</summary

[![kustomize.nvim-snippets.gif](https://s9.gifyu.com/images/SFBIC.gif)](https://gifyu.com/image/SFBIC)

</details>

### Build manifests

<details>
<summary>Showcase</summary

[![kustomize.nvim-build.gif](https://s12.gifyu.com/images/kustomize.nvim-build.gif)](https://gifyu.com/image/SlSXE)

</details>

This command will run `kustomize build .` in the current buffer's directory. The generated YAML will be printed to a new buffer. The new buffer can be closed by just typing `q`.
If you want to save the generated output hit `s` in the output buffer. Keybindings can be modified.

This allows me to quickly inspect the YAML that Kustomize generates (and ultimately is applied to the cluster). In addition, I get fast feedback on any errors in my YAML sources.

You can add additional arguments to the build call or change the output options via config file:

```lua
build = {
  ui = {
    window = {
      type = "float"
    },
  },
  additional_args = {"--enable-helm", "--load-restrictor=LoadRestrictionsNone"}
},
```

You can also dynamically overwrite the values of your config file with

```
:KustomizeBuild --enable-helm --load-restrictor=LoadRestrictionsNone
```

### List "kinds"

<details>
<summary>Showcase</summary

![kustomize.nvim-kinds.gif](https://s12.gifyu.com/images/kustomize.nvim-kinds.gif)

</details>

Sometimes, I just want to roughly check the YAMLs generated by Kustomize. A good hint is to check the `kind:` key of the generated YAML manifests. This command will parse all `kind:` keys in the current buffer with the help of tree-sitter and prints their values to a loclist allowing you to easily jump around all resources. You could use it on any YAML file with multiple resources, for instance generated by [Build manifests](#build-manifests). Only Resources with `metadata.name` are recognized, e.g. `Kustomization` resources are not detected.

The output consists of `<buffer-name> |<line-nr>| <kind> <name> <namespace>`. Cluster-wide resources omit the namespace value. You can hide the buffer name and line number by adding the following snippet to the opts table:

```lua
  kinds = {
      auto_close = false,
      show_filepath = false,
      show_line = false,
  },
```

You can exclude certain resources from the results via:

```lua
  kinds = {
      exclude_pattern = { "CronJob", "ServiceAccount" }
  },
```

You can also dynamically overwrite the values of your config file with

```
:KustomizeListKinds show_line=false show_filepath=false exclude_pattern=Namespace,Ingress
```

If [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) is installed, you can toggle `Telescope loclist` with `<leader>kt` (if default mappings are enabled).

### List "resources"

<details>
<summary>Showcase</summary

[![kustomize.nvim-open.gif](https://s6.gifyu.com/images/bzlxA.gif)]

</details>

In a kustomiation.yaml you define your YAMLs and folders that should be included by Kustomize in a `resources` list like so:

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - service1/
  - grafana-dashboard.yaml
  - ../../base/namespace.yaml
```

In order to quickly check/edit those included YAMLs this command will go through all items in `resources:` and open a selection popup with all found files/directories.

### Print resource files

<details>
<summary>Showcase</summary

![kustomize.nvim-print.gif](https://s12.gifyu.com/images/kustomize.nvim-print.gif)

</details>

When writing a new deployment I usually split the resources into files according to their type, for instance `deployment.yaml`, `cm.yaml`, or `sa.yaml`. When writing my `kustomization.yaml` I must add all resource files which does this command for me.

### Validate resources

<details>
<summary>Showcase</summary

![kustomize.nvim-validate.gif](https://s12.gifyu.com/images/kustomize.nvim-validate.gif)

</details>

[kubeconform](https://github.com/yannh/kubeconform) is a Kubernetes manifests validator that can detect a misconfiguration before you apply your manifests to your cluster. This command runs `kubeconform --strict --ignore-missing-schemas` on the current buffer. The buffer's content may be a file on disk or content not (yet) saved, e.g. the output of [Build manifests](#build-manifests).

You can overwrite the default args like so

```lua
  run = {
    validate = {
      args = { "--strict" },
      },
  }
```

### Check for deprecations

<details>
<summary>Showcase</summary

![kustomize.nvim-deprecations.gif](https://s11.gifyu.com/images/kustomize.nvim-deprecations.gif)

</details>

[kubent](https://github.com/doitintl/kube-no-trouble) is a tool to search for deprecated Kubernetes APIs. This plugin utilizes the plugin to check the manifests in the current buffer for deprecated Kubernetes APIs. The buffer's content may be a file on disk or content not (yet) saved, e.g. the output of [Build manifests](#build-manifests).

You can overwrite the default args like so

```lua
  run = {
    deprecations = {
      args = { "-t", "1.30", "-l=error", "-e", "-f" },
    }
```

### Run custom commands

You can define and run arbitrary commands on yaml files, for instance:

```lua
    run = {
        trivy = {
        cmd = "trivy",
        args = { "-q", "fs" },
        timeout = 10000, -- in ms
        },
        deprecations29 = {
        cmd = "kubent",
        args = { "-t", "1.29", "-c=false", "--helm3=false", "-l=error", "-e", "-f" },
        -- the default timeout is 5000 when not specified
        },
        deprecations30 = {
        cmd = "kubent",
        args = { "-t", "1.29", "-c=false", "--helm3=false", "-l=error", "-e", "-f" },
        },
    },
```

Keep in mind, that the last argument of the command must accept a file.

Then you can run `:KustomizeRun trivy` to run the specified command. Auto-completion is supported!
