#!/bin/bash


# Define the directory to search in
DIRECTORY=${1:-.}

((count=`grep -noRE "\!\! Html::script*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | wc -l`));

# Function to convert Html::label calls
convert_script_calls() {
    local file=$1

    # Convert calls with three parameters
    sed -i -E "s/\!\!\s*Html::script\s*\((\s*[^,]*\s*),(\s*\[.*\]*\s*),(.*)\)\s*\!\!/{ html()->element( 'script')->attribute( 'src', asset( \1, \3))->attributes( \2) }/g" "$file"

    # Convert calls with two parameters
    sed -i -E "s/\!\!\s*Html::script\s*\((\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()->element( 'script')->attribute( 'src', asset( \1, null))->attributes( \2) }/g" "$file"
        
    # Convert calls with one parameter
    sed -i -E "s/\!\!\s*Html::script\s*\((.*)\)\s*\!\!/{ html()->element( 'script')->attribute( 'src', asset( \1, null)) }/g" "$file"
}

if [ $count -eq 0 ]; then

    ((lines=`grep -noRE 'Html::script\s*\(.*' "$DIRECTORY" | wc -l`));
    echo -e "\n -- $lines lines of code are undergoing conversion...\n";

    # Export the function to be used by find
    export -f convert_script_calls

    # Find all PHP files and apply the conversion function
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_script_calls "$0"' {} \;

    echo "Conversion completed."

else

    echo "Conversion not completed. Please convert the following calls manually and re-start the script: ";
    grep -noRE "\!\! Html::script*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | cut -d":" -f1,2;

fi