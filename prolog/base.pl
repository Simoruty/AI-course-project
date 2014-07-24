:- module( base, [
                      tag_parola/0
                    , tag_numero/0
                    , allnumero/1
                   ] 
).

:- use_module(lexer).
:- use_module(kb).

%% Tagga le parole
tag_parola(Token1) :- 
    kb:token(IDToken1, Token1),
    atom_is_word(Token1),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[PAROLA] Presenza nel documento della parola',Token1],' ',Spiegazione),
    kb:appartiene(IDToken1, IDDoc),
    assertTag(parola(Token1), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDToken1]).

tag_parola :-
    kb:fatto(parola), !.
tag_parola :-
    findall((_,_,_), tag_parola(_), _),
    assertFact(kb:fatto(parola)).

%% Tagga i numeri
tag_numero :-
    kb:fatto(numero), !.
tag_numero :-
    findall(_, tag_numero(_), _),
    kb:assertFact(kb:fatto(numero)).

%% Tagga i numeri
tag_numero(Num) :- 
    kb:token(IDToken1, Token1),
    atom_is_number(Token1),
    atom_number(Token1, Num),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NUMERO] Presenza nel documento del numero',Num],' ',Spiegazione),
    kb:appartiene(IDToken1, IDDoc),
    assertTag(numero(Num), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDToken1]).

%% Tagga i numeri con virgola
tag_numero(Num) :- 
    kb:token(IDToken1, Token1),

    atomic_list_concat( List, ',', Token1),
    List=[ParteIntera, ParteDecimale],
    atom_is_number(ParteIntera),
    atom_is_number(ParteDecimale),
    atomic_list_concat( [ParteIntera, ParteDecimale], '.', AtomNum),

    atom_number(AtomNum, Num),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NUMERO] Presenza nel documento del numero ',ParteIntera,',',ParteDecimale],'',Spiegazione),
    kb:appartiene(IDToken1, IDDoc),
    assertTag(numero(Num), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDToken1]).

%% Trova tutti i numeri
allnumero(ListaNumeri) :-
    findall((IDTag, N) ,kb:tag(IDTag, numero(N)), ListaNumeri).

