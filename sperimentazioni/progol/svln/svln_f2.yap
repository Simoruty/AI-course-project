#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('svln_f2').
:- induce.
:- write_rules('svln_f2.rul').

