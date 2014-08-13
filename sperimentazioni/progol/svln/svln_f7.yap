#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('svln_f7').
:- induce.
:- write_rules('svln_f7.rul').

