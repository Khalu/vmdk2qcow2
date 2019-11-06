#!/bin/bash
#this script coverts ova and vmdk files to qcow2 disk images 

echo "Useage: ./vmdk2qcow2.sh /home/user/Virtual Machines/Target.ova"
remove_flag=0
function extract_file {
    #extracts the file passed in $1 to the directory passed in $2
    #also sets the remove_flag var for removal after convervsion
    echo "extracting to /tmp/$2"
	mkdir /tmp/"$2"
	tar xf "$1" --directory /tmp/"$2"
	$remove_flag=1
}

function find_vmdk_file {
        #attempts to find the VMDK file to convert
        find_file=$(find "$1" -name *.vmdk 2> /dev/null)
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

#checks if the passed object is a file or directory 
result="$(file "$file")"
if [[ $result == *"cannot open"* ]]
then
	echo "No file or directory found"
	exit 1
elif [[ $result == *"directory"* ]]
then
	#mkdir $file 
	echo "directory entered, searching for VMDK"
	find_vmdk_file "$dir_name/$file_w_extension"
	file_name=$file_w_extension
elif [[ "${file_w_extension#*.}" == "ova" ]]
then
    remove_extension "$file_w_extension"
	extract_file "$file" "$file_name"
	#vmdk_file=$(find_vmdk_file "/tmp/$file_name")
	find_vmdk_file "/tmp/$file_name"
else
    echo "No suitable file found"
    exit 1
fi



echo "converting $file to $dir_name/$file_name.qcow2"
qemu-img convert -O qcow2 "$vmdk_file" "$dir_name/$file_name.qcow2"
if [ $remove_flag == 1 ];
then
    echo "removing temp directory"
    rm -rf "/tmp/$file_name"
fi
echo "done"
