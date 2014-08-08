#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('elsevier_f0').
:- induce.
:- write_rules('elsevier_f0.rul').

