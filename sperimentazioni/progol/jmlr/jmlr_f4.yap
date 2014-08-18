#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('jmlr_f4').
:- induce.
:- write_rules('jmlr_f4.rul').

