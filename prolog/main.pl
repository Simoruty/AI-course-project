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
:- use_module(serialize).
:- use_module(graph_doc).
:- use_module(graph_explain).
:- use_module(base).

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
    
main :-
    intestazione,
    write('Inserisci il testo del documento: '),nl,nl,
    read(Documento),
    assertDoc(Documento),
    writeKB,   
    tag_default,
    mostra_tag_da_estrarre,
    expandKB,
    resultKB,
    spiegazioneGUI,
    serialize,
    graph_doc_all,
    graph_explain_all,
    true.

start :-
    consult('prolog/dataset.pl'),
    writeKB,
    tag_default2,
    expandKB,
    serialize,
    graph_doc_all,
    graph_explain_all,
    true.

startJava :-
    writeKB,
    tag_default2,
    expandKB,
    serialize,
    graph_doc_all,
    graph_explain_all,
    true.
