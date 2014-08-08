#!/usr/local/bin/yap -L --
#
# .
:- consult('../aleph.pl').
:- read_all('jmlr_f7').
:- induce.
:- write_rules('jmlr_f7.rul').

