#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('mlj_f2').
:- induce.
:- write_rules('mlj_f2.rul').

