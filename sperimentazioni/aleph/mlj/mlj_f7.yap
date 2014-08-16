#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('mlj_f7').
:- induce.
:- write_rules('mlj_f7.rul').

