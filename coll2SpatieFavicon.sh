#!/bin/bash


# Define the directory to search in
DIRECTORY=${1:-.}

((count=`grep -noRE "\!\! Html::favicon*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | wc -l`));

# Function to convert Html::label calls
convert_favicon_calls() {
    local file=$1

    # Convert calls with three parameters
    sed -i -E "s/\!\!\s*Html::favicon\s*\((\s*[^,]*\s*),(\s*\[.*\]*\s*),(.*)\)\s*\!\!/{ html()->element( 'link')->attribute( 'href', asset( \1, \3))->attributes( array_merge( \2, ['rel' => 'shortcut icon', 'type' => 'image\/x-icon']))->open() }/g" "$file"

    # Convert calls with two parameters
    sed -i -E "s/\!\!\s*Html::favicon\s*\((\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()->element( 'link')->attribute( 'href', asset( \1, null))->attributes( array_merge( \2, ['rel' => 'shortcut icon', 'type' => 'image\/x-icon']))->open() }/g" "$file"
        
    # Convert calls with one parameter
    sed -i -E "s/\!\!\s*Html::favicon\s*\((.*)\)\s*\!\!/{ html()->element( 'link')->attribute( 'href', asset( \1, null))->attributes( ['rel' => 'shortcut icon', 'type' => 'image\/x-icon'])->open() }/g" "$file"
}

if [ $count -eq 0 ]; then

    ((lines=`grep -noRE 'Html::favicon\s*\(.*' "$DIRECTORY" | wc -l`));
    echo -e "\n -- $lines lines of code are undergoing conversion...\n";

    # Export the function to be used by find
    export -f convert_favicon_calls

    # Find all PHP files and apply the conversion function
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_favicon_calls "$0"' {} \;

    echo "Conversion completed."

else

    echo -e "Conversion not completed. Please convert the following calls manually and re-start the script and try again: \n";
    grep -noRE "\!\! Html::favicon*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | cut -d":" -f1,2;

fi