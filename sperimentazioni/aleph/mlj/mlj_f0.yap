#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('mlj_f0').
:- induce.
:- write_rules('mlj_f0.rul').

