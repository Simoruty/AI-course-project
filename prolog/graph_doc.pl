:- module( graph_doc, [ 
                        graph_doc_all/1
                      , graph_doc/2 
                      ]
).

:- use_module(kb).
:- use_module(lexer).
:- use_module(library(lists)).


graph_doc_all(Path) :-
    %tutti i documenti
    findall(ID, (kb:documento(ID,_)), ListaDoc),
    forall(
        member(IDDoc, ListaDoc),
        (
            graph_doc(IDDoc, Path)
        )
    ),
    true.

graph_doc(IDDoc, Path) :-
    atom_concat(IDDoc, '.dot', NomeFile),
    atom_concat(Path, NomeFile, NomeFileAssoluto),   
    tell(NomeFileAssoluto),
    s_init,    
    s_token(IDDoc),
    s_livello1(IDDoc),
    s_livello2(IDDoc),
    s_livello3(IDDoc),
    s_livello4(IDDoc),
    s_depends(IDDoc),
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

s_token(IDDoc) :- 
    nl, write('   subgraph {'), nl,
    write('      rank="source";'), nl,
    write('      edge [arrowhead=normal];'), nl,
    write('      node [shape=box];'), nl,
    findall((ID,Label), (kb:token(ID,Label), kb:appartiene(ID,IDDoc)), ListaToken),
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
    findall((ID1,ID2), (kb:next(ID1, ID2), kb:token(ID1,_), kb:token(ID2,_), kb:appartiene(ID1,IDDoc)), ListaNextFraToken),
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

s_livello1(IDDoc) :- 
    nl, write('   subgraph {'), nl,
    write('      rank="same";'), nl,
    write('      node [color=red,shape=circle];'),nl,
    s_tag( numero(_), 'numero', IDDoc),
    s_tag( parola(_), 'parola', IDDoc),
    s_tag( newline(_),'newline', IDDoc ),   
    s_tag( euro(_),'euro', IDDoc ),
    s_tag( dollaro(_),'dollaro', IDDoc ),
    s_tag( mail(_),'mail', IDDoc ),
    s_tag( cf(_), 'cod_fiscale', IDDoc ),
    s_tag( separatore_data(_), 'sep_data', IDDoc ),
    s_tag( prefisso(_), 'prefisso', IDDoc ),

    write('   }'), nl,
    true.

s_livello2(IDDoc) :-
    nl, write('   subgraph {'),nl,
    write('      rank="same";'),nl,
    write('      node [color=blue,shape=circle];'),nl,
    s_tag( chiro(_),'chiro', IDDoc ),
    s_tag( totale(_),'totale', IDDoc ),
    s_tag( privilegiato(_),'privilegiato', IDDoc ),
    s_tag( simbolo_soggetto(_),'sym_soggetto', IDDoc ),
    s_tag( simbolo_curatore(_),'sym_curatore', IDDoc ),    
    s_tag( simbolo_giudice(_),'sym_giudice', IDDoc ),
    s_tag( cognome(_), 'cognome', IDDoc ),
    s_tag( nome(_), 'nome', IDDoc ),
    s_tag( valuta(_,_), 'valuta', IDDoc ),
    s_tag( comune(_), 'comune', IDDoc ),
    s_tag( giorno(_), 'giorno', IDDoc ),
    s_tag( mese(_), 'mese', IDDoc ),
    s_tag( anno(_), 'anno', IDDoc ),
    s_tag( tel(_), 'telefono', IDDoc ),
    write('   }'), nl,
    true.

s_livello3(IDDoc) :-
    nl, write('   subgraph {'), nl,
    write('      rank="same";'), nl,
    write('      node [color=green,shape=circle];'),nl,
    s_tag( data(_,_,_), 'data', IDDoc ),
    s_tag( persona(_,_), 'persona', IDDoc ),
    s_tag( numero_pratica(_), 'n_pratica', IDDoc ),
    write('   }'), nl,
    true.


s_livello4(IDDoc) :-
    nl, write('   subgraph {'), nl,
    write('      rank="same";'), nl,
    write('      node [color=orange,shape=circle];'),nl,
    s_tag( soggetto(_,_), 'soggetto', IDDoc ),
    s_tag( curatore(_,_), 'curatore', IDDoc ),
    s_tag( giudice(_,_), 'giudice', IDDoc ),
    s_tag( richiesta_valuta(_,_,_), 'richiesta_valuta', IDDoc ),
    write('   }'), nl,
    true.


s_tag(Goal, Label, IDDoc) :-
    findall( ID, (kb:tag(ID, Goal), kb:appartiene(ID,IDDoc)), ListaTag),
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

s_depends(IDDoc) :-
    findall((ID1,ID2), (kb:depends(ID1, ID2), kb:appartiene(ID1,IDDoc)), ListaDepends),
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
