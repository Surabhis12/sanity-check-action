## [1.1.0] - 2024-12-16

### Added
- Parallel check execution for improved performance
- Dependency vulnerability scanning (npm audit, cargo audit)
- Configurable tool versions
- SARIF output format
- Timeout protection
- Input sanitization

### Changed
- Updated to latest action dependencies with pinned SHAs
- Replaced deprecated actions-rs/toolchain with dtolnay/rust-toolchain
- Improved caching strategy

### Fixed
- Path traversal vulnerability in file handling
- Token exposure risk in default inputs

### Security
- All third-party actions now pinned to commit SHAs
- Added input sanitization for file paths
- Enhanced SECURITY.md with best practices