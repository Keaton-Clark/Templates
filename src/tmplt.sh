#!/bin/bash

tmpl=~/Templates/$1
name=$2


if [[ $1 == "" ]] ; then
        echo "pass in template name"
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


