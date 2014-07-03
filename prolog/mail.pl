:- module( mail, [tag_mail/2] ).

:- use_module(lexer).


dominio('com').
dominio('it').
dominio('net').
dominio('org').
dominio('co').
dominio('uk').
dominio('tv').
dominio('ac').
dominio('jp').
dominio('fr').
dominio('de').
dominio('us').

tag_mail([],[]).
tag_mail([A],[A]).
tag_mail([A,B],[A,B]).
tag_mail([A,B,C],[A,B,C]).
tag_mail([A,B,C,D],[A,B,C,D]).

tag_mail([A,B,C,D,E,F,G,H,I|Xs],[mail(Mail)|Ys]) :-
    check_mail(A,B,C,D,E,F,G,H,I),
    !,
    atomic_list_concat([A,B,C,D,E,F,G,H,I], '', Mail),
    tag_mail(Xs, Ys).

tag_mail([A,B,C,D,E,F,G|Xs],[mail(Mail)|Ys]) :-
    check_mail(A,B,C,D,E,F,G),
    !,
    atomic_list_concat([A,B,C,D,E,F,G], '', Mail),
    tag_mail(Xs, Ys).

tag_mail([A,B,C,D,E|Xs],[mail(Mail)|Ys]) :-
    check_mail(A,B,C,D,E),
    !,
    atomic_list_concat([A,B,C,D,E], '', Mail),
    tag_mail(Xs, Ys).



tag_mail([A,B,C,D,E|Xs],[A|Ys]) :-
    tag_mail([B,C,D,E|Xs], Ys).


% nome@mail.it
check_mail(A,B,C,D,E) :-
    atom(A),
    chiocciola(B),
    atom(C),
    punto(D),
    dominio(E).

% nome.cognome@mail.it
check_mail(A,B,C,D,E,F,G) :-
    atom(A),
    punto(B),
    atom(C),
    chiocciola(D),
    atom(E),
    punto(F),
    dominio(G).

% prova@dominio.co.uk
check_mail(A,B,C,D,E,F,G) :-
    atom(A),
    chiocciola(B),
    atom(C),
    punto(D),
    dominio(E),
    punto(F),
    dominio(G).

% nome.cognome@dominio.co.uk
check_mail(A,B,C,D,E,F,G,H,I) :-
    atom(A),
    punto(B),
    atom(C),
    chiocciola(D),
    atom(E),
    punto(F),
    dominio(G),
    punto(H),
    dominio(I).
