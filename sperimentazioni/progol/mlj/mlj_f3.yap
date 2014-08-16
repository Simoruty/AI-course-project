#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('mlj_f3').
:- induce.
:- write_rules('mlj_f3.rul').

