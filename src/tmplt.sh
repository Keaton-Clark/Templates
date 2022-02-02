#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
CYAN='\033[0;36m'

OPTIONS_FILE=tmplt_options
OPTIONS_FILE_CONTENTS=""
TEMPLATE_NAME=~/.Templates/$1
TEMPLATE=$1
NEW_NAME=$2
ESCAPE_STRING="TMPLT_ESCAPE"

function main {

	if [[ $1 == "" ]] ; then
		echo -e "tmplt: missing argument\nUse 'tmplt --help' for information."
		return 0
	else
		# Flags
		if [[ $1 == "-h" ]] || [[ $1 == "--help" ]] ; then
			show_help
			exit 0
		elif [[ $1 == "-o" ]] ; then
			create_options
			exit 0
		elif [[ $2 == "" ]] ; then
			echo -e "tmplt: missing argument\nUse 'tmplt --help' for information."
			exit 0
		fi
		
		# Normal operation
		if [[ -e $TEMPLATE_NAME ]] && [[ $2 != "" ]] ; then
			cp -r $TEMPLATE_NAME $NEW_NAME
			recursive_rename $NEW_NAME
		else
			echo "tmplt: $TEMPLATE_NAME does not exist, consider making new template."
		fi
	fi

}

function search_replace { 

	count=$(grep -c $ESCAPE_STRING $1)
	tmp=0
	if [[ $count != 0 ]] ; then
		if [[ $count != 1 ]] ; then
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
		else
			echo -e "There is ${CYAN}1${NC} occurance of ${ESCAPE_STRING} in ${CYAN}${1}${NC}\nReplace it with..."
			read tmp
			sed -i s/${ESCAPE_STRING}/$tmp/g $1
		fi
	fi

}

function create_options {

	touch $OPTIONS_FILE
	if [[ -f $OPTIONS_FILE ]] ; then
		echo -e "\ntmplt: Creating $OPTIONS_FILE in current directory...\n"
		echo "$OPTIONS_FILE_CONTENTS" >> "$OPTIONS_FILE"
	else 
		echo -e "\nCannot create $OPTIONS_FILE in current directory\n"
	fi

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



main $1 $2
