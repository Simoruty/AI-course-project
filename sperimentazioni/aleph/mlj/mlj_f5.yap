#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('mlj_f5').
:- induce.
:- write_rules('mlj_f5.rul').

