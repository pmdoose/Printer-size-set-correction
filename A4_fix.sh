#!/bin/bash

# Function which applies default paper size to all matchint printers
set_paper_size() {
    local PRN_REGEX="$1"
    local SIZE="$2"

    # This is to color terminal output it is not strictly nessarry, but helps identify when things are changed or errors occur
    if [[ -t 1 ]]; then
        # If we are in a terminal window
        local GREEN='\033[0;32m'
        local RED='\033[0;31m'
        local YELLOW='\033[0;33m'
        local NC='\033[0m' # Color reset
    else
        # If this is output to somewhere else
        local GREEN=''
        local RED=''
        local YELLOW=''
        local NC=''
    fi

    # Read all printers, from lpstat (at end of loop)
    while IFS= read -r PRN; do
        local PRN_INFO=$(lpstat -l -p "$PRN")

        # Check if printer matches
        if [[ $PRN_INFO =~ $PRN_REGEX ]]; then
            
            # Get current page size
            CURRENT=$(lpoptions -p "$PRN" -l 2>/dev/null \
                | awk -F': ' '/PageSize/ {print $2}' \
                | grep -o '\*[^ ]*' \
                | tr -d '*')

            # check current size against what we want to set
            if [[ -z "$CURRENT" || "$CURRENT" != "$SIZE" ]]; then
                # Set size and report errors
                if lpadmin -p "$PRN" -o PageSize="$SIZE"; then
                    # Change is needed, so apply update
                    echo -e "  ${GREEN}Updated: $PRN page size from $CURRENT to $SIZE${NC}"
                else
                    # And error occured so we need to notify the user
                    echo -e "  ${RED}Error: Failed to update $PRN${NC}"
                fi
            else
                # Size is already good, no need to change
                echo -e "  ${YELLOW}No change: $PRN is already set to $SIZE${NC}"
            fi
        fi
    done < <(lpstat -e)
}

#$1 is regex containing strings in printer names we want to look for you can limit models if nessarry e.g "(BizHub.*1100)|(AccutioPrint.*2100)"
#$2 is string containing the paper size we want to set as default e.g. "Letter", or "A4"
set_paper_size "Konica|Accurio|BizHub|Xerox|Altalink" "Letter"
