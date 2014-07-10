:- module( kb, [ stessa_frase/2
                       , token/1
                       , tag/1
                       , numero/1
                       , writeKB/0
                       , writeKB/1
                       , expandKB/0
                       , lista_parole/1
                       , assertFact/1
                       , assertTag/1
                       , assertTag/3
                       , nextIDTag/1
                       ]
).

:- use_module(library(lists)).
:- use_module(lexer).
:- use_module(comune).
:- use_module(cf).
:- use_module(persona).
:- use_module(mail).
:- use_module(data).
:- use_module(tel).

lista_parole(ListaParole) :- kb:documento(Doc), lexer(Doc, ListaParole).

expandKB :- 
    findall(X, comune(X), ListaComuni),
    findall(X, cf(X), ListaCF),
    findall(X, cognome(X), ListaCognomi),
    findall(X, nome(X), ListaNomi),
    findall(X, mail(X), ListaMail),
    findall(X, tel(X), ListaTel),
    findall((G,M,A), data(G,M,A), ListaData),
    findall((B,C), persona(B,C), ListaPersone),
    findall((D,E), soggetto(D,E), ListaSoggetti),
    findall((F,G), curatore(F,G), ListaCuratori),
    findall((H,I), giudice(H,I), ListaGiudici),
    
    write('COMUNI: '),write(ListaComuni),nl,
    write('CFs: '),write(ListaCF),nl,
    write('COGNOMI: '),write(ListaCognomi),nl,
    write('NOMI: '), write(ListaNomi),nl,
    write('PERSONE: '), write(ListaPersone),nl,
    write('SOGGETTI: '), write(ListaSoggetti),nl,
    write('CURATORI: '), write(ListaCuratori),nl,
    write('GIUDICI: '), write(ListaGiudici),nl,
    write('MAIL: '), write(ListaMail),nl,
    write('TEL: '), write(ListaTel),nl,
    write('DATA: '), write(ListaData),nl.

writeKB :-
    writeKB("TRIBUNALE CIVILE DI Bari\nAll’Ill.mo Giudice Delegato al fallimento Giovanni Tarantini\nn. 618/2011\nISTANZA DI INSINUAZIONE ALLO STATO PASSIVO\nIl sottoscritto Quercia Luciano elettivamente domiciliato agli effetti del presente atto in via Federico II, 28\nRecapito tel. 080-8989898\nCodice Fiscale: QRCLCN88L01A285K\nDICHIARA\ndi essere creditore nei confronti della Ditta di cui sopra, della somma dovutagli per prestazioni di lavoro subordinato in qualità di operaio per il periodo dal 25/7/1999 al 12/2/2001. Totale avere 122 €. Come da giustificativi allegati.\nPERTANTO CHIEDE\nl’ammissione allo stato passivo della procedura in epigrafe dell’ importo di euro 122 chirografo oltre rivalutazione monetaria ed interessi di legge fino alla data di chiusura dello stato passivo e soli interessi legali fino alla liquidazione delle attività mobiliari da quantificarsi in sede di liquidazione,\nlì 9/6/2014\nLuciano Quercia\nSi allegano 1. fattura n.12\nPROCURA SPECIALE\nDelego a rappresentarmi e difendermi in ogni fase, anche di eventuale gravame, del presente giudizio, l’Avv.to Felice Soldano, conferendo loro, sia unitamente che disgiuntamente, ogni potere di legge, compreso quello di rinunciare agli atti ed accettare la rinuncia, conciliare, transigere, quietanzare, incassare somme, farsi sostituire, nominare altri difensori o domiciliatari, chiedere misure cautelari, promuovere procedimenti esecutivi ed atti preliminari ad essi, chiamare in causa terzi, proporre domande riconvenzionali e costituirsi. Eleggo domicilio presso lo studio del suddetto avv. Soldano Felice.").
%    writeKB("giovanni simone curatore cataldo quercia\nQRCLCN88L01A285K ciao come stai\nluciano.quercia@gmail.com nato a San Giovanni Rotondo\nciao Corato simonerutigliano@ciao.com\noh\nRTGSMN88T20L109J\nil sottoscritto / a Quercia Luciano\nQuercia Luciano giudice\n").

writeKB(String) :-
    asserta(kb:documento(String)),    
    lista_parole( Lista ),
    writeKB(Lista, 1).

writeKB( [T1|[]], Num ) :-
    atom_number(AtomNum1,Num),
    atom_concat('t',AtomNum1, IDToken1),
    assertz(kb:token(IDToken1, T1)),
    IDEOF is Num+1,
    atom_number(AtomIDEOF,IDEOF),
    atom_concat('t',AtomIDEOF, IDTokenEOF),
    asserta(kb:token('t0', 'BOF')),
    asserta(kb:next('t0', 't1')),
    assertz(kb:token(IDTokenEOF, 'EOF')),
    assertz(kb:next(IDToken1, IDTokenEOF)).

writeKB( [ T1,T2 | Xs ], Num) :-
    atom_number(AtomNum1,Num),
    Temp is Num+1,
    atom_number(AtomNum2,Temp),
    atom_concat('t',AtomNum1, IDToken1),
    atom_concat('t',AtomNum2, IDToken2),
    assertz(kb:token(IDToken1, T1)),
    %kb:assertFact(kb:token(IDToken2, T2)),
    assertz(kb:next(IDToken1, IDToken2)),
    writeKB( [T2|Xs], Temp).

kb:assertFact(Fact):-
    \+( Fact ),
    !,
    assertz(Fact).
kb:assertFact(_).

assertTag(Tag) :-
    kb:nextIDTag(NextIDTag),
    atom_number(AtomIDTag, NextIDTag),
    atom_concat('tag', AtomIDTag, IDTag),
    assertFact(kb:tag(IDTag, Tag)),
    atomic_list_concat( ['Trovato tag:', IDTag, 'con contenuto: '], ' ', Message),
    write(Message), write(Tag), nl.

kb:assertTag(Tag, ListaPrecedenti, ListaSuccessivi) :-
    kb:nextIDTag(NextIDTag),
    atom_number(AtomIDTag, NextIDTag),
    atom_concat('tag', AtomIDTag, IDTag),
    kb:assertFact(kb:tag(IDTag, Tag)),
    forall( member( Precedente, ListaPrecedenti ), ( kb:assertFact(kb:next(Precedente, IDTag)) ) ),
    forall( member( Successivo, ListaSuccessivi ), ( kb:assertFact(kb:next(IDTag, Successivo)) ) ),
    atomic_list_concat( ['Trovato tag:', IDTag, 'con contenuto: '], ' ', Message),
    write(Message), write(Tag), nl.


kb:token(IDToken) :- kb:token(IDToken, _).
kb:tag(IDTag) :- kb:tag(IDTag, _).
kb:nextIDTag(ID) :- findall(X, kb:tag(X), List), length(List, Ntag), ID is Ntag.

numero(IDToken) :- kb:token(IDToken, Token), atom_is_number(Token).
newline(ID) :- kb:token(ID, '\n').


seguente_in_frase(ID1, ID2) :-
    kb:next(ID1, ID2),
    \+newline(ID1),
    \+newline(ID2).

seguente_in_frase(ID1, ID2) :-
    kb:next(ID1, ID3),
    \+newline(ID1),
    \+newline(ID2),
    \+newline(ID3),
    seguente_in_frase(ID3,ID2).


stessa_frase(ID1, ID1).
stessa_frase(ID1, ID2) :-
    seguente_in_frase(ID1,ID2).
stessa_frase(ID1, ID2) :-
    seguente_in_frase(ID2,ID1).

%Riflessivo %TODO
%stessa_frase(IDToken1, IDToken2) :- stessa_frase(IDToken2,IDToken1).
