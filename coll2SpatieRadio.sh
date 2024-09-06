#!/bin/bash


# Define the directory to search in
DIRECTORY=${1:-.}

((count=`grep -noRE "\!\! Form::radio*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | wc -l`));

# Function to convert Html::label calls
convert_radio_calls() {
    local file=$1

    # Convert calls with four parameters
    sed -i -E "s/\!\!\s*Form::radio\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>radio( \1, \3, \2)->attributes( \4) }/g" "$file"
    
    # Convert calls with three parameters
    sed -i -E "s/\!\!\s*Form::radio\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>radio( \1, \3, \2) }/g" "$file"

    # Convert calls with two parameters
    sed -i -E "s/\!\!\s*Form::radio\s*\((\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>radio( \1, null, \2) }/g" "$file"
    
    # Convert calls with one parameter
    sed -i -E "s/\!\!\s*Form::radio\s*\((.*)\)\s*\!\!/{ html()\-\>radio( \1) }/g" "$file"
}

if [ $count -eq 0 ]; then
    
    ((lines=`grep -noRE 'Form::radio\s*\(.*' "$DIRECTORY" | wc -l`));
    echo -e "\n -- $lines lines of code are undergoing conversion...\n";

    # Export the function to be used by find
    export -f convert_radio_calls

    # Find all PHP files and apply the conversion function
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_radio_calls "$0"' {} \;

    echo "Conversion completed."

else

    echo "Conversion not completed. Please convert the following calls manually and re-start the script: ";
    grep -noRE "\!\! Form::radio*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | cut -d":" -f1,2;

fi