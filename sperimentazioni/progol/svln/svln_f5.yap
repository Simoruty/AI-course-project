#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('svln_f5').
:- induce.
:- write_rules('svln_f5.rul').

