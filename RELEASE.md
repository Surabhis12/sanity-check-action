# Release Guide

This document describes the release process for the Multi-Language Sanity Check Action.

## Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (x.0.0): Breaking changes, incompatible API changes
- **MINOR** (0.x.0): New features, backwards compatible
- **PATCH** (0.0.x): Bug fixes, backwards compatible

## Release Process

### 1. Prepare the Release

```bash
# Ensure you're on main branch and up to date
git checkout main
git pull origin main

# Create a release branch
git checkout -b release/v1.1.0
```

### 2. Update Version References

Update version references in:
- `README.md` (usage examples)
- `action.yml` (if version is mentioned)
- Any documentation

### 3. Update Changelog

Create or update `CHANGELOG.md`:

```markdown
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
```

### 4. Run Tests

```bash
# Test in a sample repository
# Ensure all checks pass
# Verify PR comments work correctly
# Check label application
# Test SARIF output
```

### 5. Create Pull Request

```bash
git add .
git commit -m "chore: prepare release v1.1.0"
git push origin release/v1.1.0
```

Create PR with:
- Title: `Release v1.1.0`
- Description: Copy relevant changelog sections
- Labels: `release`

### 6. Merge and Tag

After PR approval and merge:

```bash
git checkout main
git pull origin main

# Create annotated tag
git tag -a v1.1.0 -m "Release v1.1.0

- Parallel check execution
- Dependency scanning
- Configurable tool versions
- SARIF output support
- Enhanced security"

# Push tag
git push origin v1.1.0
```

### 7. Update Major Version Tag

For users who want to use `@v1` (always latest v1.x.x):

```bash
# Delete old major version tag locally and remotely
git tag -d v1
git push origin :refs/tags/v1

# Create new major version tag
git tag -a v1 -m "Update v1 to v1.1.0"
git push origin v1
```

### 8. Create GitHub Release

Go to GitHub Releases and create a new release:

1. **Tag**: Select `v1.1.0`
2. **Release title**: `v1.1.0`
3. **Description**: Copy from CHANGELOG.md
4. **Assets**: Auto-generated source code
5. Check "Set as the latest release"
6. Publish release

### 9. Update Marketplace

The action will automatically update on GitHub Marketplace when you create the release.

### 10. Post-Release Communication

- Update any documentation sites
- Post announcement in Discussions
- Notify users of breaking changes (if any)

## Release Checklist

- [ ] Version bumped in all files
- [ ] CHANGELOG.md updated
- [ ] Tests pass
- [ ] Security audit completed
- [ ] Documentation updated
- [ ] Breaking changes documented
- [ ] PR created and approved
- [ ] Tag created and pushed
- [ ] Major version tag updated
- [ ] GitHub Release created
- [ ] Marketplace updated
- [ ] Announcement posted

## Hotfix Process

For critical bugs requiring immediate release:

```bash
# Create hotfix branch from latest tag
git checkout v1.1.0
git checkout -b hotfix/v1.1.1

# Make fixes
# Test thoroughly

# Commit and create PR
git add .
git commit -m "fix: critical security vulnerability"
git push origin hotfix/v1.1.1

# After merge, follow steps 6-8 above
```

## Pre-release / Beta

For testing major changes:

```bash
# Create tag with pre-release suffix
git tag -a v2.0.0-beta.1 -m "Release v2.0.0-beta.1"
git push origin v2.0.0-beta.1

# In GitHub Release, check "This is a pre-release"
```

## Deprecation Policy

When deprecating features:

1. **Announce** in release notes at least one MINOR version before removal
2. **Document** alternatives in deprecation notice
3. **Add warnings** in workflow logs
4. **Remove** in next MAJOR version

Example deprecation notice:
```yaml
- name: Check deprecated features
  run: |
    echo "::warning::enable-xyz-check is deprecated and will be removed in v2.0.0. Use enable-abc-check instead."
```

## Version Support

- **Latest MAJOR version**: Full support, security updates
- **Previous MAJOR version**: Security updates for 6 months after new major release
- **Older versions**: No support

## Emergency Response

For critical security vulnerabilities:

1. **Immediate**: Create private security advisory on GitHub
2. **Develop fix**: In private fork or branch
3. **Test thoroughly**: Ensure fix works without breaking changes
4. **Coordinate disclosure**: Set release date
5. **Release**: Follow hotfix process above
6. **Notify users**: Security advisory, GitHub issue, email if possible
7. **Request CVE**: If applicable

## Rollback Procedure

If a release causes critical issues:

```bash
# Update major version tag to previous version
git checkout v1.0.5
git tag -fa v1 -m "Rollback v1 to v1.0.5 due to critical issue"
git push origin v1 --force

# Create issue explaining the rollback
# Work on fix
# Release new version
```

## Contact

For release-related questions:
- Open an issue with `release` label
- Contact maintainers directly for security issues

---

Last Updated: 2024-12-16