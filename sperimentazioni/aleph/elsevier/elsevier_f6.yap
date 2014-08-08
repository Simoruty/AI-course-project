#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('elsevier_f6').
:- induce.
:- write_rules('elsevier_f6.rul').

