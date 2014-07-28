:- module( base, [
                      tag_parola/0
                    , tag_separatore_data/0
                    , tag_numero/0
                    , allnumero/1
                   ] 
).

:- use_module(lexer).
:- use_module(kb).

%% Tagga i separatori_data
tag_separatore_data(Symb) :- 
    kb:token(IDToken1, Symb),
    tipo_separatore_data(Symb),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[SEPARATORE DATA] Presenza nel documento del simbolo ', Symb],'',Spiegazione),
    kb:appartiene(IDToken1, IDDoc),
    assertTag(separatore_data(Symb), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDToken1]).

tipo_separatore_data('/').
tipo_separatore_data('-').

%% Tagga le parole
tag_parola(Token1) :- 
    kb:token(IDToken1, Token1),
    atom_is_word(Token1),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[PAROLA] Presenza nel documento della parola ',Token1],'',Spiegazione),
    kb:appartiene(IDToken1, IDDoc),
    assertTag(parola(Token1), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDToken1]).

tag_separatore_data :-
    kb:fatto(separatore_data), !.
tag_separatore_data :-
    findall((_,_,_), tag_separatore_data(_), _),
    assertFact(kb:fatto(separatore_data)).

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
tag_numero(Token1) :- 
    kb:token(IDToken1, Token1),
    atom_is_number(Token1),
    atom_number(Token1, Num),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NUMERO] Presenza nel documento del numero ',Token1],'',Spiegazione),
    kb:appartiene(IDToken1, IDDoc),
    assertTag(numero(Token1), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDToken1]),
    kb:lastIDTag(NIDTag),
    atom_number(AtomNIDTag, NIDTag),
    atom_concat('tag', AtomNIDTag, IDTag),
    kb:assertFact(kb:val(IDTag, Num)).

%% Tagga i numeri con virgola
tag_numero(Token1) :- 
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
    assertTag(numero(Token1), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, [IDToken1]),
    kb:lastIDTag(NIDTag),
    atom_number(AtomNIDTag, NIDTag),
    atom_concat('tag', AtomNIDTag, IDTag),
    kb:assertFact(kb:val(IDTag, Num)).

%% Trova tutti i numeri
allnumero(ListaNumeri) :-
    findall((IDTag, N) ,(kb:tag(IDTag, numero(_)), kb:val(IDTag, N) ), ListaNumeri).

