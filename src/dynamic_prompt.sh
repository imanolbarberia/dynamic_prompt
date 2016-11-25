# Dynamic prompt!
# ver: 0.3
# This script is to be included in the .bashrc file, so no bash header is applied
# 

# Check for configuration file to load user defined variables
if [ -f "$HOME/.cfg_dynamic_prompt" ]; then
    . $HOME/.cfg_dynamic_prompt
fi

# Command to enable dynamic prompt
dyn_prompt_on() {
    if [ -z "$PROMPT_COMMAND" ]; then
        PROMPT_COMMAND="dyn_prompt_set"
        export PS1_ORIG=$PS1
    fi
}

# Command to disable dynamic prompt
dyn_prompt_off() {
    if [ -n "$PROMPT_COMMAND" ]; then
        export PS1=$PS1_ORIG
        PROMPT_COMMAND=""
    fi
}

# Command to configure prompt dynamically
dyn_prompt_set() {

    if [ -z "$(git rev-parse --git-dir 2> /dev/null)" ]; then
        export PS1=$PS1_ORIG
    else
        base_prompt="$(echo $PS1_ORIG | sed -e 's/\\\$ *$//')${DYN_PROMPT_BRANCH_SEPARATOR}"

        # Current branch
        branch_name=$(git branch --no-color| grep \* | cut -d" " -f2)
        branch_type=$(echo $branch_name | cut -d"/" -f1)
        branch_color=${DYN_PROMPT_BRANCH_COLOR[$branch_type]:-$DYN_PROMPT_BRANCH_DEFAULT_COLOR}
        branch="\e[38;5;${branch_color}m${branch_name}\e[0m"

        # Status symbol and color
        status="no_changes"
        if [ -n "$(git status -s)" ]; then
            if [ -n "$(git status -s | grep UU)" ]; then
                status="conflicts"
            else
                status="changes"
            fi
        fi
        export PS1="${base_prompt}${DYN_PROMPT_BRANCH_BEGIN}$branch ${DYN_PROMPT_BRANCH_STATUS[$status]}${DYN_PROMPT_BRANCH_END}\$ "
    fi
}

# Set default values if there are no previous user definitions

# Branch colors, mostly according to git flow
if [ -z "${DYN_PROMPT_BRANCH_COLOR}" ]; then
    declare -A DYN_PROMPT_BRANCH_COLOR
    DYN_PROMPT_BRANCH_COLOR['master']=12
    DYN_PROMPT_BRANCH_COLOR['develop']=11
    DYN_PROMPT_BRANCH_COLOR['feature']=219
    DYN_PROMPT_BRANCH_COLOR['release']=2
    DYN_PROMPT_BRANCH_COLOR['hotfix']=1
    DYN_PROMPT_BRANCH_COLOR['support']=14
    #.todo DYN_PROMPT_BRANCH_COLOR['bugfix']=1
fi

# Color for branches not matching any predefined name
DYN_PROMPT_BRANCH_DEFAULT_COLOR=${DYN_PROMPT_BRANCH_DEFAULT_COLOR:-13}

if [ -z "${DYN_PROMPT_BRANCH_STATUS}" ]; then
    declare -A DYN_PROMPT_BRANCH_STATUS
    DYN_PROMPT_BRANCH_STATUS['no_changes']="\e[38;5;10m\342\234\224\e[0m"
    DYN_PROMPT_BRANCH_STATUS['conflicts']="\e[38;5;1m\360\237\225\261\e[0m"
    DYN_PROMPT_BRANCH_STATUS['changes']="\e[38;5;9m!!\e[0m"
fi

DYN_PROMPT_BRANCH_SEPARATOR=${DYN_PROMPT_BRANCH_SEPARATOR:-" - "}
DYN_PROMPT_BRANCH_BEGIN=${DYN_PROMPT_BRANCH_BEGIN:-"["}
DYN_PROMPT_BRANCH_END=${DYN_PROMPT_BRANCH_END:-"]"}

# Dynamic prompt activation
dyn_prompt_on
