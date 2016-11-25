# Dynamic prompt!
# ver: 0.2
# This script is to be included in the .bashrc file, so no bash header is applied

static_base_prompt="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w"

# Command to enable dynamic prompt
dyn_prompt_on() {
    PROMPT_COMMAND="dyn_prompt_set"
}

# Command to disable dynamic prompt
dyn_prompt_off() {
    export PS1="${static_base_prompt}\$ "
    PROMPT_COMMAND=""
}

# Command to configure prompt dynamically
dyn_prompt_set() {
    
    ISGITDIR=`git rev-parse --git-dir 2> /dev/null`
    if [ "$ISGITDIR" = "" ]; then
        export PS1="${static_base_prompt}\$ "
    else
        symbol_no_changes="\e[38;5;10m\342\234\224\e[0m"
        symbol_conflicts="\e[38;5;1m\360\237\225\261\e[0m"
        symbol_changes="\e[38;5;9m!!\e[0m"
        #symbol_ballot="\342\234\230"
        #symbol_warning="\342\232\240"
        
        dyn_base_prompt="${static_base_prompt} -"
        
        # Branch color upon name
        current_branch=`git branch --no-color| grep \* | cut -d" " -f2`
        current_pattern=`echo $current_branch | cut -d"/" -f1`

        # Define colors
        color_empty=8
        color_master=12
        color_develop=11
        color_feature=219
        color_release=2
        color_hotfix=1
        color_support=14
        color_unknown=8
        if [ "$current_branch" = "" ]; then
            current_branch="\e[38;5;${color_empty}m(empty)\e[0m"
        elif [ "$current_branch" = "master" ]; then
            current_branch="\e[38;5;${color_master}m${current_branch}\e[0m"
        elif [ "$current_branch" = "develop" ]; then
            current_branch="\e[38;5;${color_develop}m${current_branch}\e[0m"
        elif [ "$current_pattern" = "feature" ]; then
            current_branch="\e[38;5;${color_feature}m${current_branch}\e[0m"
        elif [ "$current_pattern" = "release" ]; then
            current_branch="\e[38;5;${color_release}m${current_branch}\e[0m"
        elif [ "$current_pattern" = "hotfix" ]; then
            current_branch="\e[38;5;${color_hotfix}m${current_branch}\e[0m"
        elif [ "$current_pattern" = "support" ]; then
            current_branch="\e[38;5;${color_support}m${current_branch}\e[0m"
        else
            current_branch="\e[38;5;${color_unknown}m${current_branch}\e[0m"
        fi

        # Branch status symbol and color
        current_status=`git status -s`;
        if [ "$current_status" = "" ]; then
            export PS1="${dyn_base_prompt} \[${current_branch} ${symbol_no_changes}\]\$ "
        else
            current_status=`git status -s | grep UU`
            if [ ! "$current_status" = "" ]; then
                export PS1="${dyn_base_prompt} \[${current_branch} ${symbol_conflicts}\]\$ "
            else
                export PS1="${dyn_base_prompt} \[${current_branch} ${symbol_changes}\]\$ "
            fi  
        fi 
    fi
}

export PROMPT_COMMAND="dyn_prompt_set"
