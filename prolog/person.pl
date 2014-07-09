:- module( person, [  person/2
                    , titolo/2
                   ] 
).

:- consult('person_kb.pl').

sottoscritto('sottoscritto').
sottoscritto('sottoscritta').
commissario('commissario').
giudice('giudice').
curatore('curatore').
dottore('dott').
dottore('dottor').
dottore('dottore').
dottore('dottoressa').
avvocato('avv').
avvocato('avvocato').

check_ruolo(A, sottoscritto) :- sottoscritto(A), !.
check_ruolo(A, commissario) :- commissario(A), !.
check_ruolo(A, giudice) :- giudice(A), !.
check_ruolo(A, curatore) :- curatore(A), !.
check_ruolo(A, dottore) :- dottore(A), !.
check_ruolo(A, avvocato) :- avvocato(A), !.

check_ruolo(A,B, D) :-
    atom(A),
    atom(B),
    check_ruolo(A, D),
    punto(B).

check_ruolo(A,B,C, D) :-
    atom(A),
    atom(B),
    atom(C),
    check_ruolo(A, D),
    punto(B),
    suffix(C).

aggettivo('gentilissima').
aggettivo('gentilissime').
aggettivo('gentilissimo').
aggettivo('gentilissimi').
aggettivo('illustrissimo').
aggettivo('illustrissimi').
aggettivo('illustrissima').
aggettivo('illustrissime').
aggettivo('spettabile').
aggettivo('chiarissimo').
aggettivo(A,B,C) :-
    atom(A),
    atom(B),
    atom(C),
    prefix(A),
    punto(B),
    suffix(C).
    
prefix('gent').
prefix('ill').
prefix('spett').
prefix('stim').
prefix('egr'). 
prefix('chia').
prefix('amn').

suffix('le').
suffix('ma').
suffix('me').
suffix('mi').
suffix('mo').
suffix('ssa').
suffix('to').
suffix('a').



punto('.').

person(X) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken1,IDToken2),

tag_persona(List,ListTagged) :-
    tag_aggettivo(List,A),
    tag_ruolo(A,B),
    strip_aggettivi(B,C),
    tag_nome(C,D),
    tag_titolo(D,ListTagged).


tag_aggettivo([], []).
tag_aggettivo( [A,B,C|Xs], [aggettivo|Ys] ) :-
    aggettivo(A,B,C),
    !,
	tag_aggettivo(Xs,Ys).
tag_aggettivo([A|Xs], [aggettivo|Ys]) :-
    aggettivo(A),
    !,
    tag_aggettivo(Xs, Ys).
tag_aggettivo([A|Xs], [A|Ys]) :-
    tag_aggettivo(Xs, Ys).



strip_aggettivi([],[]).
strip_aggettivi([aggettivo,aggettivo|Xs], Ys):-
	!,
	strip_aggettivi([aggettivo|Xs],Ys).
strip_aggettivi([X|Xs],[X|Ys]) :-
	strip_aggettivi(Xs,Ys).


tag_ruolo([], []).
tag_ruolo( [A,B,C|Xs], [ruolo(R)|Ys] ) :-
    check_ruolo(A,B,C, R),
    !,
	tag_ruolo(Xs,Ys).
tag_ruolo( [A,B|Xs], [ruolo(R)|Ys] ) :-
    check_ruolo(A,B, R),
    !,
	tag_ruolo(Xs,Ys).
tag_ruolo([A|Xs], [ruolo(R)|Ys]) :-
    check_ruolo(A, R),
    !,
    tag_ruolo(Xs, Ys).
tag_ruolo([A|Xs], [A|Ys]) :-
    tag_ruolo(Xs, Ys).





tag_nome( [] , [] ).

% CCNNN
tag_nome( [C1,C2,N1,N2,N3|Xs], [persona(C,N)|Ys] ) :-
    atom(C1),atom(C2),atom(N1),atom(N2),atom(N3),
    cognome( C1, C2 ),
    nome(N1, N2, N3),
    !,
    atomic_list_concat([C1,C2], ' ', C),
    atomic_list_concat([N1,N2,N3], ' ', N),
	tag_nome(Xs,Ys).

% NNNCC
tag_nome( [N1,N2,N3,C1,C2|Xs], [persona(C,N)|Ys] ) :-
    atom(C1),atom(C2),atom(N1),atom(N2),atom(N3),
    nome(N1, N2, N3),
    cognome( C1, C2 ),
    !,
    atomic_list_concat([C1,C2], ' ', C),
    atomic_list_concat([N1,N2,N3], ' ', N),
	tag_nome(Xs,Ys).

% CNNN
tag_nome( [C,N1,N2,N3|Xs], [persona(C,N)|Ys] ) :-
    atom(C),atom(N1),atom(N2),atom(N3),
    cognome( C ),
    nome(N1, N2, N3),
    !,
    atomic_list_concat([N1,N2,N3], ' ', N),
	tag_nome(Xs,Ys).

% NNNC
tag_nome( [N1,N2,N3,C|Xs], [persona(C,N)|Ys] ) :-
    atom(C),atom(N1),atom(N2),atom(N3),
    nome(N1, N2, N3),
    cognome( C ),
    !,
    atomic_list_concat([N1,N2,N3], ' ', N),
	tag_nome(Xs,Ys).

% CCNN
tag_nome( [C1,C2,N1,N2|Xs], [persona(C,N)|Ys] ) :-
    atom(C1),atom(N1),atom(N2),atom(C2),
    cognome( C1, C2 ),
    nome(N1, N2),
    !,
    atomic_list_concat([C1,C2], ' ', C),
    atomic_list_concat([N1,N2], ' ', N),
	tag_nome(Xs,Ys).

% NNCC
tag_nome( [N1,N2,C1,C2|Xs], [persona(C,N)|Ys] ) :-
    atom(C1),atom(N1),atom(N2),atom(C2),
    nome(N1, N2),
    cognome( C1, C2 ),
    !,
    atomic_list_concat([C1,C2], ' ', C),
    atomic_list_concat([N1,N2], ' ', N),
	tag_nome(Xs,Ys).

% CNN
tag_nome( [C,N1,N2|Xs], [persona(C,N)|Ys] ) :-
    atom(C),atom(N1),atom(N2),
    cognome( C ),
    nome(N1, N2),
    !,
    atomic_list_concat([N1,N2], ' ', N),
	tag_nome(Xs,Ys).

% NNC
tag_nome( [N1,N2,C|Xs], [persona(C,N)|Ys] ) :-
    atom(C),atom(N1),atom(N2),
    nome(N1, N2),
    cognome( C ),
    !,
    atomic_list_concat([N1,N2], ' ', N),
	tag_nome(Xs,Ys).

% CCN
tag_nome( [C1,C2,N|Xs], [persona(C,N)|Ys] ) :-
    atom(C1),atom(C2),atom(N),
    cognome( C1, C2 ),
    nome(N),
    !,
    atomic_list_concat([C1,C2], ' ', C),
	tag_nome(Xs,Ys).

% NCC
tag_nome( [N,C1,C2|Xs], [persona(C,N)|Ys] ) :-
    atom(C1),atom(C2),atom(N),
    nome(N),
    cognome( C1, C2 ),
    !,
    atomic_list_concat([C1,C2], ' ', C),
	tag_nome(Xs,Ys).

% CN
tag_nome( [C,N |Xs], [persona(C,N)|Ys] ) :-
    atom(C),atom(N),
    cognome( C ),
    nome(N),
    !,
	tag_nome(Xs,Ys).

% NC
tag_nome( [N,C|Xs], [persona(C,N)|Ys] ) :-
    atom(C),atom(N),
    nome(N),
    cognome( C ),
    !,
	tag_nome(Xs,Ys).

% NON UNA PERSONA, continua
tag_nome( [A|Xs],[A|Ys] ) :-
	tag_nome(Xs, Ys).


cognome(A, B) :-
	cognome(A),
	cognome(B).

cognome(A,B) :-
    atomic_list_concat([A, B], ' ', C),
    cognome(C).

nome(A,B,C) :- 
    nome(A),
    nome(B),
    nome(C).

nome(A,B) :-
    nome(A),
    nome(B).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tag_titolo( [], [] ).
tag_titolo( [A], [A] ).

%ruolo aggettivo persona
tag_titolo( [ A,B,C | Xs ], [ titolo(D, C) | Ys ] ) :-
    atom(B),
    C = persona(_,_),
    A = ruolo(D),
    B = aggettivo,
    !,
    tag_titolo( Xs, Ys ).

%aggettivo ruolo persona
tag_titolo( [ A,B,C | Xs ], [ titolo(D,C) | Ys ] ) :-
    atom(A),
    C = persona(_,_),
    A = aggettivo,
    B = ruolo(D),
    !,
    tag_titolo( Xs, Ys ).


%ruolo persona
tag_titolo( [ A,B | Xs ], [ titolo(D,B) | Ys ] ) :-
    B = persona(_,_),
    A = ruolo(D),
    !,
    tag_titolo( Xs, Ys ).

%persona ruolo
tag_titolo( [ A,B | Xs ], [ titolo(D,A) | Ys ] ) :-
    A = persona(_,_),
    B = ruolo(D),
    !,
    tag_titolo( Xs, Ys ).


%aggettivo persona
tag_titolo( [ A,B | Xs ], [ B | Ys ] ) :-
    atom(A),
    A = aggettivo,
    B = persona(_,_),
    !,
    tag_titolo( Xs, Ys ).

%persona aggettivo
tag_titolo( [ A,B | Xs ], [ A | Ys ] ) :-
    A = persona(_,_),
    atom(B),
    B = aggettivo,
    !,
    tag_titolo( Xs, Ys ).

%se non è
tag_titolo( [ A,B | Xs ], [ A | Ys ] ) :-
    tag_titolo( [B|Xs], Ys ).

