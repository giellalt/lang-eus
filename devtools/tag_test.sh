#shell script to see if there are tags which are not declared in root.lexc or if tags are misspelled

echo 'Possible tags not declared in root.lexc or misspelled:'
cat  src/fst/morphology/affixes/*lexc src/fst/morphology/stems/*lexc |cut -d '!' -f1 |grep ' ;' | cut -d ':' -f1 |rev |cut -d ' ' -f1 |rev |sed 's/+/¢+/g' |sed 's/@/¢@/g'|tr '¢' '\n' | tr '#"' '\n'| egrep '(\+|@[A-Z])' |sort -u | egrep -v '^(\+|\+%|\+\/\-|\+Cmp\-|\+Cmp%\-|\@0|\@%|\@%%)$' > lexctags

cat src/fst/morphology/root.lexc |cut -d '!' -f1 |cut -d ':' -f1 |sed 's/+/¢+/g'|sed 's/@/¢@/g' |tr '¢' '\n' | egrep '(\+|@)' |tr -d ' ' | tr -d '\t'|sort -u > roottags

comm -23 lexctags roottags  |grep -v '%/'

echo 'Checking for double + :'
cat src/fst/morphology/stems/*lexc src/fst/morphology/affixes/*lexc |cut -d '!' -f1 |grep '++'


echo 'Checking for double semicolon in stem files:'
cat src/fst/morphology/stems/*lexc |cut -d '!' -f1 |grep ';.*;'

echo 'Checking for missing Der-tags:'
cat src/fst/morphology/stems/*lexc |cut -d '!' -f1 |grep '\+Der/.*;' |egrep -v 'Der([1234]|\+)'

echo 'Checking for double Sem-tags:'
cat src/fst/morphology/stems/*lexc |cut -d '!' -f1 |grep '+Sem.*+Sem' 

echo 'Checking for whitespace without % on left side:'
cat src/fst/morphology/stems/*lexc |cut -d '!' -f1 | cut -d ';' -f1 | cut -d '"' -f1 | tr -s ' ' | grep -v '^ ' |sed 's/^ //' | grep -v '^<' |sed 's/% /%/g' |grep ' .*:' 

echo 'Checking for double :'
cat src/fst/morphology/stems/*lexc src/fst/morphology/affixes/*lexc |cut -d '!' -f1 |grep ':[^ %]*:' | grep -v '%:'

echo 'checked'
rm lexctags roottags
