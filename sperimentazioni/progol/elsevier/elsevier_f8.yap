#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('elsevier_f8').
:- induce.
:- write_rules('elsevier_f8.rul').

