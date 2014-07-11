:- module(data,
          [ data/3
          , giorno/1
          , mese/1
          , anno/1
          , tag_data/0
          , tag_giorno/0
          , tag_mese/0
          , tag_anno/0
          ]
).

:- use_module(kb).
:- use_module(lexer).

tag_data :-     
    \+kb:vuole(data),!.
tag_data :-     
    kb:fatto(data),!.
tag_data :-
    tag_giorno,
    tag_mese,
    tag_anno, 
    findall((_,_,_), tag_data(_,_,_), _),
    asserta(kb:fatto(data)).

tag_giorno :- 
    kb:fatto(giorno),!.
tag_giorno :- 
    findall(_, tag_giorno(_), _),
    asserta(kb:fatto(giorno)).

tag_mese :- 
    kb:fatto(mese),!.
tag_mese :- 
    findall(_, tag_mese(_), _),
    asserta(kb:fatto(mese)).

tag_anno :- 
    kb:fatto(anno),!.
tag_anno :- 
    findall(_, tag_anno(_), _),
    asserta(kb:fatto(anno)).


separatore_data('/').
separatore_data('-').

data(G,M,A) :-
    kb:tag(_, data(G,M,A)).

giorno(G) :-
    kb:tag(_, giorno(G)).

mese(M) :-
    kb:tag(_, mese(M)).

anno(A) :-
    kb:tag(_, anno(A)).

tag_giorno(N) :-
    kb:token(IDToken, Token),
    atom_is_number(Token),
    atom_number(Token, N), 
    N>=1, 
    N=<31,
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[GIORNO] Il numero ',Token,' puo’ essere un giorno'],'',Spiegazione),
    assertTag(giorno(N), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_anno(N) :-
    kb:token(IDToken, Token),
    atom_is_number(Token),
    atom_number(Token, N), 
    N>1900, 
    N<2050,
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[ANNO] Il numero ',Token,' puo’ essere un anno'],'',Spiegazione),
    assertTag(anno(N), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_anno(N) :-
    kb:token(IDToken, Token),
    atom_is_number(Token),
    atom_number(Token, N), 
    N>=0, 
    N=<99,
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[ANNO] Il numero ',Token,' puo’ essere un anno'],'',Spiegazione),
    assertTag(anno(N), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_mese(N) :- 
    kb:token(IDToken, Token), 
    numero_mese(Token, N),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[MESE] La stringa ', Token,' puo’ essere un mese'],'',Spiegazione),
    assertTag(mese(N), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

tag_data(G,M,A) :-
    kb:tag(IDTag1, giorno(G)),
    kb:tag(IDTag2, mese(M)),
    kb:tag(IDTag3, anno(A)),
    kb:next(IDTag1, IDToken1),
    kb:next(IDToken1,IDTag2),
    kb:next(IDTag2,IDToken2),
    kb:next(IDToken2, IDTag3),
    kb:token(IDToken1, Token1),
    kb:token(IDToken2, Token2),
    separatore_data(Token1),
    separatore_data(Token2),
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[DATA] Nel documento sono presenti giorno, mese e anno separati dal separatore ', Token1],'',Spiegazione),
    Dipendenze = [IDTag1, IDTag2, IDTag3],
    assertTag(data(G,M,A), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

tag_data(G,M,A) :-
    kb:tag(IDTag1, giorno(G)),
    kb:tag(IDTag2, mese(M)),
    kb:tag(IDTag3, anno(A)),
    kb:next(IDTag1, IDTag2),
    kb:next(IDTag2, IDTag3),

    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag3, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[DATA] Nel documento sono presenti giorno, mese e anno'],'',Spiegazione),
    Dipendenze = [IDTag1, IDTag2, IDTag3],
    assertTag(data(G,M,A), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).


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