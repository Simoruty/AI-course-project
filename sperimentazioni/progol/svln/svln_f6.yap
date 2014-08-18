#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('svln_f6').
:- induce.
:- write_rules('svln_f6.rul').

