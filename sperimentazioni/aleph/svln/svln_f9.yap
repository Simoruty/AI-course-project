#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('svln_f9').
:- induce.
:- write_rules('svln_f9.rul').

