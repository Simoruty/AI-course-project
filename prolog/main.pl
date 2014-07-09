%:- use_module(lexer).
%:- use_module(tagger).
%:- use_module(library(lists)).
%:- consult('dataset.pl').

:- use_module(conoscenza).
:- use_module(data).
:- use_module(cf).
:- use_module(comune).
:- use_module(mail).
:- use_module(tel).

main :-
%    write('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'),nl,    
%    write('                                                                               '),nl,
%    write('████████╗ █████╗  ██████╗  ██████╗ ███████╗██████╗         ██╗██╗   ██╗███████╗'),nl,
%    write('╚══██╔══╝██╔══██╗██╔════╝ ██╔════╝ ██╔════╝██╔══██╗        ██║██║   ██║██╔════╝'),nl,
%    write('   ██║   ███████║██║  ███╗██║  ███╗█████╗  ██████╔╝        ██║██║   ██║███████╗'),nl,
%    write('   ██║   ██╔══██║██║   ██║██║   ██║██╔══╝  ██╔══██╗        ██║██║   ██║╚════██║'),nl,
%    write('   ██║   ██║  ██║╚██████╔╝╚██████╔╝███████╗██║  ██║        ██║╚██████╔╝███████║'),nl,
%    write('   ╚═╝   ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝        ╚═╝ ╚═════╝ ╚══════╝'),nl,
%    write('                                                                               '),nl,
%    write('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'),nl,nl,    

%    write('Inserisci il testo del documento: '),nl,nl,
%    read(Documento),
%    to_string(Documento, Stringa), % lets user be free to write atom or strings
%    asserta(documento(Stringa)),

%    extract(ListaTag),
    writeKB. %TODO Forse working memory
%    nl,write('Informazioni estratte: '), nl,nl,
%    write(ListaTag),nl.

%extract( ListaTag ) :-
%    domanda( String ),
%    lexer( String, ListaToken ),
%    tagger( ListaToken,ListaTag ).
