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
:- use_module(mail).
:- use_module(data).
:- use_module(tel).

lista_parole(ListaParole) :- kb:documento(Doc), lexer(Doc, ListaParole).

expandKB :- 
    findall(X, comune(X), ListaComuni),
    findall(Y, cf(Y), ListaCF),
    findall(Y, mail(Y), ListaMail),
    findall(Y, tel(Y), ListaTel),
    findall((G,M,A), data(G,M,A), ListaData),
    write(ListaComuni),nl,
    write(ListaCF),nl,
    write(ListaMail),nl,
    write(ListaTel),nl,
    write(ListaData),nl.
    

writeKB :-
    writeKB("080-3513185\nQRCLCN88L01A285K 20 novembre 1988 ciao come stai\nluciano.quercia@gmail.com nato a San Giovanni Rotondo il 1/7/1988\nciao il mio numero di telefono è +39 346 210 0360\n Corato simonerutigliano@ciao.com\noh\nRTGSMN88T20L109J").

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
    %kb:assertFact(kb:token(IDToken2, T2)),
    assertz(kb:next(IDToken1, IDToken2)),
    writeKB( [T2|Xs], Temp).

kb:assertFact(Fact):-
    \+( Fact ),
    !,
    assertz(Fact).
kb:assertFact(_).


kb:assertTag(Tag, ListaPrecedenti, ListaSuccessivi) :-
    kb:nextIDTag(NextIDTag),
    atom_number(AtomIDTag, NextIDTag),
    atom_concat('tag', AtomIDTag, IDTag),
    kb:assertFact(kb:tag(IDTag, Tag)),
    forall( member( Precedente, ListaPrecedenti ), ( kb:assertFact(kb:next(Precedente, IDTag)) ) ),
    forall( member( Successivo, ListaSuccessivi ), ( kb:assertFact(kb:next(IDTag, Successivo)) ) ),
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
