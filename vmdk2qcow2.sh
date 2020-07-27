#!/bin/bash
#this script coverts ova and vmdk files to qcow2 disk images 
#Author: Khalu

echo "Useage:"
echo "./vmdk2qcow2.sh /home/user/Virtual Machines/Target.ova /optional/output/directory"

remove_flag=0

function extract_file {
    #extracts the file passed in $1 to the directory passed in $2
    #also sets the remove_flag var for removal after convervsion
    echo "extracting to /tmp/$2"
	mkdir /tmp/"$2"
	tar xf "$1" --directory /tmp/"$2"
	remove_flag=1
	gz_file=$(find "/tmp/$2" -name "*.gz" 2> /dev/null)
  	if [ $(echo "$gz_file" | wc -l )  -eq 1 ];
  	then
 	  gunzip -c $gz_file > /tmp/"$2"/"$2".vmdk
  	fi
	}

function find_vmdk_file {
        #attempts to find the VMDK file to convert
        find_file=$(find "$1" -name "*.vmdk" 2> /dev/null)
        #if only one result then it is likely the correct file
        if [ $(echo "$find_file" | wc -l) -eq 1 ];
        then
            func_vmdk_file=$find_file
        elif
            [ $(echo "$find_file" | wc -l) -gt 1 ];
        then
            IFS=$'\n'
            min=100000
            for file in $find_file
            do
                size=${#file}
                if [ $size -lt $min ];
                then
                    min=$size
                    func_vmdk_file="$file"
                fi
            done
        fi
        if [ -z "$func_vmdk_file" ];
        then
            echo "no candidate file found"
            exit 1
        fi
        vmdk_file=$func_vmdk_file
        
        
}

function remove_extension {
        #removes the extension from the file passed for directory creation and the new file naming
        local string="$1"
        file_name=${string::-4}
}

#checks if the name was passed as an arugment and if not prompts at run time
if [ "$1" != "" ]; then
	file=$1
else
	echo "enter file or directory name"
	read file
fi



#seperates the directory and filename for ease of use
dir_name=$(dirname "$file")
file_w_extension=$(basename "$file")

#checks for an argument for the output directory, if none, sets the current directory
if [ "$2" != "" ]; then
    output_dir=$2
else
    output_dir=$dir_name
fi

#checks if the passed object is a file or directory 
result="$(file "$file")"
if [[ $result == *"cannot open"* ]]
then
	echo "No file or directory found"
	exit 1
elif [[ $result == *"directory"* ]]
then 
	echo "directory entered, searching for VMDK"
	find_vmdk_file "$dir_name/$file_w_extension"
	file_name=$file_w_extension
#checks the last 3 characters for ova
elif [[ "${file_w_extension: -3}" == "ova" ]]
then
    remove_extension "$file_w_extension"
	extract_file "$file" "$file_name"
	find_vmdk_file "/tmp/$file_name"
else
    echo "No suitable file found"
    exit 1
fi

#adds a trailing slash on the output dir if none
if [[ "${output_dir: -1 }" != "/" ]]; then 
    output_dir="$output_dir/"
fi


echo "converting $file to $output_dir$file_name.qcow2"
{
qemu-img convert -O qcow2 "$vmdk_file" "$output_dir$file_name.qcow2"
} || {
echo "Disk convert failed, please ensure qemu-img is latest version and sufficient disk space"
}
if [[ $remove_flag == "1" ]];
then
    echo "removing temp directory"
    rm -rf "/tmp/$file_name"
fi
echo "done"
