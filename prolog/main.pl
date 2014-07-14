:- use_module(kb).
:- use_module(cf).
:- use_module(comune).
:- use_module(data).
:- use_module(mail).
:- use_module(numero_pratica).
:- use_module(persona).
:- use_module(tel).
:- use_module(valuta).
:- use_module(interface).

main :-
    intestazione,
    %write('Inserisci il testo del documento: '),nl,nl,
    %read(Documento),
%    writeKB(Documento), %TODO Forse working memory
    writeKB,   
    tag_default,
    mostra_tag_da_estrarre,
    expandKB,
    resultKB,
%    explainKB,
    true.

intestazione :- 
    write('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'),nl,    
    write('                                                                               '),nl,
    write('████████╗ █████╗  ██████╗  ██████╗ ███████╗██████╗         ██╗██╗   ██╗███████╗'),nl,
    write('╚══██╔══╝██╔══██╗██╔════╝ ██╔════╝ ██╔════╝██╔══██╗        ██║██║   ██║██╔════╝'),nl,
    write('   ██║   ███████║██║  ███╗██║  ███╗█████╗  ██████╔╝        ██║██║   ██║███████╗'),nl,
    write('   ██║   ██╔══██║██║   ██║██║   ██║██╔══╝  ██╔══██╗        ██║██║   ██║╚════██║'),nl,
    write('   ██║   ██║  ██║╚██████╔╝╚██████╔╝███████╗██║  ██║        ██║╚██████╔╝███████║'),nl,
    write('   ╚═╝   ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝        ╚═╝ ╚═════╝ ╚══════╝'),nl,
    write('                                                                               '),nl,
    write('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'),nl,nl.    
    

start :-
    writeKB,
    expandKB,
    true.
