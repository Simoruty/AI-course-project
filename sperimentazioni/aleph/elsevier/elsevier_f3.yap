#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('elsevier_f3').
:- induce.
:- write_rules('elsevier_f3.rul').

