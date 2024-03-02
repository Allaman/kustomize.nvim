# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.8.0](https://github.com/Allaman/kustomize.nvim/compare/v4.7.0...v4.8.0) (2024-03-02)


### Features

* Add LuaSnip integration ([795e2b8](https://github.com/Allaman/kustomize.nvim/commit/795e2b89e8ce4798b78ff97ba093dc780c533413))

## [4.7.0](https://github.com/Allaman/kustomize.nvim/compare/v4.6.0...v4.7.0) (2024-02-03)


### Features

* Add exclude_patterns to kind list [#53](https://github.com/Allaman/kustomize.nvim/issues/53) ([58f8b2a](https://github.com/Allaman/kustomize.nvim/commit/58f8b2a4ddda24a7bf8602ac679e08751643502f))

## [4.6.0](https://github.com/Allaman/kustomize.nvim/compare/v4.5.2...v4.6.0) (2024-02-03)


### Features

* Add args for kinds and deprecations [#51](https://github.com/Allaman/kustomize.nvim/issues/51) ([dd5bf66](https://github.com/Allaman/kustomize.nvim/commit/dd5bf66f54c139cfd9801234a70d78a773432f31))


### Bug Fixes

* Deprecated call ([0c4ee06](https://github.com/Allaman/kustomize.nvim/commit/0c4ee060ef8991a903bd9cf9d40187804da7fd78))

## [4.5.2](https://github.com/Allaman/kustomize.nvim/compare/v4.5.1...v4.5.2) (2023-12-22)


### Bug Fixes

* Add error handling to os.remove calls ([#47](https://github.com/Allaman/kustomize.nvim/issues/47)) ([ccd321f](https://github.com/Allaman/kustomize.nvim/commit/ccd321f31e19c147b11716e5b25a54fdd126dd23))

## [4.5.1](https://github.com/Allaman/kustomize.nvim/compare/v4.5.0...v4.5.1) (2023-12-16)


### Bug Fixes

* minor linting and deprecation issues ([#43](https://github.com/Allaman/kustomize.nvim/issues/43)) ([bb0c5a6](https://github.com/Allaman/kustomize.nvim/commit/bb0c5a6d153756482a1ec73dbb94f63954cb0534))

## [4.5.0](https://github.com/Allaman/kustomize.nvim/compare/v4.4.0...v4.5.0) (2023-11-19)


### Features

* **kinds:** Add telescope loclist keybinding ([bc8e8cd](https://github.com/Allaman/kustomize.nvim/commit/bc8e8cd09e6fb91d5902b26a17cfd6eee1fe331d))


### Bug Fixes

* docstring with correct values ([4ea8047](https://github.com/Allaman/kustomize.nvim/commit/4ea80479cc32bf4e16f559ccbf4bb79a9a3f96db))
* Remove unnecassary ft check ([a0b3ed9](https://github.com/Allaman/kustomize.nvim/commit/a0b3ed9ef4b4fa4ee8aa4e64e13b889ffc349ad6))
* set default values in iter_matches ([a84ab1b](https://github.com/Allaman/kustomize.nvim/commit/a84ab1baed7a94e4a5a6282c594aaf8eb758554a))

## [4.4.0](https://github.com/Allaman/kustomize.nvim/compare/v4.3.0...v4.4.0) (2023-10-21)


### Features

* Add namespace to list kinds ([7a88d4c](https://github.com/Allaman/kustomize.nvim/commit/7a88d4c36902ddb153bf0d11f082c10406e470d9))


### Bug Fixes

* path separator ([cb8726f](https://github.com/Allaman/kustomize.nvim/commit/cb8726fc0effdcf28711c9024a0f853e2323d997))

## [4.3.0](https://github.com/Allaman/kustomize.nvim/compare/v4.2.2...v4.3.0) (2023-07-31)


### Features

* Add checkhealth [#35](https://github.com/Allaman/kustomize.nvim/issues/35) ([fd5efb2](https://github.com/Allaman/kustomize.nvim/commit/fd5efb2e7ec65dd708a422bdd02fd48d00d75533))

## [4.2.2](https://github.com/Allaman/kustomize.nvim/compare/v4.2.1...v4.2.2) (2023-05-15)


### Bug Fixes

* make list_kinds treesitter query more robust ([3c91311](https://github.com/Allaman/kustomize.nvim/commit/3c913118bb64da14a865a14abbb4cf45801bf0d5))

## [4.2.1](https://github.com/Allaman/kustomize.nvim/compare/v4.2.0...v4.2.1) (2023-05-14)


### Bug Fixes

* bug in list kinds in Kustomization resources [#29](https://github.com/Allaman/kustomize.nvim/issues/29) ([8890806](https://github.com/Allaman/kustomize.nvim/commit/8890806761e51946cbfc70bdebf4d49bfd23803b))

## [4.2.0](https://github.com/Allaman/kustomize.nvim/compare/v4.1.0...v4.2.0) (2023-04-22)


### Features

* add KustomizeDeprecations command [#26](https://github.com/Allaman/kustomize.nvim/issues/26) ([1227725](https://github.com/Allaman/kustomize.nvim/commit/1227725150150fc90b25acaf573fbfd8f3dc6d57))


### Bug Fixes

* use utils.warn if validation finds an issue ([75370b1](https://github.com/Allaman/kustomize.nvim/commit/75370b14c9bb6ae85c2dc29258cdbec50766d259))

## [4.1.0](https://github.com/Allaman/kustomize.nvim/compare/v4.0.0...v4.1.0) (2023-04-21)


### Features

* introduce config table [#8](https://github.com/Allaman/kustomize.nvim/issues/8) and enhance kubeconform output ([44a458c](https://github.com/Allaman/kustomize.nvim/commit/44a458cd869c044d25804049f8c2a6a1e652e3ec))

## [4.0.0](https://github.com/Allaman/kustomize.nvim/compare/v3.1.0...v4.0.0) (2023-04-20)


### ⚠ BREAKING CHANGES

* update vim.treesitter API calls

### Features

* update vim.treesitter API calls ([861c8d5](https://github.com/Allaman/kustomize.nvim/commit/861c8d50256758d2a0aab9bf4aee40c41c5ebe96))


### Bug Fixes

* [#27](https://github.com/Allaman/kustomize.nvim/issues/27) ([acf920d](https://github.com/Allaman/kustomize.nvim/commit/acf920d8f7f06fef4d98b4a1f744308932335e82))
* [#28](https://github.com/Allaman/kustomize.nvim/issues/28) ([42d9a69](https://github.com/Allaman/kustomize.nvim/commit/42d9a69ddcc5fa1a56c981ae9f2a89fb0eaddbc4))
* test_validate ([8115789](https://github.com/Allaman/kustomize.nvim/commit/8115789890c7d774b37b17f123ffeb2bbb22dcc2))

## [3.1.0](https://github.com/Allaman/kustomize.nvim/compare/v3.0.0...v3.1.0) (2023-02-23)


### Features

* **list_kinds:** show also metadata.name value of each resource [#22](https://github.com/Allaman/kustomize.nvim/issues/22) ([2e8aef6](https://github.com/Allaman/kustomize.nvim/commit/2e8aef67b17a402283d6cd4e292584b16ad88719))

## [3.0.0](https://github.com/Allaman/kustomize.nvim/compare/v2.0.1...v3.0.0) (2023-02-23)


### ⚠ BREAKING CHANGES

* list resource "kinds:" in loclist #21

### Features

* list resource "kinds:" in loclist [#21](https://github.com/Allaman/kustomize.nvim/issues/21) ([957e256](https://github.com/Allaman/kustomize.nvim/commit/957e256bb95e9ba3046613f3eb0bfe5c9727bc13))

## [2.0.1](https://github.com/Allaman/kustomize.nvim/compare/v2.0.0...v2.0.1) (2023-01-11)


### Bug Fixes

* validation error msg handling ([d30f120](https://github.com/Allaman/kustomize.nvim/commit/d30f120b584ad5104a62cfb23808ae24b25c4937))

## [2.0.0](https://github.com/Allaman/kustomize.nvim/compare/v1.0.3...v2.0.0) (2023-01-11)


### ⚠ BREAKING CHANGES

* introduce nvim-treesitter parsing

### Features

* introduce nvim-treesitter parsing ([49aa4a0](https://github.com/Allaman/kustomize.nvim/commit/49aa4a06942a39200bee11e31bfd5d6b921091c2))

## [1.0.3](https://github.com/Allaman/kustomize.nvim/compare/v1.0.2...v1.0.3) (2023-01-06)


### Bug Fixes

* remove unnecessary line break in error msg ([a6b6cb7](https://github.com/Allaman/kustomize.nvim/commit/a6b6cb76314a6e8349c2162089ea2c3b98c97095))

## [1.0.2](https://github.com/Allaman/kustomize.nvim/compare/v1.0.1...v1.0.2) (2023-01-06)


### Bug Fixes

* title in warn and error functions ([f7c612a](https://github.com/Allaman/kustomize.nvim/commit/f7c612aad688cce231065c02d3531d46a440148b))
* unix detection for path_separator() ([7c7b6cd](https://github.com/Allaman/kustomize.nvim/commit/7c7b6cd15db29b1b8af16ae1ad351913b4eaec87))

## [1.0.1](https://github.com/Allaman/kustomize.nvim/compare/v1.0.0...v1.0.1) (2023-01-05)


### Bug Fixes

* prevent create_output to create a 'NO NAME' buffer [#11](https://github.com/Allaman/kustomize.nvim/issues/11) ([e57ea1f](https://github.com/Allaman/kustomize.nvim/commit/e57ea1fde2617d3d3d6e809e23a989381e66dba2))

## [1.0.0](https://github.com/Allaman/kustomize.nvim/compare/v0.5.0...v1.0.0) (2023-01-05)


### ⚠ BREAKING CHANGES

* rename commands

### Features

* delete buffer after closing output window [#9](https://github.com/Allaman/kustomize.nvim/issues/9) ([9c4398d](https://github.com/Allaman/kustomize.nvim/commit/9c4398daad0fe95473f017b7bb4de8ba16fe2b2d))


### Bug Fixes

* make 'M' local variable ([f8a3792](https://github.com/Allaman/kustomize.nvim/commit/f8a379247491ef2b058769c0fd2f255d62a75b45))
* make M local ([afe38b0](https://github.com/Allaman/kustomize.nvim/commit/afe38b0d6a7f3a94769231555419dd5c8240f3b2))


### Code Refactoring

* rename commands ([e7d1216](https://github.com/Allaman/kustomize.nvim/commit/e7d12160dc1d3239a84de9f75504f625154dcfbd))

## [0.5.0](https://github.com/Allaman/kustomize.nvim/compare/v0.4.2...v0.5.0) (2023-01-05)


### Features

* add 'open' use case ([f14e04f](https://github.com/Allaman/kustomize.nvim/commit/f14e04f94f700b39ae6dc3a9db6d32a8586753aa))
* add "validate manifests" use case ([d843a71](https://github.com/Allaman/kustomize.nvim/commit/d843a71b917c26b68389afe4fb75c9be20180144))
* add new "resources" function ([158fd25](https://github.com/Allaman/kustomize.nvim/commit/158fd250c8e84a898aacfd2f10c854db993dedca))
* better error handling for kustomize build ([aab7a9b](https://github.com/Allaman/kustomize.nvim/commit/aab7a9b751f29b14b05980e93c2516d527584ba0))
* **customization:** adds support for custom user configurations/overrides ([#2](https://github.com/Allaman/kustomize.nvim/issues/2)) ([34e240c](https://github.com/Allaman/kustomize.nvim/commit/34e240c98d3cee0440980b8557da9813b659b27e))


### Bug Fixes

* add missing require statement ([3f503c3](https://github.com/Allaman/kustomize.nvim/commit/3f503c3cff7f72adc1afc6b5d07d9491c477aeb7))
* do not create buffer on kustomize error ([ae4280a](https://github.com/Allaman/kustomize.nvim/commit/ae4280acf80346194308f915d2e5b3c05a3b9d47))
* support kustomization.yml ([6d5af96](https://github.com/Allaman/kustomize.nvim/commit/6d5af961c50dab5629994e14988d4993a81ef1c3))
* vim commands ([e778ae4](https://github.com/Allaman/kustomize.nvim/commit/e778ae4622d30bbf884c3b76395ba4cf5504de8b))

## [0.4.2] - 2022-11-28

### Fixed

- missing require statement

## [0.4.1] - 2022-11-28

### Changed

- refactor `check_plenary`, `check_kustomize`, `check_kubeconform`

## [0.4.0] - 2022-11-25

### Added

- "validation" use case to quickly run `kubeconform` on the current buffer's content.

## [0.3.1] - 2022-11-23

### Fixed

- do not display output buffer if kustomize build ran into an error

## [0.3.0] - 2022-11-21

### Added

- "resources" use case to quickly add all files/folders within a folder containing a kustomization.ya(m)l to the list of resources

### Fixed

- vim commands

### Changed

- refactor check for `kustomization.y(a)ml` to a function in utils

## [0.2.1] - 2022-11-20

### Added

- support `kustomization.yml`

## [0.2.0] - 2022-11-19

### Added

- 'open' use case to quickly open a file listed in a kustomization.yaml (e.g. resources) via visual selection

### Changed

- One video per use case

## [0.1.0] - 2022-11-18

### Added

- utils.lua

### Changed

- Better error handling for kustomize build

## [0.0.1] - 2022-11-17

### Added

- Initial release
