ADDRESSES="$HOME/.config/.tp_addresses"
PREFIX="[ TP ] :: "

# color codes
RED='\033[0;31m'       
GREEN='\033[0;32m'     
YELLOW='\033[0;33m'    
BLUE='\033[0;34m'      
RESET='\033[0m'        

# initialize addresses file if it doesn't exist
if [[ ! -f "$ADDRESSES" ]]; then
    touch "$ADDRESSES"
fi

print_result() {
	local result=$1
	local color=$2
	
	echo "---------------------------------------------------------------------------"
	printf "$color$PREFIX${RESET}$result"
	echo
	echo "---------------------------------------------------------------------------"
}

list_addresses() {
	print_result "${GREEN}" "active shortcuts"
    # read the addresses, sort them by name, and then format the output
    while IFS='|' read -r name dir; do
		print_dir="$dir"

		if [[ ! -d "$dir" ]]; then 
			print_dir="${RED}$dir${RESET}"
		fi

        printf "[ ${YELLOW}$name${RESET} ] => \t$print_dir\n"
    done < "$ADDRESSES" | sort | column -t
    echo 
}

prune_addresses() {
	print_result "${GREEN}" "pruning addresses"
	while IFS='|' read -r name dir; do
		print_id="[ ${YELLOW}$name${RESET} ] => \t"
		print_dir="${GREEN}OKAY${RESET}"
		if [[ ! -d "$dir" ]]; then 
				# create a temporary file without the specified address
				grep -v "^$name|" "$ADDRESSES" > "$ADDRESSES.tmp"

				# check if the address was found and removed
				if [[ $? -eq 0 && -s "$ADDRESSES.tmp" ]]; then
					mv -f "$ADDRESSES.tmp" "$ADDRESSES"
					print_dir="${RED}PRUNED${RESET}"	
				fi
		fi
		printf "$print_id $print_dir\n"
	done < "$ADDRESSES" | sort | column -t
	echo
}

print_help() {
	print_result "${BLUE}" "A SIMPLE DIRECTORY TELEPORTER"
	
	printf "[ ${GREEN}<ID>${RESET} ] (-v OPT)"
	printf "\n\tjump to address. flag -v to start nvim immediately.\n\n"

	printf "[ ${GREEN}-list${RESET}, ${GREEN}-l${RESET} ]"
	printf "\n\tlist all existing addresses.\n\n"

	printf "[ ${GREEN}-set${RESET}, ${GREEN}-s${RESET}] <ID> <DIRECTORY>"
	printf "\n\tcreate or edit a address.\n\n"

	printf "[ ${GREEN}-unset${RESET}, ${GREEN}-u${RESET} ] <ID>"
	printf "\n\tdelete a single address. ${RED}this action cannot be undone!${RESET}\n\n"

	printf "[ ${GREEN}-unset-all${RESET}, ${GREEN}-ua${RESET} ]"
	printf "\n\tdelete all existing addresses. ${RED}this action cannot be undone!${RESET}\n\n"

	printf "[ ${GREEN}-prune${RESET}, ${GREEN}-p${RESET} ]"
	printf "\n\tremove all addresses with non-existent directories.\n\n"

	printf "[ ${GREEN}-help${RESET}, ${GREEN}-h${RESET} ]"
	printf "\n\tprint this screen.\n\n"

	echo	

}

if [[ "$1" == "-help" || "$1" == "-h" ]]; then
	print_help

elif [[ "$1" == "-prune" || "$1" == "-p" ]]; then
	prune_addresses

elif [[ "$1" == "-set" || "$1" == "-s" ]]; then
    name="$2"
    new_dir="$3"

    # check if the new directory exists
    if [[ ! -d "$new_dir" ]]; then
		print_result "${RED}" "'$new_dir' is not a valid directory."
		return
    fi

    # check if the address exists
    if grep -q "^$name|" "$ADDRESSES"; then
        # delete the address
		sed -i "/^$name|/d" "$ADDRESSES"

		# append new address
        echo "$name|$new_dir" >> "$ADDRESSES"
		print_result "${GREEN}" "address [ ${YELLOW}$name${RESET} ] => '$new_dir'."
    else
		# add new address
        echo "$name|$new_dir" >> "$ADDRESSES"
		print_result "${GREEN}" "added new address [ ${YELLOW}$name${RESET} ]."
    fi


elif [[ "$1" == "-unset" || $1 == "-u" ]]; then
	name="$2"
	if [[ -z "$name" ]]; then
		print_result "${RED}" "no address was given."
		return
	fi
 
    if ! grep -q "^$name|" "$ADDRESSES"; then
		print_result "${YELLOW}" "address '$name' does not exist."
		return
	fi

	# create a temporary file without the specified address
	grep -v "^$name|" "$ADDRESSES" > "$ADDRESSES.tmp"

	# check if the address was found and removed
	if [[ $? -eq 0 && -s "$ADDRESSES.tmp" ]]; then
		mv -f "$ADDRESSES.tmp" "$ADDRESSES"
		print_result "${GREEN}" "address '$name' removed."
	fi

	
elif [[ "$1" == "-unset-all" || "$1" == "-ua" ]]; then
    > "$ADDRESSES"
	print_result "${GREEN}" "all addresses cleared"


elif [[ "$1" == "-list" || "$1" == "-l" ]]; then
	list_addresses


else 
    name="$1"

	if [[ -z "$name" ]]; then
		print_help
		return
	fi

	# if just passed a normal directory, change to that directory.
	# basically just makes this cd.
	if [[ -d "$name" ]]; then 
		if cd "$name"; then
			clear; ls
			if [[ "$2" == "-v" ]]; then 
				nvim
			fi
		fi
		return
	fi


    # look up directory
    dir=$(grep "^$name|" "$ADDRESSES" | cut -d '|' -f 2)

    if [[ -n "$dir" ]]; then 
        if cd "$dir"; then
			clear; ls
			if [[ "$2" == "-v" ]]; then 
				nvim
			fi
		else
			print_result "${RED}" "'$dir' was not found."
			return
		fi
	else 
		print_result "${RED}" "address [ ${YELLOW}$name${RESET} ] is not set to anything."
		return
	fi
fi

