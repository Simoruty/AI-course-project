#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('jmlr_f9').
:- induce.
:- write_rules('jmlr_f9.rul').

