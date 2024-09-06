#!/bin/bash


# Define the directory to search in
DIRECTORY=${1:-.}

((count=`grep -noRE "\!\! Form::password\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | wc -l`));

# Function to convert Html::label calls
convert_password_calls() {
    local file=$1

    # Convert calls with two parameters
    sed -i -E "s/\!\!\s*Form::password\s*\((\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>password( \1)->attributes( \2) }/g" "$file"
        
    # Convert calls with one parameter
    sed -i -E "s/\!\!\s*Form::password\s*\((.*)\)\s*\!\!/{ html()\-\>password( \1) }/g" "$file"
}

if [ $count -eq 0 ]; then

    ((lines=`grep -noRE 'Form::password\s*\(.*' "$DIRECTORY" | wc -l`));
    echo -e "\n -- $lines lines of code are undergoing conversion...\n";

    # Export the function to be used by find
    export -f convert_password_calls

    # Find all PHP files and apply the conversion function
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_password_calls "$0"' {} \;

    echo "Conversion completed."

else

    echo "Conversion not completed. Please convert the following calls manually and re-start the script: ";
    grep -noRE "\!\! Form::password*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | cut -d":" -f1,2;

fi