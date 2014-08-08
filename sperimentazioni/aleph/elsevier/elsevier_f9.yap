#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('elsevier_f9').
:- induce.
:- write_rules('elsevier_f9.rul').

