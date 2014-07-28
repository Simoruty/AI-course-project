:- module( graph_explain, [ 
                            graph_explain_all/0
                          , graph_explain/1
                          ]
).

:- use_module(kb).
:- use_module(lexer).
:- use_module(library(lists)).


graph_explain_all :-
    findall(IDTag, kb:tag(IDTag, _), ListaTag),
    forall(member(Tag, ListaTag), (graph_explain(Tag))),
    true.

graph_explain(IDTag) :-
    atom_concat(IDTag,'.dot', NomeFile),
    atom_concat('graph/', NomeFile, NomeFilePath),    
    tell(NomeFilePath),
    kb:listaDep(IDTag, Dipendenze),
    s_init,
    s_token(Dipendenze), 
    s_livello1(Dipendenze),
    s_livello2(Dipendenze),
    s_livello3(Dipendenze),
    s_livello4(Dipendenze),
    s_depends(Dipendenze),
    s_end,
    told.


clean('\n','\\n') :- !.
clean(A,A).

s_init :-
    write('digraph {'), nl,
    write('   rankdir=BT;'), nl,
    write('   edge [arrowhead=empty];'), nl.

s_end :-
    write('}').

s_token(Dipendenze) :-
    nl, write('   subgraph {'), nl,
    write('      rank="source";'), nl,
    write('      edge [arrowhead=normal];'), nl,
    write('      node [shape=box];'), nl,
    findall((ID,Label), (member(ID, Dipendenze),kb:token(ID,Label)), ListaToken),
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
    findall((ID1,ID2), (member(ID1, Dipendenze), member(ID2, Dipendenze), kb:next(ID1, ID2), kb:token(ID1,_), kb:token(ID2,_)), ListaNextFraToken),
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

s_livello1(Dipendenze) :- 
    nl, write('   subgraph {'), nl,
    write('      rank="same";'), nl,
    write('      node [color=red,shape=circle];'),nl,
    s_tag( numero(_), 'numero', Dipendenze),
    s_tag( parola(_), 'parola', Dipendenze),
    s_tag( newline(_),'newline', Dipendenze),   
    s_tag( euro(_),'euro', Dipendenze),
    s_tag( dollaro(_),'dollaro', Dipendenze),
    s_tag( mail(_),'mail', Dipendenze),
    s_tag( cf(_), 'cod_fiscale', Dipendenze),
    s_tag( separatore_data(_), 'sep_data', Dipendenze),
    s_tag( prefisso(_), 'prefisso', Dipendenze),

    write('   }'), nl,
    true.

s_livello2(Dipendenze) :-
    nl, write('   subgraph {'),nl,
    write('      rank="same";'),nl,
    write('      node [color=blue,shape=circle];'),nl,
    s_tag( chiro(_),'chiro', Dipendenze),
    s_tag( totale(_),'totale', Dipendenze),
    s_tag( privilegiato(_),'privilegiato', Dipendenze),
    s_tag( simbolo_soggetto(_),'sym_soggetto', Dipendenze),
    s_tag( simbolo_curatore(_),'sym_curatore', Dipendenze),    
    s_tag( simbolo_giudice(_),'sym_giudice', Dipendenze),
    s_tag( cognome(_), 'cognome', Dipendenze),
    s_tag( nome(_), 'nome', Dipendenze),
    s_tag( valuta(_,_), 'valuta', Dipendenze),
    s_tag( comune(_), 'comune', Dipendenze),
    s_tag( giorno(_), 'giorno', Dipendenze),
    s_tag( mese(_), 'mese', Dipendenze),
    s_tag( anno(_), 'anno', Dipendenze),
    s_tag( tel(_), 'telefono', Dipendenze),
    write('   }'), nl,
    true.


s_livello3(Dipendenze) :-
    nl, write('   subgraph {'), nl,
    write('      rank="same";'), nl,
    write('      node [color=green,shape=circle];'),nl,
    s_tag( data(_,_,_), 'data', Dipendenze),
    s_tag( persona(_,_), 'persona', Dipendenze),
    s_tag( numero_pratica(_), 'n_pratica', Dipendenze),
    write('   }'), nl,
    true.

s_livello4(Dipendenze) :-
    nl, write('   subgraph {'), nl,
    write('      rank="same";'), nl,
    write('      node [color=orange,shape=circle];'),nl,
    s_tag( soggetto(_,_), 'soggetto', Dipendenze),
    s_tag( curatore(_,_), 'curatore', Dipendenze),
    s_tag( giudice(_,_), 'giudice', Dipendenze),
    s_tag( richiesta_valuta(_,_,_), 'richiesta_valuta', Dipendenze),
    write('   }'), nl,
    true.

s_depends(Dipendenze) :-
    findall((ID1,ID2), (member(ID1, Dipendenze), member(ID2, Dipendenze), kb:depends(ID1, ID2)), ListaDepends),
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

s_tag(Goal, Label, Dipendenze) :-
    findall( ID, (member( ID, Dipendenze), kb:tag(ID, Goal)), ListaTag),
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
