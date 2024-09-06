#!/bin/bash


# Define the directory to search in

DIRECTORY=${1:-.}


echo -e "\n -- lines of code which should be modified\n";

((count=0)); for i in `grep -RhE "(Html|Form)::[a-zA-Z0-9_]*" $DIRECTORY | grep -v "{{--" | cut -d":" -f3 | cut -d"(" -f1 | sort | uniq`; do count=`grep -ERh "(Html|Form)::$i" $DIRECTORY | grep -v "{{--"| wc -l`;  echo "$count    ----    $i"; done | sort

((count=0)); for i in `grep -RhE "(Html|Form)::[a-zA-Z0-9_]*" $DIRECTORY | grep -v "{{--" | cut -d":" -f3 | cut -d"(" -f1 | sort | uniq`; do ((count=$count+`grep -ERh "(Html|Form)::$i" $DIRECTORY | grep -v "{{--" | wc -l`)); done;

echo -e "\n\n\tTotal lines = $count";

if [ $count -ne 0 ]; then

echo -e "\n -- coll2SpatieButton.sh is running...\n";
./coll2SpatieButton.sh "$DIRECTORY" | tee ButtonSummary.txt

echo -e "\n -- coll2SpatieCheckbox.sh is running...\n";
./coll2SpatieCheckbox.sh "$DIRECTORY" | tee CheckboxSummary.txt

echo -e "\n -- coll2SpatieEmail.sh is running...\n";
./coll2SpatieEmail.sh "$DIRECTORY" | tee EmailSummary.txt

echo -e "\n -- coll2spatieFavicon.sh is running...\n";
./coll2SpatieFavicon.sh "$DIRECTORY" | tee FaviconSummary.txt

echo -e "\n -- coll2spatieFile.sh is running...\n";
./coll2SpatieFile.sh "$DIRECTORY" | tee FileSummary.txt

echo -e "\n -- coll2SpatieForms.sh is running...\n";
./coll2SpatieForms.sh "$DIRECTORY" | tee FormsSummary.txt

echo -e "\n -- coll2SpatieHidden.sh is running...\n";
./coll2SpatieHidden.sh "$DIRECTORY" | tee HiddenSummary.txt

echo -e "\n -- coll2SpatieImage.sh is running...\n";
./coll2SpatieImage.sh "$DIRECTORY" | tee ImageSummary.txt

echo -e "\n -- coll2SpatieLabel.sh is running...\n";
./coll2SpatieLabel.sh "$DIRECTORY" | tee LabelSummary.txt

echo -e "\n -- coll2SpatieNumber.sh is running...\n";
./coll2SpatieNumber.sh "$DIRECTORY" | tee NumberSummary.txt

echo -e "\n -- coll2SpatiePassword.sh is running...\n";
./coll2SpatiePassword.sh "$DIRECTORY" | tee PasswordSummary.txt

echo -e "\n -- coll2SpatieRadio.sh is running...\n";
./coll2SpatieRadio.sh "$DIRECTORY" | tee RadioSummary.txt

echo -e "\n -- coll2SpatieScript.sh is running...\n";
./coll2SpatieScript.sh "$DIRECTORY" | tee ScriptSummary.txt

echo -e "\n -- coll2SpatieSelect.sh is running...\n";
./coll2SpatieSelect.sh "$DIRECTORY" | tee SelectSummary.txt

echo -e "\n -- coll2SpatieStyle.sh is running...\n";
./coll2SpatieStyle.sh "$DIRECTORY" | tee StyleSummary.txt

echo -e "\n -- coll2SpatieSubmit.sh is running...\n";
./coll2SpatieSubmit.sh "$DIRECTORY" | tee SubmitSummary.txt

echo -e "\n -- coll2SpatieTextArea.sh is running...\n";
./coll2SpatieTextArea.sh "$DIRECTORY" | tee TextAreaSummary.txt

echo -e "\n -- coll2SpatieText.sh is running...\n";
./coll2SpatieText.sh "$DIRECTORY" | tee TextSummary.txt

fi
