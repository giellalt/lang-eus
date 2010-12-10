# *************************************************************** #
# This is a makefile that builds the Faroese morphological parser #
# *************************************************************** #

XFST = xfst
LEXC = lexc
TWOLC = twolc

ifeq (victorio.uit.no, $(shell hostname))
XFST = /opt/sami/xerox/c-fsm/ix86-linux2.6-gcc3.4/bin/fst -utf8
LEXC = /opt/sami/xerox/bin/lexc -utf8
TWOLC = /opt/sami/xerox/bin/twolc -utf8
endif

scripts=$(GTHOME)/gt/script

LEX = eus-lex.txt #\
#	  noun-eus-lex.txt \
#	  noun-eus-morph.txt \
#	  propernoun-eus-lex.txt \
#	  propernoun-eus-morph.txt \
#	  adj-eus-lex.txt \
#	  adj-eus-morph.txt \
#	  verb-eus-lex.txt \
#	  verb-eus-morph.txt \
#	  adv-eus-lex.txt \
#	  abbr-eus-lex.txt \
#	  acro-eus-lex.txt \
#	  pron-eus-lex.txt \
#	  punct-eus-lex.txt \
#	  numeral-eus-lex.txt \
#	  pp-eus-lex.txt \
#	  cc-eus-lex.txt \
#	  cs-eus-lex.txt \
#	  interj-eus-lex.txt \
#	  det-eus-lex.txt

all: ieus.fst

# The ultimate goal is to build ieus.fst, the generator
# This goal depends on eus.save being up to date.

ieus.fst: ../bin/ieus.fst
../bin/ieus.fst: ../bin/eus.save \
				 ../bin/eus.fst \
				 ../bin/tok.fst \
				 ../bin/abbr.txt \
            	 ../bin/allcaps.fst #\
#            	 ../bin/eus-dis.bin \
#            	 ../bin/eus-dep.bin 

	@echo
	@echo "*** Building the inverse ieus.fst ***"
	@echo
	@printf "load $< \n\
	invert net \n\
	save stack $@ \n\
	quit \n" > ../tmp/ieus-fst-script
	$(XFST)  < ../tmp/ieus-fst-script
	@rm -f ../tmp/ieus-fst-script


# The first goal is to build eus.fst, the analyzer.
# This goal depends on eus.save and inituppercase.fst being up to date
eus.fst: ../bin/eus.fst
../bin/eus.fst: ../bin/eus.save \
				../bin/inituppercase.fst \
				../bin/allcaps.fst \
				../bin/tok.fst 

	@echo
	@echo "*** Building eus.fst ***" ;
	@echo
	@printf "read regex @\"../bin/eus.save\" \
					.o. @\"../bin/inituppercase.fst\" ; \n\
	save stack $@ \n\
	quit \n" > ../tmp/eus-fst-script
	$(XFST)  < ../tmp/eus-fst-script
	@rm -f ../tmp/eus-fst-script


# Here we make the abbrevation file for our current preprocessor, 
# the perl-based preprocess (located in the script catalogue)
empty:=
comma:=,
space:=$(empty) $(empty)
ABBRSRCS=$(subst $(space),$(comma),$(LEX))

abbr: ../bin/abbr.txt
../bin/abbr.txt: $(scripts)/abbr-extract.pl \
				 $(scripts)/langTools/Util.pm \
				 $(LEX)
	@echo
	@echo "*** Extracting abbreviations from abbr-eus-lex.txt to abbr.txt ***" ;
	@echo
	@perl -I $(scripts) $(scripts)/abbr-extract.pl \
		--output=$@ \
		--abbr_lex=abbr-eus-lex.txt \
		--lex=$(ABBRSRCS)


allcaps.fst: ../bin/allcaps.fst
../bin/allcaps.fst: allcaps.xfst
	@echo
	@echo "*** Building $(notdir $@) ***" ;
	@echo
	$(XFST) -e "source < $< " \
			-e "save stack   $@ " \
			-stop


inituppercase.fst: ../bin/inituppercase.fst
../bin/inituppercase.fst: inituppercase.regex
	@echo
	@echo "*** Building $(notdir $@) ***" ;
	@echo
	$(XFST) -e "read regex < $< " \
			-e "save stack   $@ " \
			-stop


# The third goal is to build eus.save
# This goal depends on twol-eus.bin and a bunch of lexicon files
eus.save: ../bin/eus.save
../bin/eus.save: ../bin/twol-eus.bin $(LEX)
	@echo
	@echo "*** Building eus-lex.save ***" ;
	@echo
	printf "compile-source $(LEX)  \n\
	read-rules $< \n\
	compose-result \n\
	save-result $@ \n\
	quit \n" > ../tmp/eus-lex-save-script
	$(LEXC)  < ../tmp/eus-lex-save-script
	rm -f ../tmp/eus-lex-save-script


# The fourth goal is to build twol-eus.bin
# This goal depends on twol-eus.txt
twol-eus.bin: ../bin/twol-eus.bin
../bin/twol-eus.bin: twol-eus.txt
	@echo
	@echo "*** Building twol-eus.bin ***" ;
	@echo
	@printf "read-grammar twol-eus.txt \n\
	compile \n\
	save-binary ../bin/twol-eus.bin \n\
	quit \n" > ../tmp/twol-eus-script
	$(TWOLC)  < ../tmp/twol-eus-script
	@rm -f ../tmp/twol-eus-script

# Here we include a preprocessor.
# This goal depends on tok.regex
tok.fst: ../bin/tok.fst 
../bin/tok.fst: tok.xfst
	@echo
	@echo "*** Building the tokenizer $(notdir $@) ***" ;
	@echo
	@printf "source $< \n\
	save stack $@ \n\
	quit \n" > ../tmp/tok-script
	$(XFST)  < ../tmp/tok-script
	@rm -f ../tmp/tok-script

### # Let us just make a binary disambiguator
### # and dependency grammar.
### # They can be used instead of the source files.
### dis-bin: ../bin/eus-dis.bin
### ../bin/%.bin: %.rle
### 	@echo
### 	@echo "*** Building a binary $(notdir $@) ***" ;
### 	@echo
### 	@vislcg3 --grammar $< \
### 			 --grammar-only \
### 			 --grammar-bin $@ \
### 			 -C UTF-8

# "make clean" is there to remove the binary files at will.
clean:
	@rm -f ../bin/*
