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

## Quickstart

With Packer:

```lua
  use({
    "allaman/kustomize.nvim",
    requires = "nvim-lua/plenary.nvim",
    ft = "yaml",
    config = function()
      require('kustomize').setup()
    end,
  })
```

With Lazy

```lua
{
  "allaman/kustomize.nvim",
  requires = "nvim-lua/plenary.nvim",
  ft = "yaml",
  config = true,
}

Run `:checkhealth kustomize` for a health check.
```

## Default mappings

| Mode | Mapping      | Action                 | Lua                                          | Command                    |
| ---- | ------------ | ---------------------- | -------------------------------------------- | -------------------------- |
| n    | \<leader\>kb | Kustomize build        | `lua require("kustomize").build()`           | `:KustomizeBuild`          |
| n    | \<leader\>kk | List kinds             | `lua require("kustomize").kinds()`           | `:KustomizeListKinds`      |
| n    | \<leader\>kr | Print resources        | `lua require("kustomize").print_resources()` | `:KustomizePrintResources` |
| n    | \<leader\>ko | List 'resources'       | `lua require("kustomize").list_resources()`  | `:KustomizeListResources`  |
| n    | \<leader\>kv | Validate file          | `lua require("kustomize").validate()`        | `:KustomizeValidate`       |
| n    | \<leader\>kd | Check API deprecations | `lua require("kustomize").deprecations()`    | `:KustomizeDeprecations`   |

You can define your own keybindings/override the default mappings:

```lua
  use({
    "allaman/kustomize.nvim",
    requires = "nvim-lua/plenary.nvim",
    ft = "yaml",
    opts = { enable_key_mappings = false },
    config = function(opts)
      require('kustomize').setup({opts})
      -- default keybindings, adjust to your needs
      vim.keymap.set("n", "<leader>kb", "<cmd>lua require('kustomize').build()<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>kk", "<cmd>lua require('kustomize').kinds()<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>kl", "<cmd>lua require('kustomize').list_resources()<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>kp", "<cmd>lua require('kustomize').print_resources()<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>kv", "<cmd>lua require('kustomize').validate()<cr>", { noremap = true })
      vim.keymap.set("n", "<leader>kd", "<cmd>lua require('kustomize').deprecations()<cr>", { noremap = true })
    end,
  })
```

## Default configuration

This is the default configuration that can be (partially) overwritten by you.

```lua
{
    enable_key_mappings = true,
    validate = { kubeconform_args = { "--strict", "--ignore-missing-schemas" } }
    deprecations = { kube_version = "1.25" }
}
```

With Lazy.nvim for instance:

```lua
  opts = { validate = { kubeconform_args = { "--strict" } } },
```

## Use cases

### Build manifests

<details>
<summary>Showcase</summary

[![kustomize.nvim-build.gif](https://s12.gifyu.com/images/kustomize.nvim-build.gif)](https://gifyu.com/image/SlSXE)

</details>

This command will run `kustomize build .` in the current buffer's directory. The generated YAML will printed to a new buffer. The new buffer can be closed by just typing `q`.
This allows me to quickly inspect the YAML that Kustomize generates (and ultimately is applied to the cluster). In addition, I get fast feedback on any errors in my YAML sources.

### List "kinds"

<details>
<summary>Showcase</summary

![kustomize.nvim-kinds.gif](https://s12.gifyu.com/images/kustomize.nvim-kinds.gif)

</details>

Sometimes, I just want to roughly check the YAMLs generated by Kustomize. A good hint is to check the `kind:` key of the generated YAML manifests. This command will parse all `kind:` keys with the help of tree-sitter in the current buffer and prints their values to a new buffer. The new buffer can be closed by just typing `q`. You could use it on any YAML file with multiple resources, for instance generated by [Build manifests](#build-manifests). Only Resources with `metadata.name` are recognized, e.g. `Kustomization` resources are not detected.

### Open file/directory

<details>
<summary>Showcase</summary

![kustomize.nvim-open.gif](https://s12.gifyu.com/images/kustomize.nvim-open.gif)

</details>

You list your YAMLs that should be included by Kustomize for the build of the final manifests like so:

```yaml
---
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - service1/
  - grafana-dashboard.yaml
  - ../../base/namespace.yaml
```

In order to quickly check/edit those included YAMLs this command will go through all items in `resources:` and populate a quickfix list with them.

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

### Check for deprecations

<details>
<summary>Showcase</summary

![kustomize.nvim-deprecations.gif](https://s11.gifyu.com/images/kustomize.nvim-deprecations.gif)

</details>

[kubent](https://github.com/doitintl/kube-no-trouble) is a tool to search for deprecated Kubernetes APIs. This plugins utilizes the plugin to check the manifests in the current buffer for deprecated Kubernetes APIs. The buffer's content may be a file on disk or content not (yet) saved, e.g. the output of [Build manifests](#build-manifests). The Kubernetes target version can be set with `deprecations = { kube_version = "1.25" }`.
