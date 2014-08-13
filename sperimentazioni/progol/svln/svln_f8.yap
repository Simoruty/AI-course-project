#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('svln_f8').
:- induce.
:- write_rules('svln_f8.rul').

