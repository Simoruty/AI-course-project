#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('mlj_f8').
:- induce.
:- write_rules('mlj_f8.rul').

