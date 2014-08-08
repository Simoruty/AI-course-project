#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('jmlr_f0').
:- induce.
:- write_rules('jmlr_f0.rul').

