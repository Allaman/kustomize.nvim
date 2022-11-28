# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
