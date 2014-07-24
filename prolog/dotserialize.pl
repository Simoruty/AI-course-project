:- module( dotserialize, [ dotserialize/0 ]).

:- use_module(kb).
:- use_module(lexer).
:- use_module(library(lists)).

dotserialize :-    
    tell('filedot.dot'),
    s_init,    
    s_token,
    s_livello1,
    s_livello2,
    s_livello3,
    s_livello4,
%    s_livello5,
    s_depends,
    s_end,
    told.

s_init :-
    write('digraph {'), nl,
    write('   rankdir=BT;'), nl,
    write('   edge [arrowhead=empty];'), nl.

s_end :-
    write('}').

s_token :- 
    nl, write('   subgraph {'), nl,
    write('      rank="source";'), nl,
    write('      edge [arrowhead=normal];'), nl,
    write('      node [shape=box];'), nl,
    findall((ID,Label), (kb:token(ID,Label)), ListaToken),
    forall( member((T1,T2), ListaToken),
      (
        write('      '),
        write(T1),
        write(' [label="'),
        clean(T2,T2c),
        write(T2c),
        write('"];'), nl
      )
    ),
    findall((ID1,ID2), (kb:next(ID1, ID2), kb:token(ID1,_), kb:token(ID2,_)), ListaNextFraToken),
    forall( member((T1,T2), ListaNextFraToken),
      (
        write('      '),
        write(T1),
        write(' -> '),
        write(T2),
        write(';'),
        nl
      )
    ),
    write('   }'), nl,
    true.

clean('\n','\\n') :- !.
clean(A,A).

s_livello1 :- 
    nl, write('   subgraph {'), nl,
    write('      rank="same";'), nl,
    write('      node [color=red,shape=circle];'),nl,
    s_tag( numero(_), 'numero'),
    s_tag( parola(_), 'parola'),
    s_tag( newline(_),'newline' ),   
    s_tag( euro(_),'euro' ),
    s_tag( dollaro(_),'dollaro' ),
    s_tag( mail(_),'mail'),
    s_tag( cf(_), 'cod_fiscale'),
    s_tag( separatore_data(_), 'sep_data'),
    s_tag( prefisso(_), 'prefisso'),

    write('   }'), nl,
    true.

s_livello2 :-
    nl, write('   subgraph {'),nl,
    write('      rank="same";'),nl,
    write('      node [color=blue,shape=circle];'),nl,
    s_tag( chiro(_),'chiro'),
    s_tag( totale(_),'totale' ),
    s_tag( privilegiato(_),'privilegiato' ),
    s_tag( simbolo_soggetto(_),'sym_soggetto' ),
    s_tag( simbolo_curatore(_),'sym_curatore' ),    
    s_tag( simbolo_giudice(_),'sym_giudice' ),
    s_tag( cognome(_), 'cognome' ),
    s_tag( nome(_), 'nome' ),
    s_tag( valuta(_,_), 'valuta' ),
    s_tag( comune(_), 'comune' ),
    s_tag( giorno(_), 'giorno' ),
    s_tag( mese(_), 'mese' ),
    s_tag( anno(_), 'anno' ),
    s_tag( tel(_), 'telefono' ),
    write('   }'), nl,
    true.

s_livello3 :-
    nl, write('   subgraph {'), nl,
    write('      rank="same";'), nl,
    write('      node [color=green,shape=circle];'),nl,
    s_tag( data(_,_,_), 'data' ),
    s_tag( persona(_,_), 'persona' ),
    s_tag( numero_pratica(_), 'n_pratica' ),
    write('   }'), nl,
    true.

s_livello4 :-
    nl, write('   subgraph {'), nl,
    write('      rank="same";'), nl,
    write('      node [color=orange,shape=circle];'),nl,
    s_tag( soggetto(_,_), 'soggetto' ),
    s_tag( curatore(_,_), 'curatore' ),
    s_tag( giudice(_,_), 'giudice' ),
    s_tag( richiesta_valuta(_,_,_), 'richiesta_valuta' ),
    write('   }'), nl,
    true.

%s_livello5 :-
%    nl, write('   subgraph {'), nl,
%    write('      rank="sink";'), nl,
%    write('      node [color=yellow,shape=circle];'),nl,
%    s_tag( data(_,_,_),data ),
%    s_tag( soggetto(_,_),soggetto ),
%    s_tag( curatore(_,_),curatore ),
%    s_tag( giudice(_,_),giudice ),
%    s_tag( richiesta_valuta(_,_,_),richiesta_valuta ),
%    s_tag( numero_pratica(_),n_pratica ),
%    write('   }'), nl,
%    true.

s_tag(Goal, Label) :-
    findall( ID, kb:tag(ID, Goal), ListaTag),
    forall( member( ID, ListaTag ),
      (
        write('      '),
        write(ID),
        write(' [label='),
        write(Label),
        write(']; '),
        nl
      )
    ),
    true.

s_depends :-
    findall((ID1,ID2), kb:depends(ID1, ID2), ListaDepends),
    forall( member((T1,T2), ListaDepends),
      (
        write('   '),
        write(T2),
        write(' -> '),
        write(T1),
        write(';'),
        nl
      )
    ),
    true.



