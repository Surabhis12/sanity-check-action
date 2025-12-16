# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability within this GitHub Action, please send an email to security@example.com (replace with your actual security contact). All security vulnerabilities will be promptly addressed.

**Please do NOT open a public issue for security vulnerabilities.**

### What to include in your report:

- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact
- Suggested fix (if available)

### Response Timeline:

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity
  - Critical: 1-3 days
  - High: 7-14 days
  - Medium: 30 days
  - Low: 60 days

## Security Best Practices

### For Action Users:

1. **Always pin actions to full commit SHA**
   ```yaml
   uses: Surabhis12/sanity-check-action@<full-commit-sha>
   ```

2. **Use minimal token permissions**
   ```yaml
   permissions:
     contents: read
     pull-requests: write
     issues: write
   ```

3. **Don't expose secrets in workflow files**
   ```yaml
   # ❌ Bad
   github-token: ghp_xxxxxxxxxxxx
   
   # ✅ Good
   github-token: ${{ secrets.GITHUB_TOKEN }}
   ```

4. **Review workflow logs for sensitive data**
   - Ensure no secrets are printed
   - Check that file paths don't expose internal structure

5. **Keep dependencies updated**
   - Regularly update to the latest version
   - Review changelog for security fixes

### Action Security Features:

- **Input Sanitization**: All file paths and inputs are sanitized
- **Pinned Dependencies**: All third-party actions use commit SHAs
- **Timeout Protection**: Checks have configurable timeouts
- **Token Scope**: Requires explicit token passing (no default interpolation)
- **Path Validation**: Suspicious file paths are skipped
- **Dependency Scanning**: Optional vulnerability scanning for dependencies

## Known Limitations

1. **Pattern-Based Detection**: Most checks use regex patterns, not AST analysis
2. **False Positives**: Some checks may flag legitimate code
3. **Language Coverage**: Not all security issues are detected
4. **Third-Party Tools**: Depends on external tools like cppcheck, npm audit

## Security Vulnerability History

No known security vulnerabilities at this time.

## Acknowledgments

We thank the following for responsibly disclosing security issues:

- (List will be updated as reports come in)

## Additional Resources

- [GitHub Actions Security Best Practices](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE/SANS Top 25](https://cwe.mitre.org/top25/)

---

Last Updated: 2024-12-16