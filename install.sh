#!/bin/bash

PREFIX="[ TP ] :: "

# color codes
RED='\033[0;31m'       
GREEN='\033[0;32m'     
YELLOW='\033[0;33m'    
BLUE='\033[0;34m'      
RESET='\033[0m'

# Check if the user is running as sudo
if [[ $EUID -ne 0 ]]; then
	printf "${RED}$PREFIX${RESET}installation requires sudo privileges."
    echo
    exit 1
fi

# Define the source and destination paths
SOURCE="./teleport.sh"
DESTINATION="/usr/local/bin/teleport.sh"

# Copy teleport.sh to /usr/local/bin
if cp "$SOURCE" "$DESTINATION"; then
	printf "${GREEN}$PREFIX${RESET}copied teleport.sh to /usr/local/bin"
    echo
else
	printf "${RED}$PREFIX${RESET}failed to copy teleport.sh to /usr/local/bin; check permissions."
    echo
    exit 1
fi

# Define the tp function to be added to ~/.bashrc
tp_function='
# TP function to run teleport.sh with arguments
tp() {
    # Capture all arguments passed to the function
    local flags="$@"

    # Source the script and pass the flags
    source /usr/local/bin/teleport.sh $flags
}
'

# Check if the tp function is already in ~/.bashrc
if grep -q 'tp() {' ~/.bashrc; then
	printf "${YELLOW}$PREFIX${RESET}tp has already been defined in ~/.bashrc; skipping."
    echo 
else
    # Append the tp function to ~/.bashrc
    echo "$tp_function" >> ~/.bashrc
	printf "${GREEN}$PREFIX${RESET}added tp to ~/.bashrc" 
    echo
fi

printf "${BLUE}$PREFIX${RESET}setup completed; restart your terminal, or use ${YELLOW}source ~/.bashrc${RESET} to use ${BLUE}tp${RESET}"
echo

