#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('jmlr_f2').
:- induce.
:- write_rules('jmlr_f2.rul').

