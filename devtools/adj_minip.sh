#!/bin/bash

# script to generate paradigms for generating word forms
# command, when you are in eus:
# sh devtools/verb_minip.sh IZANNOR | less
# sh devtools/verb_minip.sh izan 


HLOOKUP=$(echo $HLOOKUP)
GTLANGS=$(echo $GTLANGS)


PATTERN=$1
L_FILE="in.txt"
cut -d '!' -f1 src/fst/morphology/stems/adjectives.lexc | egrep $PATTERN | tr " " ":" | cut -d ':' -f1>$L_FILE

#P_FILE="test/data/testauxparadigm.txt"
P_FILE="test/data/testadjparadigm.txt"

for lemma in $(cat $L_FILE);
do
 for form in $(cat $P_FILE);
 do
   echo "${lemma}${form}" | $HLOOKUP $GTLANGS/lang-eus/src/fst/generator-gt-norm.hfstol
 done
 rm -f $L_FILE
done

