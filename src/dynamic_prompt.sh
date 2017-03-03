# Dynamic prompt!
# ver: 0.6
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

# Command to reload configuration
dyn_reload_config() {
    echo "Reloading configuration..."
    . $HOME/.dynamic_prompt
}

# Change prompt scheme
dyn_change_scheme() {
    echo "Changing prompt scheme to: '$1'"
    DYN_PROMPT_SCHEME=$1
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
    local git_top_level
    local git_prefix
    local branch_trailing
    local commits_check
    local commits_position
    local commits_number
    local commits_trailing

    if [ -z "$(git rev-parse --git-dir 2> /dev/null)" ]; then
        export PS1=$PS1_ORIG
    else
        base_prompt="$(echo $PS1_ORIG | sed -e 's/\\\$ *$//')${DYN_PROMPT_BRANCH_SEPARATOR}"

        # Current branch (we substitute * for k, because it was being expanded when echoing)
        branch_line=$(git --no-pager branch --no-color --list | grep "*" | sed -e 's/(//' | sed -e 's/)//' | sed -e 's/\*/k/' )
        if [ -z "$branch_line" ]; then
            branch_name="(no_branch_defined)"
        else
            if [ "$(echo $branch_line | cut -d' ' -f3)" = "from" ]; then
                branch_name="~"$(echo $branch_line | cut -d' ' -f4)"~"
                branch_type="detached"
            else
                branch_name=$(echo $branch_line | cut -d' ' -f2)
            fi
        fi

        # If branch type was not set (only way is that it is a detached branch) set the type
        if [ "$branch_type" = "" ]; then
            branch_type=$(echo $branch_name | cut -d"/" -f1)
        fi
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
        
        # Commits ahead/behind
        commits_check=$(git branch -v | grep "*" | sed -e "s/\[//" | sed -e "s/\]//" | sed -e 's/\*/k/' )
        commits_position=$(echo $commits_check|cut -d' ' -f4)
        commits_number=$(echo $commits_check|cut -d' ' -f5)
        
        if [ "$commits_position" = "ahead" ]; then
            commits_trailing="${DYN_COMMITS_SEPARATOR}$(dyn_color 2)${commits_number}+$(dyn_color reset)"
        elif [ "$commits_position" = "behind" ]; then
            commits_trailing="${DYN_COMMITS_SEPARATOR}$(dyn_color 1)${commits_number}-$(dyn_color reset)"
        else
            commits_trailing=""
        fi
        
        branch_trailing="${DYN_PROMPT_BRANCH_BEGIN}$branch ${DYN_PROMPT_BRANCH_STATUS[$status]}${commits_trailing}${DYN_PROMPT_BRANCH_END}"
        
        # Display the proper prompt scheme
        if [ "$DYN_PROMPT_SCHEME" = "1" ]; then
            local separator_line
            for F in `seq $(tput cols)`; do
                separator_line=${separator_line}${DYN_SEPARATOR_CHAR}
            done
            export PS1="$separator_line\n"
            export PS1="${PS1}$(dyn_color 8)Top level path: $(dyn_color 15)$(git rev-parse --show-toplevel)$(dyn_color reset)\n"
            export PS1="${PS1}$(dyn_color 8)  Working path: $(dyn_color 2)/$(git rev-parse --show-prefix)$(dyn_color reset)\n"
            export PS1="${PS1}$(dyn_color 8)[$(dyn_color 10)\u$(dyn_color 8)@$(dyn_color 12)\h$(dyn_color 8)]$(dyn_color reset)"
            export PS1="${PS1}${DYN_PROMPT_BRANCH_SEPARATOR}"
            export PS1="${PS1}${branch_trailing}\$ "
        else
            export PS1="${base_prompt}${branch_trailing}\$ "
        fi
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
    DYN_PROMPT_BRANCH_COLOR['detached']=13
    #.todo DYN_PROMPT_BRANCH_COLOR['bugfix']=1
fi

# Color for branches not matching any predefined name
DYN_PROMPT_BRANCH_DEFAULT_COLOR=${DYN_PROMPT_BRANCH_DEFAULT_COLOR:-13}

if [ -z "${DYN_PROMPT_BRANCH_STATUS[*]}" ]; then
    declare -A DYN_PROMPT_BRANCH_STATUS
    DYN_PROMPT_BRANCH_STATUS['no_changes']="$(dyn_color 10)\[\342\234\224\]$(dyn_color reset)"
    DYN_PROMPT_BRANCH_STATUS['conflicts']="$(dyn_color 1)\[\360\237\225\261\]$(dyn_color reset)"
    DYN_PROMPT_BRANCH_STATUS['changes']="$(dyn_color 9)!!$(dyn_color reset)"
fi

DYN_PROMPT_BRANCH_SEPARATOR=${DYN_PROMPT_BRANCH_SEPARATOR:-" - "}
DYN_PROMPT_BRANCH_BEGIN=${DYN_PROMPT_BRANCH_BEGIN:-"["}
DYN_PROMPT_BRANCH_END=${DYN_PROMPT_BRANCH_END:-"]"}

DYN_SEPARATOR_CHAR=${DYN_SEPARATOR_CHAR:-"\[\342\224\201\]"}
DYN_PROMPT_SCHEME=${DYN_PROMPT_SCHEME:-1}

DYN_COMMITS_SEPARATOR=${DYN_COMMITS_SEPARATOR:-"|"}

# Dynamic prompt activation
dyn_prompt_on
