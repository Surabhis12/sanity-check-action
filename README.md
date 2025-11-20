cat > README.md << 'EOF'
# Multi-Language Sanity Check Action

Reusable GitHub Action for automated code quality and vulnerability checks.

## Usage

In your repository, create `.github/workflows/sanity-check.yml`:
```yaml
name: Code Quality Check

on:
  pull_request:
    types: [opened, synchronize, reopened]

permissions:
  contents: read
  pull-requests: write
  issues: write

jobs:
  sanity-check:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout PR code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Run Sanity Check
        uses: Surabhis12/sanity-check-action@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Supported Languages

- C/C++ (cppcheck)
- JavaScript/TypeScript (pattern matching)
- Rust (pattern matching)
- Kotlin (pattern matching)
- Swift (pattern matching)
- Java (pattern matching)
- Dart/Flutter (pattern matching)

## Features

- Automatic language detection
- Security vulnerability scanning
- Code quality checks
- PR comments with results
- Automatic labeling (pass/fail)
- Blocks merging if checks fail

## Outputs

- `status`: Check status (success/failure)
EOF