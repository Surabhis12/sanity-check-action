#!/bin/bash
# Java Sanity Check - Clean cppcheck-like output format

set -e

if [ ! -f java_files.txt ]; then
    echo "No Java files to check"
    exit 0
fi

# Check if file is empty
if [ ! -s java_files.txt ]; then
    echo "No Java files to check (empty list)"
    exit 0
fi

echo "==============================="
echo "JAVA SANITY CHECK REQUIREMENTS"
echo "==============================="
echo ""
echo "Files to check:"
cat java_files.txt
echo ""

FAILED=false
ERROR_COUNT=0

# Read files line by line
while IFS= read -r file; do
    # Skip empty lines
    [ -z "$file" ] && continue
    
    # Verify file exists and is a Java file
    if [ ! -f "$file" ]; then
        echo "Warning: File not found: $file"
        continue
    fi
    
    # CRITICAL: Only process .java files
    if [[ ! "$file" =~ \.java$ ]]; then
        echo "Warning: Skipping non-Java file: $file"
        continue
    fi
    
    echo "Checking: $file"
    
    # Class naming
    if grep -n "^class [a-z]\|^public class [a-z]" "$file" > /dev/null 2>&1; then
        grep -n "^class [a-z]\|^public class [a-z]" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: class name should be PascalCase [class-naming]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # System.out.println
    if grep -n "System\.out\.println" "$file" > /dev/null 2>&1; then
        grep -n "System\.out\.println" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: warning: System.out.println used, consider using a logger [system-out]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # Wildcard imports
    if grep -n "import .*\.\*;" "$file" > /dev/null 2>&1; then
        grep -n "import .*\.\*;" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: warning: wildcard import used [wildcard-import]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # Hard-coded credentials
    if grep -inE "(password|secret|api[_-]?key|private[_-]?key)\s*=\s*\"" "$file" > /dev/null 2>&1; then
        grep -inE "(password|secret|api[_-]?key)\s*=\s*\"" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: hard-coded credential found [hardcoded-password]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # SQL injection
    if grep -n "\"SELECT.*+\|\"INSERT.*+\|\"UPDATE.*+\|String.*sql.*=.*+" "$file" > /dev/null 2>&1; then
        grep -n "\"SELECT.*+\|String.*sql.*=" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: SQL injection via string concatenation [sql-injection]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # Command injection
    if grep -n "Runtime\.getRuntime()\.exec\|ProcessBuilder\|\.exec(" "$file" > /dev/null 2>&1; then
        grep -n "Runtime.*exec\|ProcessBuilder" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: system command execution (command injection risk) [command-injection]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # Insecure TLS
    if grep -n "TrustManager\|checkServerTrusted\|getAcceptedIssuers" "$file" > /dev/null 2>&1; then
        grep -n "TrustManager\|checkServerTrusted" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: TLS certificate validation disabled [insecure-tls]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # Insecure deserialization
    if grep -n "ObjectInputStream.*readObject()" "$file" > /dev/null 2>&1; then
        grep -n "ObjectInputStream\|readObject" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: insecure deserialization (gadget attack risk) [unsafe-deserialization]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # Weak randomness
    if grep -n "new Random(System\.currentTimeMillis()" "$file" > /dev/null 2>&1; then
        grep -n "new Random(" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: weak randomness with predictable seed [insecure-random]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # Null pointer patterns
    if grep -n "== null" "$file" > /dev/null 2>&1 && grep -n "\.length()\|\.toString()" "$file" > /dev/null 2>&1; then
        grep -n "== null" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: warning: potential null pointer dereference [null-dereference]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # Resource leaks
    if grep -n "new FileInputStream\|new FileReader\|new BufferedReader" "$file" > /dev/null 2>&1; then
        if ! grep -n "try-with-resources\|\.close()" "$file" > /dev/null 2>&1; then
            grep -n "new File.*Stream\|new.*Reader" "$file" | while IFS=: read -r line_num line_content; do
                echo "$file:$line_num: warning: potential resource leak (stream not closed) [resource-leak]"
            done
            ERROR_COUNT=$((ERROR_COUNT + 1))
            FAILED=true
        fi
    fi
    
    # String == comparison
    if grep -n "String.*==\|== new String" "$file" > /dev/null 2>&1; then
        grep -n "String.*==\|== new String" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: String comparison with ==, use .equals() [string-compare]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # equals() without hashCode()
    if grep -n "public boolean equals(Object" "$file" > /dev/null 2>&1 && ! grep -n "public int hashCode()" "$file" > /dev/null 2>&1; then
        grep -n "public boolean equals" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: warning: equals() overridden but not hashCode() [missing-hashcode]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # Weak MD5/DES
    if grep -n "MessageDigest\.getInstance.*MD5\|Cipher\.getInstance.*DES\|\"MD5\"\|\"DES\"" "$file" > /dev/null 2>&1; then
        grep -n "MD5\|DES" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: weak cryptography (MD5/DES) [weak-hash]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
    # AES/ECB mode
    if grep -n "AES/ECB\|Cipher\.getInstance.*AES/ECB" "$file" > /dev/null 2>&1; then
        grep -n "ECB" "$file" | while IFS=: read -r line_num line_content; do
            echo "$file:$line_num: error: insecure AES/ECB mode [weak-cipher]"
        done
        ERROR_COUNT=$((ERROR_COUNT + 1))
        FAILED=true
    fi
    
done < java_files.txt

echo ""
echo "================================"
if [ "$FAILED" = true ]; then
    echo "❌ Java sanity check FAILED"
    echo "Total issues found: $ERROR_COUNT"
    exit 1
else
    echo "✅ Java sanity check PASSED"
    exit 0
fi