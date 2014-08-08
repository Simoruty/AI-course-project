#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('svln_f0').
:- induce.
:- write_rules('svln_f0.rul').

