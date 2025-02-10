# tp - simple directory teleporter

**tp** is a bash script that allows quick navigation to frequently used directories by saving and managing shortcuts. 

### USAGE

| command                          | description                                                         |
| -------------------------------- | ------------------------------------------------------------------- |
| `tp <ID>`                        | jump to saved address, or change directories based on address given |
| `tp <ID> -v`                     | jump to address and start neovim.                                   |
| `tp -list\|-l`                 | list all saved addresses.                                           |
| `tp -set\|-s <ID> <DIRECTORY>` | create or edit an address.                                          |
| `tp -unset\|-u <ID>`           | delete a saved address by id.                                       |
| `tp -unset-all\|-ua`           | delete all addresses.                                               |
| `tp -prune\|-p`                | remove all addresses with inaccessible directories.                 |

### INSTALLATION
1. clone this repository and move into the directory.
```bash
git clone https://github.com/latchk3y/tp.git && cd tp
```

2. run the install script. you must be able to copy into the `/usr/local/bin` folder, so run with sudo.
```bash
sudo ./install.sh
```

3. restart your terminal, or type the following.
```bash
source ~/.bashrc
```


### EXAMPLE
```bash
tp -set proj /path/to/project
tp proj -v   # navigates to /path/to/project and opens it in Neovim
tp -l        # lists all addresses
tp -u proj   # removes the 'proj' address
```

### LICENSE
officially, this is using "the unlicense", because i didn't know how to add a "do whatever the fuck you want" license. make of that what you will.
