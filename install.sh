#!/bin/bash

TP_INST_PREFIX="[ TP ] :: "

# Color codes
RED='\033[0;31m'       
GREEN='\033[0;32m'     
YELLOW='\033[0;33m'    
BLUE='\033[0;34m'      
RESET='\033[0m'

# Check if the user is running as sudo
if [[ $EUID -ne 0 ]]; then
    printf "${RED}$TP_INST_PREFIX${RESET} Installation requires sudo privileges for copying the file."
    echo
fi

# Define the source and destination paths
SOURCE="./teleport"
DESTINATION="/usr/local/bin/teleport"

# Copy teleport.sh to /usr/local/bin using sudo
if sudo cp "$SOURCE" "$DESTINATION"; then
    printf "${GREEN}$TP_INST_PREFIX${RESET} Copied teleport to /usr/local/bin."
    echo
else
    printf "${RED}$TP_INST_PREFIX${RESET} Failed to copy teleport.sh to /usr/local/bin; check permissions."
    echo
    exit 1
fi

# Check if the tp function is already in ~/.bashrc
if grep -qF 'TP :: a simple directory teleporter' ~/.bashrc; then
    printf "${YELLOW}$TP_INST_PREFIX${RESET} tp has already been defined in ~/.bashrc; skipping."
    echo 
else
    # output to ~/.bashrc and handle errors
	echo "
	# TP :: a simple directory teleporter
	tp() {
		local flags=\"\$@\"
		source teleport \$flags
	}
	" >> ~/.bashrc 

    # Check if the function was successfully added
    if grep -Fxq 'TP :: a simple directory teleporter' ~/.bashrc; then
        printf "${GREEN}$TP_INST_PREFIX${RESET} added tp to ~/.bashrc."
        echo
    else
        printf "${RED}$TP_INST_PREFIX${RESET} failed to add tp to ~/.bashrc. See /tmp/error.log for details."
        echo
        cat /tmp/error.log 
		exit 1
    fi
fi

printf "${BLUE}$TP_INST_PREFIX${RESET} Setup completed; restart your terminal, or use ${YELLOW}source ~/.bashrc${RESET} to use ${BLUE}tp${RESET}."
echo

