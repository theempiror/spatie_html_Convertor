#!/bin/bash


# Define the directory to search in
DIRECTORY=${1:-.}

((count=`grep -noRE "\!\! Form::select*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | wc -l`));

# Function to convert Html::label calls
convert_select_calls() {
    local file=$1

    ##############################
    # this code is not complated yet
    ##############################


    
    # Convert calls with six parameters
    # sed -i -E "s/\!\!\s*Form::select\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(\s*[^,]*\s*),(\s*\[.*\]\s*),(\s*\[.*\]\s*),(.*)\)\s*\!\!/{ html()\-\>select( \1, \2, \3)->attributes( \4) }/g" "$file"
    
    # Convert calls with five parameters
    # sed -i -E "s/\!\!\s*Form::select\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(\s*[^,]*\s*),(\s*\[.*\]\s*),(.*)\)\s*\!\!/{ html()\-\>select( \1, \2, \3)->attributes( \4) }/g" "$file"
    
    # Convert calls with four parameters
    sed -i -E "s/\!\!\s*Form::select\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>select( \1, \2, \3)->attributes( \4) }/g" "$file"
    
    # Convert calls with three parameters
    sed -i -E "s/\!\!\s*Form::select\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>select( \1, \2, \3) }/g" "$file"

    # Convert calls with two parameters
    sed -i -E "s/\!\!\s*Form::select\s*\((\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>select( \1, \2) }/g" "$file"
    
    # Convert calls with one parameter
    sed -i -E "s/\!\!\s*Form::select\s*\((.*)\)\s*\!\!/{ html()\-\>select( \1) }/g" "$file"
}

if [ $count -eq 0 ]; then
    
    ((lines=`grep -noRE 'Form::select\s*\(.*' "$DIRECTORY" | wc -l`));
    echo -e "\n -- $lines lines of code are undergoing conversion...\n";

    # Export the function to be used by find
    export -f convert_select_calls

    # Find all PHP files and apply the conversion function
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_select_calls "$0"' {} \;

    echo "Conversion completed."

else

    echo "Conversion not completed. Please convert the following calls manually and re-start the script: ";
    grep -noRE "\!\! Form::select*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | cut -d":" -f1,2;

fi