#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
CYAN='\033[0;36m'

tmpl=~/.Templates/$1
name=$2

showTemplates(){
        echo -e "-------Available Templates-------\n"
        for file in ~/.Templates/*; do
                echo -e "${CYAN}\t${file##*/}$NC"
                echo
        done

}


if [[ $1 == "" ]] ; then
        echo -e "\nProper use '${RED}tmplt template_name new_name$NC'\n"
        showTemplates
elif [[ $1 == "-l" ]] ; then
        showTemplates
elif [[ $2 == "" ]] ; then
        echo "pass in destination name"
elif [[ -f $tmpl ]] ; then
        cp $tmpl $name
elif [[ -d $tmpl ]] ; then
        cp -r $tmpl $name
        for i in $2/$1.* ; do
                fileType=`echo $i|awk -F "." '{print $2}'`
                mv $i $name/$name.$fileType
        done
else
        echo "$tmpl does not exist, consider making new template."
fi

