:- module( kb, [ stessa_frase/2
               , tag/1
               , tag/2
               , writeKB/0
               , writeKB/1
               , expandKB/0
               , explainKB/0
               , resultKB/0
               , lista_parole/1
               , assertFact/1
               , assertTag/3
               , assertTag/4
               , assertTag/5
               , nextIDTag/1
               , vicini/2
               , distanza/3
               ]
).

:- use_module(library(lists)).
:- use_module(lexer).

:-dynamic(fatto/1).
:-dynamic(kb:tag/2).
:-dynamic(kb:spiega/2).
:-dynamic(kb:dipende_da/2).
:-dynamic(kb:next/2).
:-dynamic(kb:token/2).
:-dynamic(kb:vuole/1).

lista_parole(ListaParole) :- 
    documento(Doc), 
    lexer(Doc, ListaParole).

%% Crea la Knowledge Base
expandKB :-
    comune:tag_comune,
    cf:tag_cf,
    mail:tag_mail,
    tel:tag_tel,    
    persona:tag_persona,    
    data:tag_data,
    persona:tag_soggetto,
    persona:tag_curatore,
    persona:tag_giudice,
    valuta:tag_richiesta_valuta,
    numero_pratica:tag_numero_pratica.

%% Mostra i risultati
resultKB :-
    comune:riscomune,nl,
    cf:riscf,nl,
    mail:rismail,nl,
    tel:ristel,nl,
    persona:rispersona,nl,
    data:risdata,nl,
    persona:riscuratore,nl,
    persona:rissoggetto,nl,
    persona:risgiudice,nl,
    valuta:risrichiesta_valuta,nl,
    numero_pratica:risnumero_pratica.

%% Mostra le spiegazioni
explainKB:-
    findall((Tag,Spiegazione), (kb:tag(IDTag, Tag),spiega(IDTag,Spiegazione)), ListaSpiegazioni),
    write('SPIEGAZIONI: '), 
    write(ListaSpiegazioni),nl.

writeKB :-
    writeKB("TRIBUNALE CIVILE DI Bari\nAll’Ill.mo Giudice Delegato al fallimento Giovanni Tarantini n. 618/2011\nISTANZA DI INSINUAZIONE ALLO STATO PASSIVO\nIl sottoscritto Quercia Luciano elettivamente domiciliato agli effetti del presente atto in via Federico II, 28\nRecapito tel. 080-8989898\nCodice Fiscale: QRCLCN88L01A285K\nindirizzo mail luciano.quercia@gmail.com\nDICHIARA\ndi essere creditore nei confronti della Ditta di cui sopra, della somma dovutagli per prestazioni di lavoro subordinato in qualità di operaio per il periodo dal 25/7/1999 al 12/2/2001. Totale avere 122.50 €. Come da giustificativi allegati.\nPERTANTO CHIEDE\nl’ammissione allo stato passivo della procedura in epigrafe dell’ importo di euro 122.25 chirografo oltre rivalutazione monetaria ed interessi di legge fino alla data di chiusura dello stato passivo e soli interessi legali fino alla liquidazione delle attività mobiliari da quantificarsi in sede di liquidazione,\nlì 9 giugno 2014\nLuciano Quercia\nSi allegano 1. fattura n.12\nPROCURA SPECIALE\nDelego a rappresentarmi e difendermi in ogni fase, anche di eventuale gravame, del presente giudizio, l’Avv.to Felice Soldano, conferendo loro, sia unitamente che disgiuntamente, ogni potere di legge, compreso quello di rinunciare agli atti ed accettare la rinuncia, conciliare, transigere, quietanzare, incassare somme, farsi sostituire, nominare altri difensori o domiciliatari, chiedere misure cautelari, promuovere procedimenti esecutivi ed atti preliminari ad essi, chiamare in causa terzi, proporre domande riconvenzionali e costituirsi. Eleggo domicilio presso lo studio del suddetto avv. Soldano Felice.").

writeKB(Documento) :-
    to_string(Documento, Stringa), % lets user be free to write atom or strings
    asserta(documento(Stringa)),    
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
    assertz(kb:next(IDToken1, IDToken2)),
    writeKB( [T2|Xs], Temp).

assertFact(Fact):-
    \+( Fact ),
    !,
    assertz(Fact).
assertFact(_).

assertTag(Tag, Spiegazione, Dipendenze) :-
    nextIDTag(NextIDTag),
    atom_number(AtomIDTag, NextIDTag),
    atom_concat('tag', AtomIDTag, IDTag),
    assertFact(kb:tag(IDTag, Tag)),
%    atomic_list_concat( ['Trovato tag:', IDTag, 'con contenuto: '], ' ', Message),
%    write(Message), write(Tag), nl,
    assertFact(spiega(IDTag,Spiegazione)),
    forall( member(D,Dipendenze), (assertFact(dipende_da(IDTag, D))) ).

assertTag(Tag, ListaPrecedenti, ListaSuccessivi, Spiegazione) :-
    assertTag(Tag, ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

assertTag(Tag, ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze) :-
    nextIDTag(NextIDTag),
    atom_number(AtomIDTag, NextIDTag),
    atom_concat('tag', AtomIDTag, IDTag),
    assertFact(kb:tag(IDTag, Tag)),
    forall( member( Precedente, ListaPrecedenti ), ( assertFact(kb:next(Precedente, IDTag)) ) ),
    forall( member( Successivo, ListaSuccessivi ), ( assertFact(kb:next(IDTag, Successivo)) ) ),
%    atomic_list_concat( ['Trovato tag:', IDTag, 'con contenuto: '], ' ', Message),
%    write(Message), write(Tag), nl,
    assertFact(spiega(IDTag,Spiegazione)),
    forall( member(D,Dipendenze), (assertFact(dipende_da(IDTag, D))) ).

%TODO LISTA DI SPIEGAZIONI
spiega(IDTag) :-
    spiega(IDTag, Spiegazione),
    write(Spiegazione),nl,
    findall(X, dipende_da(IDTag, X), Dipendenze),
    forall( member(D, Dipendenze), (spiega(D)) ).

token(IDToken) :- 
    kb:token(IDToken, _).

tag(IDTag) :- 
    kb:tag(IDTag, _).

nextIDTag(ID) :- 
    findall(X, kb:tag(X), List), 
    length(List, Ntag), 
    ID is Ntag.


newline(ID) :- 
    kb:token(ID, '\n').

vicini(ID1, ID2) :- 
    kb:next(ID1, ID2).
vicini(ID1, ID2) :- 
    kb:next(ID2, ID1).

seguente_in_frase(ID1, ID2) :-
    kb:next(ID1, ID2),
    \+newline(ID1),
    \+newline(ID2),
    !.

seguente_in_frase(ID1, ID2) :-
    kb:next(ID1, ID3),
    \+newline(ID1),
    \+newline(ID2),
    \+newline(ID3),
    !,
    seguente_in_frase(ID3,ID2).


%TODO da sistemare
distanza(ID1, ID2, 0) :-
    kb:next(ID1, ID2), !.
distanza(ID1, ID2, Dist) :-
    kb:next(ID1, ID3),
    distanza(ID3,ID2, Temp),
    Dist is Temp+1.


stessa_frase(ID1, ID1).
stessa_frase(ID1, ID2) :-
    seguente_in_frase(ID1,ID2).
stessa_frase(ID1, ID2) :-
    seguente_in_frase(ID2,ID1).
