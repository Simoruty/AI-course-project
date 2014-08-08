#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('jmlr_f5').
:- induce.
:- write_rules('jmlr_f5.rul').

