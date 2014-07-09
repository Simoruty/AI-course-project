:- module( conoscenza, [ stessa_frase/2
                       , numero/1
                       , writeKB/0
                       , writeKB/1
                       , writeKB/2
                       , lista_parole/1
                       ]
).

:- use_module(lexer).

lista_parole(ListaParole) :- kb:documento(Doc), lexer(Doc, ListaParole).

writeKB :-
    writeKB("0803531185\n+39 374 9434186\nluciano.quercia@gmail.com\nciao simonerutigliano@ciao.com\noh").

writeKB(String) :-
    asserta(kb:documento(String)),    
    lista_parole( Lista ),
    writeKB(Lista, 0).

writeKB( [T1|[]], Num ) :-
    atom_number(AtomNum1,Num),
    atom_concat('t',AtomNum1, IDToken1),
    assertz(kb:token(IDToken1, T1)),
    IDEOF is Num+1,
    atom_number(AtomIDEOF,IDEOF),
    atom_concat('t',AtomIDEOF, IDTokenEOF),
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

%assertFact(Fact):-
%    \+( Fact ),
%    !,
%    assertz(Fact).
%assertFact(_).


numero(IDToken)     :- kb:token(IDToken, Token), atom_is_number(Token).
stessa_frase(IDToken1, IDToken2) :-
    kb:next(IDToken1, IDToken2),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    Token1\='\n', Token2\='\n'.

stessa_frase(IDToken1, IDToken2) :-
    kb:next(IDToken1, IDTokenX),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDTokenX, TokenX),
    Token1\='\n', TokenX\='\n', Token2\='\n', stessa_frase(IDTokenX,IDToken2).

%Riflessivo
%stessa_frase(IDToken1, IDToken2) :- stessa_frase(IDToken2,IDToken1).
