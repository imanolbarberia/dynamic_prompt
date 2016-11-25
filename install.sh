#!/bin/bash

BASHRC=$HOME/.bashrc
PROMPTNAME=.dynamic_prompt
PROMPTFILE=$HOME/$PROMPTNAME
NEWFILE=src/dynamic_prompt.sh
NEWCFGFILE=src/config.sample
CFGFILE=$HOME/.cfg_dynamic_prompt

# Check if the script is already deployed
if [ -f $PROMPTFILE ]; then
    # Script deployed, check if update needed
    DIFF=`diff $PROMPTFILE $NEWFILE`
    VER_INSTALLED=`cat $PROMPTFILE | grep "ver" | cut -d":" -f2 | sed -e "s/ //g"`
    VER_NEW=`cat $NEWFILE | grep "ver" | cut -d":" -f2 | sed -e "s/ //g"`

    if [ "$DIFF" = "" ]; then
    	echo -e "[\e[38;5;12mINFO\e[0m]: The script was already installed at this same version: \e[38;5;9m$VER_INSTALLED\e[0m"
    else
        echo -e -n "[\e[38;5;11mWARNING\e[0m]: The installed script (\e[38;5;9mv$VER_INSTALLED\e[0m) is different from the new one (\e[38;5;9mv$VER_NEW\e[0m). Do you want to continue (y/n)? [Enter=n] "
        read continue
        if [ "$continue" = "y" ]; then
            echo "OK, installing new script."
            cat $NEWFILE > $PROMPTFILE
        else 
            echo "NOT doing anything."
        fi
    fi
else
    # Script not deployed, so go for it!
    echo "Installing script in $HOME... "
    cat $NEWFILE > $PROMPTFILE
    cat $NEWCFGFILE > $CFGFILE

    LINE=`cat $BASHRC | grep "$PROMPTNAME"`
    if [ "$LINE" = "" ]; then
    	echo "Modifying .bashrc... "
    	echo >> $BASHRC
    	echo "# Dynamic prompt" >> $BASHRC
    	echo ". \$HOME/.dynamic_prompt" >> $BASHRC
    fi

    # Information notice
    echo -e "\n[\e[38;5;12mINFO\e[0m]: Please restart BASH session in order to correctly import changes.\n"
fi

# Check if the script is being imported from bashrc
LINE=`cat $BASHRC | grep "$PROMPTNAME"`
if [ "$LINE" = "" ] && [ -f $PROMPTFILE ]; then
    echo "Modifying .bashrc... "
    echo >> $BASHRC
    echo "# Dynamic prompt" >> $BASHRC
    echo ". \$HOME/.dynamic_prompt" >> $BASHRC
fi
