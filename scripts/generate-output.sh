#!/bin/bash
# Generate JSON or SARIF output from check results

set -e

OUTPUT_FORMAT="${1:-json}"

# Read all check results
RESULTS=""
for file in *_check.txt; do
  [ -f "$file" ] && RESULTS+="$(cat "$file")"$'\n'
done

generate_json() {
  echo '{'
  echo '  "version": "1.0",'
  echo '  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",'
  echo '  "status": "'${STATUS:-unknown}'",'
  echo '  "results": ['
  
  first=true
  while IFS= read -r line; do
    if [[ "$line" =~ ^(.+):([0-9]+):\ (error|warning):\ (.+)\ \[(.+)\]$ ]]; then
      file="${BASH_REMATCH[1]}"
      line_num="${BASH_REMATCH[2]}"
      severity="${BASH_REMATCH[3]}"
      message="${BASH_REMATCH[4]}"
      rule="${BASH_REMATCH[5]}"
      
      [ "$first" = false ] && echo ','
      first=false
      
      echo '    {'
      echo '      "file": "'$file'",'
      echo '      "line": '$line_num','
      echo '      "severity": "'$severity'",'
      echo '      "message": "'$message'",'
      echo '      "rule": "'$rule'"'
      echo -n '    }'
    fi
  done <<< "$RESULTS"
  
  echo ''
  echo '  ]'
  echo '}'
}

generate_sarif() {
  echo '{'
  echo '  "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json",'
  echo '  "version": "2.1.0",'
  echo '  "runs": ['
  echo '    {'
  echo '      "tool": {'
  echo '        "driver": {'
  echo '          "name": "Multi-Language Sanity Check",'
  echo '          "version": "1.0.0",'
  echo '          "informationUri": "https://github.com/Surabhis12/sanity-check-action",'
  echo '          "rules": ['
  
  # Extract unique rules
  rules=$(echo "$RESULTS" | grep -oP '\[[\w-]+\]' | sort -u | sed 's/\[\(.*\)\]/\1/')
  
  first_rule=true
  for rule in $rules; do
    [ "$first_rule" = false ] && echo ','
    first_rule=false
    
    echo '            {'
    echo '              "id": "'$rule'",'
    echo '              "name": "'$rule'",'
    echo '              "shortDescription": {'
    echo '                "text": "Code quality or security issue"'
    echo '              }'
    echo -n '            }'
  done
  
  echo ''
  echo '          ]'
  echo '        }'
  echo '      },'
  echo '      "results": ['
  
  first=true
  while IFS= read -r line; do
    if [[ "$line" =~ ^(.+):([0-9]+):\ (error|warning):\ (.+)\ \[(.+)\]$ ]]; then
      file="${BASH_REMATCH[1]}"
      line_num="${BASH_REMATCH[2]}"
      severity="${BASH_REMATCH[3]}"
      message="${BASH_REMATCH[4]}"
      rule="${BASH_REMATCH[5]}"
      
      # Map severity
      sarif_level="warning"
      [ "$severity" = "error" ] && sarif_level="error"
      
      [ "$first" = false ] && echo ','
      first=false
      
      echo '        {'
      echo '          "ruleId": "'$rule'",'
      echo '          "level": "'$sarif_level'",'
      echo '          "message": {'
      echo '            "text": "'$message'"'
      echo '          },'
      echo '          "locations": ['
      echo '            {'
      echo '              "physicalLocation": {'
      echo '                "artifactLocation": {'
      echo '                  "uri": "'$file'"'
      echo '                },'
      echo '                "region": {'
      echo '                  "startLine": '$line_num
      echo '                }'
      echo '              }'
      echo '            }'
      echo '          ]'
      echo -n '        }'
    fi
  done <<< "$RESULTS"
  
  echo ''
  echo '      ]'
  echo '    }'
  echo '  ]'
  echo '}'
}

case "$OUTPUT_FORMAT" in
  json)
    generate_json
    ;;
  sarif)
    generate_sarif
    ;;
  *)
    echo "Invalid output format: $OUTPUT_FORMAT" >&2
    exit 1
    ;;
esac