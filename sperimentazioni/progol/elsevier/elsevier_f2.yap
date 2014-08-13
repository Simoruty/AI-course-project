#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('elsevier_f2').
:- induce.
:- write_rules('elsevier_f2.rul').

