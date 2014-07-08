:- use_module(lexer).
:- use_module(tagger).
:- use_module(library(lists)).
%:- consult('dataset.pl').

main :-
    write('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'),nl,    
    write('                                                                               '),nl,
    write('████████╗ █████╗  ██████╗  ██████╗ ███████╗██████╗         ██╗██╗   ██╗███████╗'),nl,
    write('╚══██╔══╝██╔══██╗██╔════╝ ██╔════╝ ██╔════╝██╔══██╗        ██║██║   ██║██╔════╝'),nl,
    write('   ██║   ███████║██║  ███╗██║  ███╗█████╗  ██████╔╝        ██║██║   ██║███████╗'),nl,
    write('   ██║   ██╔══██║██║   ██║██║   ██║██╔══╝  ██╔══██╗        ██║██║   ██║╚════██║'),nl,
    write('   ██║   ██║  ██║╚██████╔╝╚██████╔╝███████╗██║  ██║        ██║╚██████╔╝███████║'),nl,
    write('   ╚═╝   ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝        ╚═╝ ╚═════╝ ╚══════╝'),nl,
    write('                                                                               '),nl,
    write('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'),nl,nl,    

%    write('Inserisci il testo del documento: '),nl,nl,
%    read(Documento),
%    to_string(Documento, Stringa), % lets user be free to write atom or strings
%    asserta(documento(Stringa)),
    asserta(documento("ciao sono luciano quercia\nio sono simone rutigliano\nsalve piacere vito trentadue\nnato a Corato il 25/2/2012\nBari, lì 2/3/2014")),

%    extract(ListaTag),
    writeKB.
%    nl,write('Informazioni estratte: '), nl,nl,
%    write(ListaTag),nl.

%extract( ListaTag ) :-
%    domanda( String ),
%    lexer( String, ListaToken ),
%    tagger( ListaToken,ListaTag ).

lista_parole(ListaParole) :- documento(Doc), lexer(Doc,ListaParole).

writeKB :- lista_parole( Lista ), writeKB(Lista, 0).
writeKB( [T1|[]], Num ) :-
    atom_number(AtomNum1,Num),
    atom_concat('t',AtomNum1, IDToken1),
    assertFact(token(IDToken1, T1)).
    
writeKB( [ T1,T2 | Xs ], Num) :-
    atom_number(AtomNum1,Num),
    Temp is Num+1,
    atom_number(AtomNum2,Temp),
    atom_concat('t',AtomNum1, IDToken1),
    atom_concat('t',AtomNum2, IDToken2),
    assertFact(token(IDToken1, T1)),
    assertFact(token(IDToken2, T2)),
    assertFact(next(IDToken1, IDToken2)),
    writeKB( [T2|Xs], Temp).


assertFact(Fact):-
    \+( Fact ),
    !,
    asserta(Fact).
    assertFact(_).


%token/2
%numero/1
%V next(T1,T2)

%in_frase(T,F)
%valuta(T1)
%separatore(T1)
%giorno(T1)
%mese(T1)
%anno(T1)


%dividi_in_frase( [], ['13'| _ ] ).
%dividi_in_frase( [X1|Xs], [X1|Ys]) :- dividi_in_frase(Xs, Ys).

stessa_frase(T1, T2) :- next(T1, T2), T1\='10', T2\='10'.
stessa_frase(T1, T2) :- next(T1, X), T1\='10', T2\='10', X\='10', stessa_frase(X,T2).

%stessa_frase(T1, T2) :- T1\='10', T2\='10', X\='10', next(T1, X), next(X,T2).
%stessa_frase(T1, T2) :- T1\='10', T2\='10', X\='10', Y\='10', next(T1, X), next(Y,T2), stessa_frase(X,Y).
%Riflessivo
%stessa_frase(T1, T2) :- T1\='10', T2\='10', stessa_frase(T2,T1).

%token(T) :- lista_parole(ListaParole), member(T,ListaParole), atom(T).


%next(T1,T2) :- lista_parole(ListaParole), adiacente(T1, T2, ListaParole).
%adiacente(X1, X2, [X1, X2 | _ ]).
%adiacente(X1, X2, [A1, A2 | Xs]) :- adiacente(X1, X2, [A2|Xs]). 

separatore(IDToken) :- token(IDToken, Token), Token='/'.
separatore(IDToken) :- token(IDToken, Token), Token='-'.
separatore(IDToken) :- token(IDToken, Token), Token='.'.
numero(IDToken)     :- token(IDToken, Token), atom_is_number(Token).

data(G,M,A) :-
    
    next(IDToken1,IDToken2),
    next(IDToken2,IDToken3),
    next(IDToken3,IDToken4),
    next(IDToken4,IDToken5),

    giorno(IDToken1),
    separatore(IDToken2),
    mese(IDToken3),
    separatore(IDToken4),
    anno(IDToken5),

    token(IDToken1, Token1),
%    token(IDToken2, _),
    token(IDToken3, Token3),
%    token(IDToken4, _),
    token(IDToken5, Token5),

    atom_number(Token1,G),
    numero_mese(Token3,M),
    atom_number(Token5,A).

giorno(IDToken) :- numero(IDToken), token(IDToken, Token), atom_number(Token, N), N>=1, N=<31, !.
mese(IDToken) :- numero(IDToken), token(IDToken, Token), atom_number(Token, N), N>=1, N=<12, !.
mese(IDToken) :- token(IDToken, Token), numero_mese(Token, _), !.
anno(IDToken) :- numero(IDToken), token(IDToken, Token), atom_number(Token, N), N>1900, N<2050, !.
anno(IDToken) :- numero(IDToken), token(IDToken, Token), atom_number(Token, N), N>=0, N<100, !.
%mese('gennaio').
%mese('febbraio').
%mese('marzo').
%mese('aprile').
%mese('maggio').
%mese('giugno').
%mese('luglio').
%mese('agosto').
%mese('settembre').
%mese('ottobre').
%mese('novembre').
%mese('dicembre').
%mese('gen').
%mese('feb').
%mese('mar').
%mese('apr').
%mese('mag').
%mese('giu').
%mese('lug').
%mese('ago').
%mese('set').
%mese('ott').
%mese('nov').
%mese('dic').
numero_mese('1', 1).
numero_mese('2', 2).
numero_mese('3', 3).
numero_mese('4', 4).
numero_mese('5', 5).
numero_mese('6', 6).
numero_mese('7', 7).
numero_mese('8', 8).
numero_mese('9', 9).
numero_mese('10', 10).
numero_mese('11', 11).
numero_mese('12', 12).
numero_mese('gennaio', 1).
numero_mese('febbraio', 2).
numero_mese('marzo', 3).
numero_mese('aprile', 4).
numero_mese('maggio', 5).
numero_mese('giugno', 6).
numero_mese('luglio', 7).
numero_mese('agosto', 8).
numero_mese('settembre', 9).
numero_mese('ottobre', 10).
numero_mese('novembre', 11).
numero_mese('dicembre', 12).
numero_mese('gen', 1).
numero_mese('feb', 2).
numero_mese('mar', 3).
numero_mese('apr', 4).
numero_mese('mag', 5).
numero_mese('giu', 6).
numero_mese('lug', 7).
numero_mese('ago', 8).
numero_mese('set', 9).
numero_mese('ott', 10).
numero_mese('nov', 11).
numero_mese('dic', 12).
