#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('jmlr_f1').
:- induce.
:- write_rules('jmlr_f1.rul').

