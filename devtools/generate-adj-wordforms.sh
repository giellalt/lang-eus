#!/bin/bash

# A short shell script to test word form generation for all continuation
# lexicons except the ones listed in the exception list.

# Path to $GIELLA_CORE - we don't use Autotools for these scripts:
if test -d "../giella-core" ; then
    giella_core="$(pwd)/../giella-core"
elif test "x$GTLANGS" != "x" -a -d "$GTLANGS/giella-core" ; then
    giella_core=$GTLANGS/giella-core
elif test "x$GIELLA_CORE" != "x" -a -d "$GIELLA_CORE" ; then
    giella_core=$GIELLA_CORE
elif test "x$GTCORE" != "x" -a -d "$GTCORE" ; then
    giella_core=$GTCORE
else	
    echo "ERROR: Neither of $$GIELLA_CORE, $$GTCORE or $$GTLANGS defined, and nothing found within the parent folder."
    exit 1
fi

######### USER Variables - change these to your liking: #########
# Codes for the word forms to be generated - list as many or few as needed:
morf_codes="+A+Sg+Abs 
            +A+Sg+Dat 
            +A+Sg+Ins 
            +A+Sg+Soc 
            +A+Sg+Erg 
            +A+Sg+Ine 
            +A+Sg+Ben 
            +A+Sg+Ben2 
            +A+Sg+Par 
            +A+Sg+All 
            +A+Sg+Ela 
            +A+Sg+Term 
            +A+Sg+Ten
            +A+Pl+Abs 
            +A+Pl+Dat 
            +A+Pl+Ins 
            +A+Pl+Soc 
            +A+Pl+Erg 
            +A+Pl+Ine 
            +A+Pl+Ben 
            +A+Pl+Ben2 
            +A+Pl+Par 
            +A+Pl+All 
            +A+Pl+Ela 
            +A+Pl+Term 
            +A+Pl+Ten
            +A+Comp+Sg+Abs
            +A+Superl+Sg+Abs
            +A+Egi+Sg+Abs"

# Lexicon source file for lexicons and lemmas:
source_file=src/fst/morphology/stems/adjectives.lexc

# Lexicons that should NOT be used to extract lemmas (egrep expression):
exception_lexicons="(flagK)"

# FST used for generation, MINUS suffix:
generator_file=src/fst/generator-gt-norm

# How many lemmas maximally for each lexicon:
lemmacount=10

# Specify path to the dir containing the script used for generation:
script_dir=$giella_core/scripts

################## DO NOT CHANGE BELOW HERE!!! ##################
"$script_dir/generate-wordforms-for-cont_lexes.sh" \
        "$giella_core" \
        "$morf_codes" \
        "$source_file" \
        "$generator_file" \
        "$lemmacount" \
        "$exception_lexicons"
