:- module(indirizzo,
          [ tag_indirizzo/2
          ]
).


tag_indirizzo([], []).
tag_indirizzo([A,B|Xs], [A,P|Ys]) :-
    atom(A),
    via(A),
    B = persona(C,N),
    atomic_list_concat([N, C],' ', P),
    !,
    tag_indirizzo(Xs, Ys).
tag_indirizzo([A | Xs], [ A | Ys ] ) :-
    tag_indirizzo(Xs, Ys).

via('via').
via('viale').
via('vico').
via('vicolo').
via('largo').
via('larghetto').
via('corso').
via('piazza').
via('estramurale').
via('extramurale').
via('strada').

via('s','s').
via('via','le').
via('s','e').
via('s','p').

via('via','.','le').
via('c','.','so').
via('p','.','za').
via('p','.','zza').

via('estr','.','le').
via('s','e','.').
via('s','p','.').
via('s','s','.').

via('s','.','e','.').
via('s','.','p','.').
via('s','.','s','.').
