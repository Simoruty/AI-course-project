:- module( dotserialize, [ dotserialize/0 ]).

:- use_module(kb).
:- use_module(lexer).
:- use_module(library(lists)).


dotserialize :-    
    tell('dotserialization.dot'),
    s_init,    
    s_token,
    s_livello1,
    s_livello2,
    s_livello3,
    s_next,
    s_end,
    told.

s_init :-
    write('digraph {'),nl,
    write('rankdir=LR;'),nl.
s_token :- 
    write('subgraph {'),nl,
%    write('rank="max";'),nl,
    %tutti i token
    findall(ID, (kb:token(ID,_)), ListaToken),
    forall( member(T, ListaToken), (write(T),write(' [shape=box];'),nl) ),

    findall((ID1,ID2), (kb:next(ID1, ID2), kb:token(ID1,_), kb:token(ID2,_)), ListaNext),
    forall( member((T1,T2), ListaNext), (write(T1),write(' -> '),write(T2),write(';'),nl) ),
    
    write('}'),nl,
%    tutti i tag
%    findall(ID, (kb:tag(ID,_)), ListaTag),
%    forall( member(T, ListaTag), (write(T),write(' [shape=circle];'),nl) ),
    true.

s_end :-
    write('}').


s_livello1 :- 
    write('subgraph {'),nl,
%    write('rank="sink";'),nl,
    s_tag( numero(_), red),
    s_tag( parola(_), red),
    s_tag( cf(_), red),
    s_tag( mail(_),red),
    s_tag( chiro(_),red),
    s_tag( totale(_),red ),
    s_tag( privilegiato(_),red ),
    s_tag( simbolo_soggetto(_),red ),
    s_tag( simbolo_curatore(_),red ),    
    s_tag( simbolo_giudice(_),red ),
    s_tag( euro(_),red ),
    s_tag( dollaro(_),red ),
    s_tag( newline(_),red ),   
    write('}'), nl,
true.

s_livello2 :-
    write('subgraph {'),nl,
%    write('rank="same";'),nl,
    s_tag( cognome(_),blue ),
    s_tag( nome(_),blue ),
    s_tag( persona(_,_),blue ),
    s_tag( valuta(_,_),blue ),
    s_tag( comune(_),blue ),
    s_tag( giorno(_),blue ),
    s_tag( mese(_),blue ),
    s_tag( anno(_),blue ),
    s_tag( data(_,_,_),blue ),
    write('}'),nl,
    true.

s_livello3 :-
    write('subgraph {'),nl,
%    write('rank="min";'),nl,
    s_tag( soggetto(_,_),green ),
    s_tag( curatore(_,_),green ),
    s_tag( giudice(_,_),green ),
    s_tag( richiesta_valuta(_,_,_),green ),
    s_tag( numero_pratica(_),green ),
    write('}'),nl,
    true.


s_next :-
    %tutti i next
    findall((ID1,ID2), (kb:next(ID1, ID2), kb:tag(ID1,_), kb:token(ID2,_)), ListaTagToken),
    forall( member((T1,T2), ListaTagToken), (write(T1),write(' -> '),write(T2),write(';'),nl) ),

    findall((ID1,ID2), (kb:next(ID1, ID2), kb:tag(ID2,_), kb:token(ID1,_)), ListaTokenTag),
    forall( member((T1,T2), ListaTokenTag), (write(T1),write(' -> '),write(T2),write(';'),nl) ),

    findall((ID1,ID2), (kb:next(ID1, ID2), kb:tag(ID1,_), kb:tag(ID2,_)), ListaTagTag),
    forall( member((T1,T2), ListaTagTag), (write(T1),write(' -> '),write(T2),write(';'),nl) ),
true.


s_tag(Goal, Color) :-
    findall( ID, kb:tag(ID, Goal), ListaTag),
    forall( member( ID, ListaTag ), (
        write(ID),write(' [shape=circle color='), write(Color),write(']; '),nl
    ) ),
    true.
