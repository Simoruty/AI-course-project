:- module( dotserialize, [ dotserialize/0 ]).

:- use_module(kb).
:- use_module(lexer).
:- use_module(library(lists)).


dotserialize :-    
    tell('dotserialization'),
    s_init,    
    s_token,
    s_livello1,
    s_livello2,
    s_livello3,
    s_next,
    s_end,
    told.

s_init :-
    write('digraph{'),nl,
    write('rankdir="LR";'),nl.

s_end :-
    write('}').


s_livello1 :- 
    write('subgraph{'),nl,
    write('rank=same;'),nl,
    s_tag( numero(_)),
    s_tag( parola(_)),
    s_tag( cf(_)),
    s_tag( mail(_)),
    s_tag( chiro(_)),
    s_tag( totale(_) ),
    s_tag( privilegiato(_) ),
    s_tag( simbolo_soggetto(_) ),
    s_tag( simbolo_curatore(_) ),    
    s_tag( simbolo_giudice(_) ),
    s_tag( euro(_) ),
    s_tag( dollaro(_) ),
    s_tag( newline(_) ),   
    write('}'), nl,
true.

s_livello2 :-
    write('subgraph{'),nl,
    write('rank=same;'),nl,
    s_tag( cognome(_) ),
    s_tag( nome(_) ),
    s_tag( persona(_,_) ),
    s_tag( valuta(_,_) ),
    s_tag( comune(_) ),
    s_tag( giorno(_) ),
    s_tag( mese(_) ),
    s_tag( anno(_) ),
    s_tag( data(_,_,_) ),
    write('}'),nl,
    true.

s_livello3 :-
    write('subgraph{'),nl,
    write('rank=same;'),nl,
    s_tag( soggetto(_,_) ),
    s_tag( curatore(_,_) ),
    s_tag( giudice(_,_) ),
    s_tag( richiesta_valuta(_,_,_) ),
    s_tag( numero_pratica(_) ),
    write('}'),nl,
    true.


s_next :-
    %tutti i next
    findall((ID1,ID2), kb:next(ID1, ID2), ListaNext),
    forall( member((T1,T2), ListaNext), (write(T1),write(' -> '),write(T2),write(';'),nl) ),
true.

s_token :- 
    write('subgraph{'),nl,
    write('rank=same;'),nl,
    %tutti i token
    findall(ID, (kb:token(ID,_)), ListaToken),
    forall( member(T, ListaToken), (write(T),write(' [shape=box];'),nl) ),
    write('}'),nl,
%    tutti i tag
%    findall(ID, (kb:tag(ID,_)), ListaTag),
%    forall( member(T, ListaTag), (write(T),write(' [shape=circle];'),nl) ),
    true.

s_tag(Goal) :-
    findall( ID, kb:tag(ID, Goal), ListaTag),
    forall( member( ID, ListaTag ), (
        write(ID),write(' [shape=circle]; '),nl
    ) ),
    true.
