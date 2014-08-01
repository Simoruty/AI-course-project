#!/usr/local/bin/yap -L --
#
# .

:- consult('aleph.pl').
%:- consult('elsevier.b').
:- read_all('elsevier').
:- induce.
:- write_rules.

%:- initialization(main).
