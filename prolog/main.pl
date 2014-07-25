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
:- use_module(dotserialize).
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
    assertDoc(Documento), %TODO Forse working memory
    writeKB,   
    tag_default,
    mostra_tag_da_estrarre,
    expandKB,
    resultKB,
    spiegazioneGUI,
    serialize('../var/'),
    dotserialize('../var/'),
    findall(IDTag, kb:tag(IDTag, _), ListaTag),
    forall(member(Tag, ListaTag), (grafo(Tag, '../var/spiegazioni/')) ),
    true.

start :-
    assertadocumenti,
    writeKB,
    tag_default2,
    expandKB,
    serialize('../var/'),
    dotserialize('../var/'),
    findall(IDTag, kb:tag(IDTag, _), ListaTag),
    forall(member(Tag, ListaTag), (grafo(Tag, '../var/spiegazioni/')) ),
    true.

startJava :-
    writeKB,
    tag_default2,
    expandKB,
    serialize('var/'),
    dotserialize('var/'),
    findall(IDTag, kb:tag(IDTag, _), ListaTag),
    forall(member(Tag, ListaTag), (grafo(Tag, 'var/spiegazioni/')) ),
    true.
