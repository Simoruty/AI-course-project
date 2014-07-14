:- module( comune, 
            [ tag_comune/0
            , comune/1
            , comune/2
            , allcomune/1
            , riscomune/0
            ] 
).

:- use_module(kb).

:- consult('comune_kb.pl').

%% Trova il primo comune
comune(Comune) :-
    kb:tag(_, comune(Comune)).

comune(IDTag,Comune) :-
    kb:tag(IDTag, comune(Comune)).

%% Trova tutti i comuni
allcomune(ListaComuni) :-
    findall((IDTag,Comune) ,kb:tag(IDTag, comune(Comune)), ListaComuni).

%% Risultati
riscomune :-
    \+kb:vuole(comune), !.
riscomune :-
    findall(Comune ,kb:tag(_, comune(Comune)), ListaComuni),
    write('I comuni trovati sono: '), 
    write( ListaComuni ).

%% Tagga tutti i comuni
tag_comune :-
    \+kb:vuole(comune), !.
tag_comune :- 
    kb:fatto(comune), !.
tag_comune :-
    findall(X, tag_comune(X), _),
    asserta(kb:fatto(comune)).

tag_comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    kb:next(IDToken4,IDToken5),
    kb:next(IDToken5,IDToken6),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),
    kb:token(IDToken6, Token6),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5, Token6], ' ', Comune),
    comune_kb(Comune),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken6, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    assertTag(comune(Comune), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    kb:next(IDToken4,IDToken5),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),

    atomic_list_concat([Token1, Token2, Token3, Token4, Token5], ' ', Comune),
    comune_kb(Comune),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken5, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    assertTag(comune(Comune), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),

    atomic_list_concat([Token1, Token2, Token3, Token4], ' ', Comune),
    comune_kb(Comune),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken4, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    assertTag(comune(Comune), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),

    atomic_list_concat([Token1, Token2, Token3], ' ', Comune),
    comune_kb(Comune),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    assertTag(comune(Comune), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_comune(Comune) :-
    kb:next(IDToken1,IDToken2),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    atomic_list_concat([Token1, Token2], ' ', Comune),
    comune_kb(Comune),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    assertTag(comune(Comune), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_comune(Comune) :-
    kb:token(IDToken1, Comune),
    comune_kb(Comune),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[COMUNE] Presenza nel documento di : ',Comune],' ',Spiegazione),
    assertTag(comune(Comune), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).
