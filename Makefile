help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

test: ## Run tests
	@nvim --headless --noplugin -u ./tests/init.lua -c "lua MiniTest.run()"

gif: ## Create gifs
	vhs ./doc/tapes/kustomize.nvim-build.tape
	vhs ./doc/tapes/kustomize.nvim-deprecations.tape
	vhs ./doc/tapes/kustomize.nvim-kinds.tape
	vhs ./doc/tapes/kustomize.nvim-open.tape
	vhs ./doc/tapes/kustomize.nvim-print.tape
	vhs ./doc/tapes/kustomize.nvim-validate.tape

clean: ## Delete .tests/ (test config for Neovim instance)
	@rm -fr .tests
