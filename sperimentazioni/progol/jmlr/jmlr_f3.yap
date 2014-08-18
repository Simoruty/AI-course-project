#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('jmlr_f3').
:- induce.
:- write_rules('jmlr_f3.rul').

