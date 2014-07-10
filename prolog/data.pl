:- module(data,
          [ data/3
          ]
).

:- use_module(kb).
:- use_module(lexer).

separatore_data(IDToken) :- 
    kb:token(IDToken, '/').

separatore_data(IDToken) :- 
    kb:token(IDToken, '-').
 
data(G,M,A) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),
    kb:next(IDToken3,IDToken4),
    kb:next(IDToken4,IDToken5),

    giorno(IDToken1),
    separatore_data(IDToken2),
    mese(IDToken3),
    separatore_data(IDToken4),
    anno(IDToken5),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),
    kb:token(IDToken4, Token4),
    kb:token(IDToken5, Token5),

    atom_number(Token1,G),
    numero_mese(Token3,M),
    atom_number(Token5,A),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken5, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[DATA] Nel documento e’ presente ',Token1,Token2,Token3,Token4,Token5],'',Spiegazione),
    kb:assertTag(data(G,M,A), ListaPrecedenti, ListaSuccessivi, Spiegazione).

data(G,M,A) :-
    kb:next(IDToken1,IDToken2),
    kb:next(IDToken2,IDToken3),

    giorno(IDToken1),
    mese(IDToken2),
    anno(IDToken3),

    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    kb:token(IDToken3, Token3),

    atom_number(Token1,G),
    numero_mese(Token2,M),
    atom_number(Token3,A),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[DATA] Nel documento e’ presente',Token1,Token2,Token3],' ',Spiegazione),
    kb:assertTag(data(G,M,A), ListaPrecedenti, ListaSuccessivi, Spiegazione).


numero(IDToken) :- kb:token(IDToken, Token), atom_is_number(Token).

giorno(IDToken) :- 
    numero(IDToken), 
    kb:token(IDToken, Token), 
    atom_number(Token, N), 
    N>=1, 
    N=<31, !.

mese(IDToken) :- 
    numero(IDToken), 
    kb:token(IDToken, Token), 
    atom_number(Token, N), 
    N>=1, 
    N=<12, !.

mese(IDToken) :- 
    kb:token(IDToken, Token), 
    numero_mese(Token, _), !.

anno(IDToken) :- 
    numero(IDToken), 
    kb:token(IDToken, Token), 
    atom_number(Token, N), 
    N>1900, 
    N<2050, !.

anno(IDToken) :- 
    numero(IDToken), 
    kb:token(IDToken, Token), 
    atom_number(Token, N), 
    N>=0, 
    N<100, !.

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
