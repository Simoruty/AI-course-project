#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('jmlr_f6').
:- induce.
:- write_rules('jmlr_f6.rul').

