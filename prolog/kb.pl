:- module( kb, [ stessa_frase/2
                       , token/1
                       , tag/1
                       , writeKB/0
                       , writeKB/1
                       , expandKB/0
                       , lista_parole/1
                       , assertFact/1
                       , assertTag/2
                       , assertTag/4
                       , nextIDTag/1
                       , vicini/2
                       , distanza/3
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
:- use_module(valuta).

lista_parole(ListaParole) :- documento(Doc), lexer(Doc, ListaParole).

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
    findall(X, simbolo_valuta(X), ListaSimboloValuta),
    findall(X, numero(X), ListaNumeri),
    findall(X, tipologia(X), ListaTipologie),
    findall((X,Y), valuta(X, Y), ListaValuta),
    findall((M,S,T), richiesta_valuta(M,S,T), ListaRichieste),
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
    write('DATA: '), write(ListaData),nl,
    write('SIMBOLI VALUTA: '), write(ListaSimboloValuta),nl,
    write('NUMERI: '), write(ListaNumeri),nl,
    write('TIPOLOGIE: '), write(ListaTipologie),nl,
    write('VALUTA: '), write(ListaValuta),nl,
    write('RICHIESTE: '), write(ListaRichieste),nl,
    true.

writeKB :-
%    writeKB("TRIBUNALE CIVILE DI Bari\nAll’Ill.mo Giudice Delegato al fallimento Giovanni Tarantini\nn. 618/2011\nISTANZA DI INSINUAZIONE ALLO STATO PASSIVO\nIl sottoscritto Quercia Luciano elettivamente domiciliato agli effetti del presente atto in via Federico II, 28\nRecapito tel. 080-8989898\nCodice Fiscale: QRCLCN88L01A285K\nindirizzo mail luciano.quercia@gmail.com\nDICHIARA\ndi essere creditore nei confronti della Ditta di cui sopra, della somma dovutagli per prestazioni di lavoro subordinato in qualità di operaio per il periodo dal 25/7/1999 al 12/2/2001. Totale avere 122.50 €. Come da giustificativi allegati.\nPERTANTO CHIEDE\nl’ammissione allo stato passivo della procedura in epigrafe dell’ importo di euro 122.25 chirografo oltre rivalutazione monetaria ed interessi di legge fino alla data di chiusura dello stato passivo e soli interessi legali fino alla liquidazione delle attività mobiliari da quantificarsi in sede di liquidazione,\nlì 9/6/2014\nLuciano Quercia\nSi allegano 1. fattura n.12\nPROCURA SPECIALE\nDelego a rappresentarmi e difendermi in ogni fase, anche di eventuale gravame, del presente giudizio, l’Avv.to Felice Soldano, conferendo loro, sia unitamente che disgiuntamente, ogni potere di legge, compreso quello di rinunciare agli atti ed accettare la rinuncia, conciliare, transigere, quietanzare, incassare somme, farsi sostituire, nominare altri difensori o domiciliatari, chiedere misure cautelari, promuovere procedimenti esecutivi ed atti preliminari ad essi, chiamare in causa terzi, proporre domande riconvenzionali e costituirsi. Eleggo domicilio presso lo studio del suddetto avv. Soldano Felice.").
    writeKB("€ 20.50 440 € in maniera chirografaria\n giovanni simone curatore cataldo quercia\nQRCLCN88L01A285K ciao come stai\nluciano.quercia@gmail.com nato a San Giovanni Rotondo\nciao Corato simonerutigliano@ciao.com\noh\nRTGSMN88T20L109J\nil sottoscritto / a Quercia Luciano\nQuercia Luciano giudice\n").

writeKB(String) :-
    asserta(documento(String)),    
    lista_parole( Lista ),
    writeKB(Lista, 1).

writeKB( [T1|[]], Num ) :-
    atom_number(AtomNum1,Num),
    atom_concat('t',AtomNum1, IDToken1),
    assertz(token(IDToken1, T1)),
    IDEOF is Num+1,
    atom_number(AtomIDEOF,IDEOF),
    atom_concat('t',AtomIDEOF, IDTokenEOF),
    asserta(token('t0', 'BOF')),
    asserta(next('t0', 't1')),
    assertz(token(IDTokenEOF, 'EOF')),
    assertz(next(IDToken1, IDTokenEOF)).

writeKB( [ T1,T2 | Xs ], Num) :-
    atom_number(AtomNum1,Num),
    Temp is Num+1,
    atom_number(AtomNum2,Temp),
    atom_concat('t',AtomNum1, IDToken1),
    atom_concat('t',AtomNum2, IDToken2),
    assertz(token(IDToken1, T1)),
    %assertFact(token(IDToken2, T2)),
    assertz(next(IDToken1, IDToken2)),
    writeKB( [T2|Xs], Temp).

assertFact(Fact):-
    \+( Fact ),
    !,
    assertz(Fact).
assertFact(_).

assertTag(Tag, Spiegazione) :-
    nextIDTag(NextIDTag),
    atom_number(AtomIDTag, NextIDTag),
    atom_concat('tag', AtomIDTag, IDTag),
    assertFact(tag(IDTag, Tag)),
    atomic_list_concat( ['Trovato tag:', IDTag, 'con contenuto: '], ' ', Message),
    write(Message), write(Tag), nl,
    assertFact(spiega(IDTag,Spiegazione)).

assertTag(Tag, ListaPrecedenti, ListaSuccessivi, Spiegazione) :-
    nextIDTag(NextIDTag),
    atom_number(AtomIDTag, NextIDTag),
    atom_concat('tag', AtomIDTag, IDTag),
    assertFact(tag(IDTag, Tag)),
    forall( member( Precedente, ListaPrecedenti ), ( assertFact(next(Precedente, IDTag)) ) ),
    forall( member( Successivo, ListaSuccessivi ), ( assertFact(next(IDTag, Successivo)) ) ),
    atomic_list_concat( ['Trovato tag:', IDTag, 'con contenuto: '], ' ', Message),
    write(Message), write(Tag), nl,
    assertFact(spiega(IDTag,Spiegazione)).


token(IDToken) :- token(IDToken, _).
tag(IDTag) :- tag(IDTag, _).
nextIDTag(ID) :- findall(X, tag(X), List), length(List, Ntag), ID is Ntag.


newline(ID) :- token(ID, '\n').

vicini(ID1, ID2) :- next(ID1, ID2).
vicini(ID1, ID2) :- next(ID2, ID1).

seguente_in_frase(ID1, ID2) :-
    next(ID1, ID2),
    \+newline(ID1),
    \+newline(ID2),
    !.

seguente_in_frase(ID1, ID2) :-
    next(ID1, ID3),
    \+newline(ID1),
    \+newline(ID2),
    \+newline(ID3),
    !,
    seguente_in_frase(ID3,ID2).



%TODO da sistemare
distanza(ID1, ID2, 0) :-
    next(ID1, ID2), !.
distanza(ID1, ID2, Dist) :-
    next(ID1, ID3),
    distanza(ID3,ID2, Temp),
    Dist is Temp+1.


stessa_frase(ID1, ID1).
stessa_frase(ID1, ID2) :-
    seguente_in_frase(ID1,ID2).
stessa_frase(ID1, ID2) :-
    seguente_in_frase(ID2,ID1).
