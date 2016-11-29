# Dynamic Bash Prompt Script
A dynamically changing prompt for Bash shell.
Current version: `0.5`

## Features
* Support for **git** project folders
  * Shows the current branch name
  * Shows a colored symbol representing the status of the branch (no changes, modified, conflicted)
* Configuration file for customizing prompt output
* Configurable prompt schemes (default and scheme #1)

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

## Configuration
Some parameters can be configured before importing this script. When installing
the script, a default configuration file `.cfg_dynamic_prompt` is created
in the `$HOME` folder with a sample (default) configuration.

Currently configurable variables:

  1. `DYN_PROMPT_BRANCH_COLOR` is an array or color numbers for branch names. By
     default, branch names are taken from git flow. Real, visual color might
     change depending on terminal configuration.

  2. `DYN_PROMPT_BRANCH_DEFAULT_COLOR` is the color number used when the branch
     name does not match any of the predefined names in the previous array.

  3. `DYN_PROMPT_BRANCH_STATUS` is an array of colors and symbols to indicate
     the current status.

  4. `DYN_PROMPT_BRANCH_SEPARATOR` is a string used as a separator between your
     prompt and the branch indicator.

  5. `DYN_PROMPT_BRANCH_BEGIN` and `DYN_PROMPT_BRANCH_END` are two characters
     used to wrap the branch+status indicator, usually `[` and `]`, `(` and `)`
     ...

  6. `DYN_PROMPT_SCHEME` is number that determines the prompt scheme to use.
     For the moment only 2 schemes are available: default and #1.

  7. `DYN_SEPARATOR_CHAR` is the character (and color) used to separate the 
     prompt from the previous output in some of the prompt schemes.

Probably you will need some experimentation with these variables to suite your
taste. For example, you might prefer:

~~~{.bash}
    DYN_PROMPT_BRANCH_SEPARATOR=" | "
    DYN_PROMPT_BRANCH_BEGIN=" "
    DYN_PROMPT_BRANCH_END=" "
~~~

## Author

  * Imanol Barberia (*imanol.barberia@gmail.com*) -  Original author
  * Francesc Rocher (*francesc.rocher@gmail.com*) -  Added configurable values
