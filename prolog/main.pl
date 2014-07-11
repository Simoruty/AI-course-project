%:- consult('dataset.pl').

:- use_module(kb).
:- use_module(cf).
:- use_module(comune).
:- use_module(data).
:- use_module(mail).
:- use_module(numero_pratica).
:- use_module(persona).
:- use_module(tel).
:- use_module(valuta).

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

    write('Inserisci il testo del documento: '),nl,nl,
  %  read(Documento),
   % writeKB(Documento), %TODO Forse working memory
    writeKB,   
% request,
    expandKB,
%    explainKB,
    true.

start :-
    writeKB,
    expandKB,
    true.
