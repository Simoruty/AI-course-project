#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('svln_f1').
:- induce.
:- write_rules('svln_f1.rul').

