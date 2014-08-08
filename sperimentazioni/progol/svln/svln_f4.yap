#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('svln_f4').
:- induce.
:- write_rules('svln_f4.rul').

