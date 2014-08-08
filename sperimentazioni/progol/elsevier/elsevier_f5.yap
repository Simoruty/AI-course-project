#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('elsevier_f5').
:- induce.
:- write_rules('elsevier_f5.rul').

