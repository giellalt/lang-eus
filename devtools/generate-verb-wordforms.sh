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
morf_codes="+V+Inf \
            +V+Abs/Sg1+Ind+Prt \
            +V+Abs/Sg2+ifl+Ind+Prt \
            +V+Abs/Sg2+Ind+Prt \
            +V+Abs/Sg3+Ind+Prt \
            +V+Abs/Pl1+Ind+Prt \
            +V+Abs/Pl2+Ind+Prt \
            +V+Abs/Pl3+Ind+Prt \
            +V+Abs/Sg1+Ind+Prt \
            +V+Abs/Sg2+ifl+Ind+Prt \
            +V+Abs/Sg2+Ind+Prt \
            +V+Abs/Sg3+Ind+Prt \
            +V+Abs/Pl1+Ind+Prt \
            +V+Abs/Pl2+Ind+Prt \
            +V+Abs/Pl3+Ind+Prt \
            +V+Ind+Prs+Abs/Sg1 \
            +V+Ind+Prs+Abs/Sg2+ifl \
            +V+Ind+Prs+Abs/Sg2 \
            +V+Ind+Prs+Abs/Sg3 \
            +V+Ind+Prs+Abs/Pl1 \
            +V+Ind+Prs+Abs/Pl2 \
            +V+Ind+Prs+Abs/Pl3 \
            +V+Subj+Prs+Abs/Sg1 \
            +V+Subj+Prs+Abs/Sg2+ifl \
            +V+Subj+Prs+Abs/Sg2 \
            +V+Subj+Prs+Abs/Sg3 \
            +V+Subj+Prs+Abs/Pl1 \
            +V+Subj+Prs+Abs/Pl2 \
            +V+Subj+Prs+Abs/Pl3 \
            +V+Abs/Sg1+Condfin+Prs \
            +V+Abs/Sg2+ifl+Condfin+Prs \
            +V+Abs/Sg2+Condfin+Prs \
            +V+Abs/Sg3+Condfin+Prs \
            +V+Abs/Pl1+Condfin+Prs \
            +V+Abs/Pl2+Condfin+Prs \
            +V+Abs/Pl3+Condfin+Prs \
            +V+Abs/Sg1+Condfin+Prt \
            +V+Abs/Sg2+ifl+Condfin+Prt \
            +V+Abs/Sg2+Condfin+Prt \
            +V+Abs/Sg3+Condfin+Prt \
            +V+Abs/Pl1+Condfin+Prt \
            +V+Abs/Pl2+Condfin+Prt \
            +V+Abs/Pl3+Condfin+Prt \
            +V+Abs/Sg1+Pot+Hip \
            +V+Abs/Sg2+ifl+Pot+Hip \
            +V+Abs/Sg2+Pot+Hip \
            +V+Abs/Sg3+Pot+Hip \
            +V+Abs/Pl1+Pot+Hip \
            +V+Abs/Pl2+Pot+Hip \
            +V+Abs/Pl3+Pot+Hip \
            +V+Pot+Prs+Abs/Sg1 \
            +V+Pot+Prs+Abs/Sg2+ifl \
            +V+Pot+Prs+Abs/Sg2 \
            +V+Pot+Prs+Abs/Sg3 \
            +V+Pot+Prs+Abs/Pl1 \
            +V+Pot+Prs+Abs/Pl2 \
            +V+Pot+Prs+Abs/Pl3 \
            +V+Abs/Sg1+Pot+Prt \
            +V+Abs/Sg2+ifl+Pot+Prt \
            +V+Abs/Sg2+Pot+Prt \
            +V+Abs/Sg3+Pot+Prt \
            +V+Abs/Pl1+Pot+Prt \
            +V+Abs/Pl2+Pot+Prt \
            +V+Abs/Pl3+Pot+Prt \
            +V+Ind+Prt+Abs/Sg1+Dat/Sg1 \
            +V+Ind+Prt+Abs/Sg2+ifl/m+Dat/Sg1 \
            +V+Ind+Prt+Abs/Sg2+ifl/f+Dat/Sg1 \
            +V+Ind+Prt+Abs/Sg2+Dat/Sg1 \
            +V+Ind+Prt+Abs/Sg3+Dat/Sg1 \
            +V+Ind+Prt+Abs/Pl1+Dat/Sg1 \
            +V+Ind+Prt+Abs/Pl2+Dat/Sg1 \
            +V+Ind+Prt+Abs/Pl3+Dat/Sg1 \
            +V+Ind+Prt+Abs/Sg1+Dat/Sg2+ifl/m \
            +V+Ind+Prt+Abs/Sg2+ifl/m+Dat/Sg2+ifl/m \
            +V+Ind+Prt+Abs/Sg2+ifl/f+Dat/Sg2+ifl/m \
            +V+Ind+Prt+Abs/Sg2+Dat/Sg2+ifl/m \
            +V+Ind+Prt+Abs/Sg3+Dat/Sg2+ifl/m \
            +V+Ind+Prt+Abs/Pl1+Dat/Sg2+ifl/m \
            +V+Ind+Prt+Abs/Pl2+Dat/Sg2+ifl/m \
            +V+Ind+Prt+Abs/Pl3+Dat/Sg2+ifl/m \
            +V+Ind+Prt+Abs/Sg1+Dat/Sg3 \
            +V+Ind+Prt+Abs/Sg2+ifl/f+Dat/Sg3 \
            +V+Ind+Prt+Abs/Sg2+ifl/f+Dat/Sg3 \
            +V+Ind+Prt+Abs/Sg2+Dat/Sg3 \
            +V+Ind+Prt+Abs/Sg3+Dat/Sg3 \
            +V+Ind+Prt+Abs/Pl1+Dat/Sg3 \
            +V+Ind+Prt+Abs/Pl2+Dat/Sg3 \
            +V+Ind+Prt+Abs/Pl3+Dat/Sg3 \
            +V+Fut \
            +V+Ptc \
            +V+Inf"

# Lexicon source file for lexicons and lemmas:
source_file=src/fst/morphology/stems/verbs.lexc

# Lexicons that should NOT be used to extract lemmas (egrep expression):
exception_lexicons="(Aux)"

# FST used for generation, MINUS suffix:
generator_file=src/fst/generator-gt-norm

# How many lemmas maximally for each lexicon:
lemmacount=100

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
