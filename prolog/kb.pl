:- module( kb, [ stessa_frase/2
                       , token/1
                       , tag/1
                       , numero/1
                       , writeKB/0
                       , writeKB/1
                       , expandKB/0
                       , lista_parole/1
                       , assertFact/1
                       , assertTag/3
                       , nextIDTag/1
                       ]
).

:- use_module(library(lists)).
:- use_module(lexer).
:- use_module(comune).
:- use_module(cf).

lista_parole(ListaParole) :- kb:documento(Doc), lexer(Doc, ListaParole).

expandKB :- 
    findall(X, comune(X), ListaComuni),
    findall(Y, cf(Y), ListaCF),
    write(ListaComuni),nl,
    write(ListaCF),nl.

writeKB :-
    writeKB("QRCLCN88L01A285K ciao come stai\nluciano.quercia@gmail.com nato a San Giovanni Rotondo\nciao Corato simonerutigliano@ciao.com\noh\nRTGSMN88T20L109J").

writeKB(String) :-
    asserta(kb:documento(String)),    
    lista_parole( Lista ),
    writeKB(Lista, 1).

writeKB( [T1|[]], Num ) :-
    atom_number(AtomNum1,Num),
    atom_concat('t',AtomNum1, IDToken1),
    assertz(kb:token(IDToken1, T1)),
    IDEOF is Num+1,
    atom_number(AtomIDEOF,IDEOF),
    atom_concat('t',AtomIDEOF, IDTokenEOF),
    asserta(kb:token('t0', 'BOF')),
    asserta(kb:next('t0', 't1')),
    assertz(kb:token(IDTokenEOF, 'EOF')),
    assertz(kb:next(IDToken1, IDTokenEOF)).

writeKB( [ T1,T2 | Xs ], Num) :-
    atom_number(AtomNum1,Num),
    Temp is Num+1,
    atom_number(AtomNum2,Temp),
    atom_concat('t',AtomNum1, IDToken1),
    atom_concat('t',AtomNum2, IDToken2),
    assertz(kb:token(IDToken1, T1)),
    %assertFact(kb:token(IDToken2, T2)),
    assertz(kb:next(IDToken1, IDToken2)),
    writeKB( [T2|Xs], Temp).

assertFact(Fact):-
    \+( Fact ),
    !,
    assertz(Fact).
assertFact(_).


assertTag(Tag, ListaPrecedenti, ListaSuccessivi) :-
    kb:nextIDTag(NextIDTag),
    atom_number(AtomIDTag, NextIDTag),
    atom_concat('tag', AtomIDTag, IDTag),
    assertFact(kb:tag(IDTag, Tag)),
    forall( member( Precedente, ListaPrecedenti ), ( assertFact(kb:next(Precedente, IDTag)) ) ),
    forall( member( Successivo, ListaSuccessivi ), ( assertFact(kb:next(IDTag, Successivo)) ) ),
    atomic_list_concat( ['Trovato tag:', IDTag, 'con contenuto: '], ' ', Message),
    write(Message), write(Tag), nl.


kb:token(IDToken) :- kb:token(IDToken, _).
kb:tag(IDTag) :- kb:tag(IDTag, _).
kb:nextIDTag(ID) :- findall(X, kb:tag(X), List), length(List, Ntag), ID is Ntag.

numero(IDToken) :- kb:token(IDToken, Token), atom_is_number(Token).
newline(ID) :- kb:token(ID, '\n').


stessa_frase(ID1, ID2) :-
    kb:next(ID1, ID2),
    \+newline(ID1),
    \+newline(ID2).

stessa_frase(ID1, ID2) :-
    kb:next(ID1, ID3),
    \+newline(ID1),
    \+newline(ID2),
    \+newline(ID3),
    stessa_frase(ID3,ID2).

%Riflessivo %TODO
%stessa_frase(IDToken1, IDToken2) :- stessa_frase(IDToken2,IDToken1).
