# Dynamic prompt!
# ver: 0.4
# This script is to be included in the .bashrc file, so no bash header is applied
#

# Check for configuration file to load user defined variables
#if [ -f "$HOME/.cfg_dynamic_prompt" ]; then
#    . $HOME/.cfg_dynamic_prompt
#fi

# Command to print a color string
dyn_color() {
    if [ "$1" = "reset" ]; then
        echo -n "\[\e[0m\]"
    else
        echo -n "\[\e[38;5;${1}m\]"
    fi
}

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
    local base_prompt
    local branch
    local branch_color
    local branch_line
    local branch_name
    local branch_prompt
    local branch_type
    local status

    if [ -z "$(git rev-parse --git-dir 2> /dev/null)" ]; then
        export PS1=$PS1_ORIG
    else
        base_prompt="$(echo $PS1_ORIG | sed -e 's/\\\$ *$//')${DYN_PROMPT_BRANCH_SEPARATOR}"

        # Current branch
        branch_line=$(git --no-pager branch --no-color --list | grep \*)
        if [ -z "$branch_line" ]; then
            branch_name="(no_branch_defined)"
        else
            if [ "${branch_line/HEAD detached/}" = "$branch_line" ]; then
                branch_name=$(echo "$branch_line" | cut -d' ' -f 2)
            else
                branch_name="("$(echo "$branch_line" | cut -d' ' -f 5)
            fi
        fi

        branch_type=$(echo $branch_name | cut -d"/" -f1)
        branch_color=${DYN_PROMPT_BRANCH_COLOR[$branch_type]:-$DYN_PROMPT_BRANCH_DEFAULT_COLOR}
        branch="$(dyn_color ${branch_color})${branch_name}$(dyn_color reset)"

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
    DYN_PROMPT_BRANCH_STATUS['no_changes']="$(dyn_color 10)\[\342\234\224\]$(dyn_color reset)"
    DYN_PROMPT_BRANCH_STATUS['conflicts']="$(dyn_color 1)\[\360\237\225\261\]$(dyn_color reset)"
    DYN_PROMPT_BRANCH_STATUS['changes']="$(dyn_color 9)!!$(dyn_color reset)"
fi

DYN_PROMPT_BRANCH_SEPARATOR=${DYN_PROMPT_BRANCH_SEPARATOR:-" - "}
DYN_PROMPT_BRANCH_BEGIN=${DYN_PROMPT_BRANCH_BEGIN:-"["}
DYN_PROMPT_BRANCH_END=${DYN_PROMPT_BRANCH_END:-"]"}

# Dynamic prompt activation
dyn_prompt_on
