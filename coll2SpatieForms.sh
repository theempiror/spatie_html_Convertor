#!/bin/bash

##############################
# this code is not complated yet
##############################

# Define the directory to search in
DIRECTORY=${1:-.}

((count=`grep -noRE "\!\! Form::(model|open|close)*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | wc -l`));

# Function to convert Html::label calls
convert_formClose_calls() {
    local file=$1
    
    # Convert calls with one parameter
    sed -E -i "s/'files'=>true/'enctype'=>'multipart\/form-data'/g" "$file"
    sed -E -i "s/(\{\s*\!\!\s*Form::model\s*\(([^,]*),(.*)\)\s*\!\!\s*\})/{{-- \1 --}}\n\t\t\t{{ html()->modelForm( \2, method, action)->attributes( \3)->open() }}/g" "$file"
    sed -E -i "s/(\{\s*\!\!\s*Form::open\s*\((.*\))\s*\!\!\s*\})/{{-- \1 --}}\n\t\t\t{{ html()->form()->attributes( \2)->open() }}/g" "$file"
    sed -i -E "s/\!\!\s*Form::close\s*\(\s*\)\s*\!\!/{ html()->form()->close() }/g" "$file"
    
}
if [ $count -eq 0 ]; then

    ((lines=`grep -noRE 'Form::(model|open)\s*\(.*' "$DIRECTORY" | wc -l`));
    echo -e "\n -- $lines lines of code are undergoing conversion...\n";

    # Export the function to be used by find
    export -f convert_formClose_calls

    # Find all PHP files and apply the conversion function
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_formClose_calls "$0"' {} \;

    echo "Conversion not completed. Please convert the following calls manually :\n";
    grep -noRE "\!\! Form::(model|open|close)" "$DIRECTORY" |cut -d":" -f1,2;
    # echo "Conversion completed."

else

    echo "Conversion not completed. Please convert the following calls manually and re-start the script: ";
    grep -noRE "\!\! Form::(model|open|close)*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" |cut -d":" -f1,2;

fi