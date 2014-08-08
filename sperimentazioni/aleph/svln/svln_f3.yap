#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('svln_f3').
:- induce.
:- write_rules('svln_f3.rul').

