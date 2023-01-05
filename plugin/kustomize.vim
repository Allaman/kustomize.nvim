" Title:        kustomize.nvim
" Description:  A plugin providing some shortcuts for working with Kustomize
" Last Change:  05 January 2023
" Maintainer:   Michael <https://github.com/allaman>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_exampleplugin")
    finish
endif
let g:loaded_exampleplugin = 1

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 KustomizeBuild lua require("kustomize").build()
command! -nargs=0 KustomizeListKinds lua require("kustomize").kinds()
command! -nargs=0 KustomizeOpenResource lua require("kustomize").open()
command! -nargs=0 KustomizePrintResources lua require("kustomize").resources()
command! -nargs=0 KustomizeValidate lua require("kustomize").validate()
