#!/bin/bash



##############################
# this code is not complated yet
##############################


# Define the directory to search in
DIRECTORY=${1:-.}

((count=`grep -noRE "\!\! (Form|Html)::image*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | wc -l`));

# Function to convert Html::label calls
convert_formImg_calls() {
    local file=$1

    # Convert calls with three parameters
    sed -i -E "s/\!\!\s*Form::image\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()->input( 'image', \2, null)->attribute( 'src', asset( \1, null))->attributes( \3) }/g" "$file"

    # Convert calls with two parameters
    sed -i -E "s/\!\!\s*Form::image\s*\((\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()->input( 'image', \2, null)->attribute( 'src', asset( \1, null)) }/g" "$file"
        
    # Convert calls with one parameter
    sed -i -E "s/\!\!\s*Form::image\s*\((.*)\)\s*\!\!/{ html()->input( 'image', null, null)->attribute( 'src', asset( \1, null)) }/g" "$file"
}

convert_htmlImg_calls() {
    local file=$1

    # Convert calls with four parameters
    sed -i -E "s/\!\!\s*Html::image\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(\s*\[.*\]\s*),(.*)\)\s*\!\!/{ html()->img( asset( \1, \4), \2)->attributes( \3) }/g" "$file"
    
    # Convert calls with three parameters
    sed -i -E "s/\!\!\s*Html::image\s*\((\s*[^,]*\s*),(\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()->img( asset( \1, null), \2)->attributes( \3) }/g" "$file"

    # Convert calls with two parameters
    sed -i -E "s/\!\!\s*Html::image\s*\((\s*[^,]*\s*),(.*)\)\s*\!\!/{ html()->img( asset( \1, null), \2) }/g" "$file"
        
    # Convert calls with one parameter
    sed -i -E "s/\!\!\s*Html::image\s*\((.*)\)\s*\!\!/{ html()->img( asset( \1, null), null) }/g" "$file"
}

if [ $count -eq 0 ]; then

    ((lines=`grep -noRE '(Form|Html)::image\s*\(.*' "$DIRECTORY" | grep -vE "\!\! (Form|Html)::image*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" | wc -l`));
    echo -e "\n -- $lines lines of code are undergoing conversion...\n";
    
    # Export the functions to be used by find
    export -f convert_formImg_calls
    export -f convert_htmlImg_calls

    # Find all PHP files and apply the conversion functions
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_formImg_calls "$0"' {} \;
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'convert_htmlImg_calls "$0"' {} \;

    echo "Conversion completed."

else

    # find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'sed -E "s/(\{\s*\!\! Form::image*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!\s*\})/\1\n<-- try to convert the line of code befor to this {{ html()->input( 'image', 'parameter2', null)->attribute( 'src', asset( 'parameter1', null))->attributes( 'parameter3') }} -->/g" "$0"' {} \;
    
    find "$DIRECTORY" -name "*.blade.php" -exec bash -c 'sed -i -E "s/(\{\s*\!\! Html::image*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!\s*\})/\1\n\t{{-- try to convert the line of code befor to this {{ html()->img( asset( parameter1, parameter4), parameter2)->attributes( parameter3) }} --}}/g" "$0"' {} \;    
    
    echo "Conversion not completed. Please convert the following calls manually and re-start the script: ";
    
    grep -noRE "\!\! (Form|Html)::image*\s*\(.*\([^\)]*[,]+[^\)]*\).*\) \!\!" "$DIRECTORY" | cut -d":" -f1,2;
    
fi
