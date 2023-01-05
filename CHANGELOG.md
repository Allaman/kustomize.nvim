# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
