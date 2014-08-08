#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('jmlr_f8').
:- induce.
:- write_rules('jmlr_f8.rul').

