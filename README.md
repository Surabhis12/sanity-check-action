# Multi-Language Sanity Check Action

[![GitHub release](https://img.shields.io/github/v/release/Surabhis12/sanity-check-action)](https://github.com/Surabhis12/sanity-check-action/releases)
[![License](https://img.shields.io/github/license/Surabhis12/sanity-check-action)](LICENSE)

Reusable GitHub Action for automated code quality, security vulnerability checks, and dependency scanning across multiple programming languages.

## Features

✨ **Multi-Language Support**: C/C++, JavaScript/TypeScript, Rust, Kotlin, Swift, Java, Dart/Flutter

🔒 **Security Scanning**: Hard-coded secrets, SQL injection, command injection, weak cryptography

📦 **Dependency Scanning**: npm audit, cargo audit for known vulnerabilities

⚡ **Parallel Execution**: All language checks run concurrently for speed

🎯 **Configurable**: Enable/disable specific checks, set severity thresholds, customize outputs

📊 **Multiple Output Formats**: Text, JSON, SARIF (compatible with GitHub Code Scanning)

🏷️ **Smart Labeling**: Automatic pass/fail labels on PRs

💬 **Rich PR Comments**: Detailed, collapsible results with error summaries

## Quick Start

### Basic Usage

Create `.github/workflows/sanity-check.yml` in your repository:

```yaml
name: Sanity Check

on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  contents: read
  pull-requests: write
  issues: write
  security-events: write  # Required for SARIF upload

jobs:
  sanity-check:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout PR code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Run Sanity Check
        uses: Surabhis12/sanity-check-action@v1.1.0  # Use latest tag
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

### Advanced Configuration

```yaml
      - name: Run Sanity Check
        uses: Surabhis12/sanity-check-action@v1.1.0
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          
          # Enable/disable specific language checks
          enable-cpp-check: true
          enable-js-check: true
          enable-rust-check: true
          enable-kotlin-check: true
          enable-swift-check: true
          enable-java-check: true
          enable-flutter-check: true
          
          # Enable dependency vulnerability scanning
          enable-dependency-scan: true
          
          # Severity threshold (error|warning|all)
          severity-threshold: error
          
          # Custom ignore patterns
          custom-ignore-patterns: '*.test.js,*.spec.ts,vendor/**'
          
          # Output format (text|json|sarif)
          output-format: sarif
          
          # PR interaction
          enable-pr-comments: true
          enable-labels: true
          fail-on-error: true
          
          # Tool versions
          node-version: '20'
          java-version: '17'
          java-distribution: 'temurin'
          ktlint-version: '1.0.1'
          rust-toolchain: 'stable'
          
          # Timeout per check (in minutes)
          check-timeout: 10
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `github-token` | GitHub token for API access | Yes | - |
| `enable-cpp-check` | Enable C/C++ checks | No | `true` |
| `enable-js-check` | Enable JavaScript/TypeScript checks | No | `true` |
| `enable-rust-check` | Enable Rust checks | No | `true` |
| `enable-kotlin-check` | Enable Kotlin checks | No | `true` |
| `enable-swift-check` | Enable Swift checks | No | `true` |
| `enable-java-check` | Enable Java checks | No | `true` |
| `enable-flutter-check` | Enable Flutter/Dart checks | No | `true` |
| `enable-dependency-scan` | Enable dependency vulnerability scanning | No | `true` |
| `severity-threshold` | Fail on issues with severity level | No | `error` |
| `custom-ignore-patterns` | Comma-separated file patterns to ignore | No | `''` |
| `enable-pr-comments` | Post results as PR comments | No | `true` |
| `enable-labels` | Add pass/fail labels to PRs | No | `true` |
| `fail-on-error` | Fail workflow if checks fail | No | `true` |
| `output-format` | Output format (text/json/sarif) | No | `text` |
| `node-version` | Node.js version | No | `20` |
| `java-version` | Java version | No | `17` |
| `java-distribution` | Java distribution | No | `temurin` |
| `ktlint-version` | ktlint version | No | `1.0.1` |
| `rust-toolchain` | Rust toolchain | No | `stable` |
| `check-timeout` | Timeout per check (minutes) | No | `10` |

## Outputs

| Output | Description |
|--------|-------------|
| `status` | Overall status (`success` or `failure`) |
| `results-json` | JSON formatted results |
| `sarif-file` | Path to SARIF output file |

## Supported Languages & Checks

### C/C++
- Uninitialized variables
- Memory leaks
- Null pointer dereferences
- Buffer overflows
- Missing include guards
- Unsafe functions (`gets`, `strcpy`)

**Tool**: cppcheck (exhaustive mode)

### JavaScript/TypeScript
- `console.log` statements
- `var` keyword usage
- Loose equality (`==`)
- `eval()` usage
- Hard-coded secrets
- SQL injection
- Command injection
- Prototype pollution
- Weak randomness
- XSS vulnerabilities

**Tool**: Pattern matching

### Rust
- `unwrap()` in library code
- `println!` in library code
- Hard-coded secrets
- Excessive `unsafe` blocks
- `get_unchecked` usage
- Ignored Results
- Weak cryptography

**Tool**: Pattern matching + clippy (future)

### Kotlin
- Wildcard imports
- Force unwrap (`!!`)
- Hard-coded secrets
- SQL injection
- Weak randomness
- Insecure TLS
- Command injection

**Tool**: ktlint + pattern matching

### Swift
- Force unwrapping (`!`)
- Force casting (`as!`)
- Hard-coded secrets
- Weak randomness
- Insecure storage
- Retain cycles

**Tool**: Pattern matching

### Java
- Wildcard imports
- `System.out.println`
- Hard-coded credentials
- SQL injection
- Command injection
- Insecure deserialization
- Resource leaks
- Weak cryptography

**Tool**: Pattern matching

### Flutter/Dart
- `print()` statements
- Hard-coded secrets
- SQL injection
- Weak randomness
- Unsafe JSON casting
- Null assertion operator
- Blocking I/O

**Tool**: Pattern matching

### Dependency Scanning
- **npm audit**: JavaScript/TypeScript dependencies
- **cargo audit**: Rust dependencies

## Required Permissions

Your workflow needs these permissions:

```yaml
permissions:
  contents: read              # Read repository contents
  pull-requests: write        # Comment on PRs
  issues: write              # Add labels
  security-events: write     # Upload SARIF (if using SARIF output)
```

## Output Formats

### Text (Default)
Human-readable output in workflow logs and PR comments.

### JSON
Structured JSON output with file, line, severity, message, and rule ID.

```json
{
  "version": "1.0",
  "timestamp": "2024-12-16T10:30:00Z",
  "status": "failure",
  "results": [
    {
      "file": "src/app.js",
      "line": 42,
      "severity": "error",
      "message": "console.log statement found",
      "rule": "no-console"
    }
  ]
}
```

### SARIF
SARIF 2.1.0 format, automatically uploaded to GitHub Code Scanning.

## Troubleshooting

### Check timeout
If checks are timing out, increase the timeout:
```yaml
check-timeout: 20  # 20 minutes
```

### False positives
Disable specific language checks or use ignore patterns:
```yaml
enable-cpp-check: false
custom-ignore-patterns: '*.test.js,vendor/**'
```

### Permission errors
Ensure your workflow has the required permissions (see above).

### Tool installation failures
The action caches tool installations. If you encounter issues:
1. Check the workflow logs for specific error messages
2. Try clearing the cache by changing tool versions
3. Open an issue with the error details

### Rate limiting
If you're hitting GitHub API rate limits:
1. Use a personal access token with appropriate scopes
2. Reduce frequency of workflow runs

## Performance

- **Parallel Execution**: All language checks run concurrently
- **Caching**: Tools and dependencies are cached between runs
- **Typical Runtime**: 2-5 minutes for multi-language projects
- **Optimizations**:
  - Only changed files are analyzed
  - Tools are installed only when needed
  - Results are cached

## Security

This action implements several security best practices:

- ✅ All third-party actions pinned to commit SHAs
- ✅ Input sanitization for file paths
- ✅ No default token interpolation
- ✅ Configurable timeouts
- ✅ Path validation to prevent injection
- ✅ Dependency vulnerability scanning

See [SECURITY.md](SECURITY.md) for our full security policy.

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## Roadmap

- [ ] AST-based analysis (replace pattern matching)
- [ ] Support for more languages (Python, Go, Ruby)
- [ ] Custom rule definitions
- [ ] Baseline support (ignore existing issues)
- [ ] Integration with external SAST tools
- [ ] Auto-fix capabilities
- [ ] Configurable rule severity

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](https://github.com/Surabhis12/sanity-check-action/wiki)
- 🐛 [Issue Tracker](https://github.com/Surabhis12/sanity-check-action/issues)
- 💬 [Discussions](https://github.com/Surabhis12/sanity-check-action/discussions)

## Acknowledgments

Built with ❤️ using:
- [cppcheck](http://cppcheck.sourceforge.net/)
- [ktlint](https://ktlint.github.io/)
- [Rust Clippy](https://github.com/rust-lang/rust-clippy)
- [npm audit](https://docs.npmjs.com/cli/v8/commands/npm-audit)
- [cargo-audit](https://github.com/RustSec/rustsec)

---

Made with ❤️ by [Surabhis12](https://github.com/Surabhis12)