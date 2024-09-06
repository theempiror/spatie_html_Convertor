#!/bin/bash


# Define the directory to search in
DIRECTORY=${1:-.}

((count=`grep -noRE "\!\! Form::label*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | wc -l`));

# Function to convert Html::label calls
convert_label_calls() {
    local file=$1

    # Convert calls with four parameters
    sed -i -E "s/\!\!\s*Form::label\s*\((\s*[^,]*\s*),(\s*.*\s*),(\s*\[\s*.*\s*\]\s*),(.*)\)\s*\!\!/{ html()\-\>label( \2, \1)->attributes( \3) }/g" "$file"
    
    # Convert calls with three parameters
    sed -i -E "s/\!\!\s*Form::label\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()\-\>label( \2, \1)->attributes( \3) }/g" "$file"
    
    # Convert calls with two parameters
    sed -i -E "s/\!\!\s*Form::label\s*\((\s*[^,]*\s*),(\s*.*\s*)\)\s*\!\!/{ html()\-\>label( \2, \1) }/g" "$file"
    
    # Convert calls with one parameter
    sed -i -E "s/\!\!\s*Form::label\s*\((.*)\)\s*\!\!/{ html()\-\>label( null, \1) }/g" "$file"
    
}
if [ $count -eq 0 ]; then

    ((lines=`grep -noRE 'Form::label\s*\(.*' "$DIRECTORY" | wc -l`));
    echo -e "\n -- $lines lines of code are undergoing conversion...\n";

    # Export the function to be used by find
    export -f convert_label_calls

    # Find all PHP files and apply the conversion function
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_label_calls "$0"' {} \;

    echo "Conversion completed."

else

    echo "Conversion not completed. Please convert the following calls manually and re-start the script: ";
    grep -noRE "\!\! Form::label*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" |cut -d":" -f1,2;

fi