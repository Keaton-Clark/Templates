#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
CYAN='\033[0;36m'

OPTIONS_FILE_CONTENTS=""
OPTIONS_FILE=tmplt_options
TEMPLATE_NAME=~/.Templates/$1
TEMPLATE=$1
NEW_NAME=$2
ESCAPE_STRING="TMPLT_ESCAPE"


function search_replace {
	count=$(grep -c $ESCAPE_STRING $1)
	tmp=0
	if [[ $count != 0 ]] ; then
		while [[ $tmp != 1 ]] ; do
			echo -e "There are ${CYAN}${count}${NC} occurances of ${ESCAPE_STRING} in ${CYAN}${1}${NC} \n1: Replace them all\n0: Replace them one-by-one"
			read tmp
		done
		if [ $tmp -eq 1 ] ; then
			echo -e "Replace them with..."
			read tmp
			sed -i s/${ESCAPE_STRING}/$tmp/g $1
		elif [ $tmp -eq 2 ] ; then
			echo -e "option not ready yet"
		fi
	fi	
}

function create_options {
	echo -e "\nCreating $OPTIONS_FILE in current directory...\n"
	touch $OPTIONS_FILE
	echo "$OPTIONS_FILE_CONTENTS" >> "$OPTIONS_FILE"
}

function show_help {
	echo -e "\nUsage: tmplt [template_name] [copy_name]"
	echo -e "   or: tmplt [command]\n"
	echo -e "Commands:"
	echo -e "-h or --help\tShow this message"
	echo -e "-o\t\tCreate tmplt_options.json in current directory\n"
	echo -e "-------Available Templates-------\n"
        for file in ~/.Templates/*; do
                echo -e "${CYAN}\t${file##*/}$NC"
                echo
        done

}

function recursive_rename {
	curr=$1
	new=${curr//$TEMPLATE/$NEW_NAME}
	if [[ $curr != $new ]] ; then
		mv $curr $new
		curr=${new}
	fi
	if [[ -f $curr ]] ; then
		search_replace $curr
		return 0
	elif [[ -d $curr ]] ; then
		for i in $curr/* ; do
			recursive_rename $i
		done
	fi
	return 0
}


if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
	show_help
	exit 0
elif [[ $1 == "-o" ]] ; then
	create_options
	exit 0
fi
if [[ -e $TEMPLATE_NAME ]] && [[ $2 != "" ]] ; then
	cp -r $TEMPLATE_NAME $NEW_NAME
	recursive_rename $NEW_NAME
else
	echo "$TEMPLATE_NAME does not exist, consider making new template."
fi


