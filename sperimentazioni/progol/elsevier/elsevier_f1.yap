#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('elsevier_f1').
:- induce.
:- write_rules('elsevier_f1.rul').

