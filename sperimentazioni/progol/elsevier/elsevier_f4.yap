#!/usr/local/bin/yap -L --
#
# .
:- consult('../progol.pl').
:- read_all('elsevier_f4').
:- induce.
:- write_rules('elsevier_f4.rul').
