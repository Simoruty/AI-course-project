#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('mlj_f1').
:- induce.
:- write_rules('mlj_f1.rul').

