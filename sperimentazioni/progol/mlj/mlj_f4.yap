#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('mlj_f4').
:- induce.
:- write_rules('mlj_f4.rul').

