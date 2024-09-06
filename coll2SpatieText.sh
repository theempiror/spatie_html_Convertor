#!/bin/bash


# Define the directory to search in
DIRECTORY=${1:-.}

((count=`grep -noRE "\!\! Form::text\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | wc -l`));

# Function to convert Html::label calls
convert_text_calls() {
    local file=$1

    # Convert calls with three parameters
    sed -i -E "s/\!\!\s*Form::text\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>text( \1, \2)->attributes( \3) }/g" "$file"

    # Convert calls with two parameters
    sed -i -E "s/\!\!\s*Form::text\s*\((\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>text( \1, \2) }/g" "$file"
        
    # Convert calls with one parameter
    sed -i -E "s/\!\!\s*Form::text\s*\((.*)\)\s*\!\!/{ html()\-\>text( \1) }/g" "$file"
}

if [ $count -eq 0 ]; then

    ((lines=`grep -noRE 'Form::text\s*\(.*' "$DIRECTORY" | wc -l`));
    echo -e "\n -- $lines lines of code are undergoing conversion...\n";
    
    # Export the function to be used by find
    export -f convert_text_calls

    # Find all PHP files and apply the conversion function
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_text_calls "$0"' {} \;

    echo "Conversion completed."

else

    echo "Conversion not completed. Please convert the following calls manually and re-start the script: ";
    grep -noRE "\!\! Form::text*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | cut -d":" -f1,2;

fi