# Dynamic Bash Prompt Script
A dynamically changing prompt for Bash shell.
Current version: `0.2`

## Features
* Support for **git** project folders
  * Shows the current branch name
  * Shows a colored symbol representing the status of the branch (no changes, modified, conflicted)

## How to install
Just run the `install.sh` file that can be found in the root folder.
```
user1@computer:~/dynamic-bash-prompt$ ls
total 12
-rwxrwxr-x 1 user1 user1 1779 nov 25 12:03 install.sh
-rw-rw-r-- 1 user1 user1   30 nov 25 10:16 readme.md
drwxrwxr-x 2 user1 user1 4096 nov 25 12:07 src
user1@computer:~/dynamic-bash-prompt$ ./install
Installing script in /home/user1...
Modifying .bashrc...

[INFO]: Please restart BASH session in order to correctly import changes.

user1@computer:~/dynamic-bash-prompt$
```

## Author
Imanol Barberia (*imanol.barberia@gmail.com*)
