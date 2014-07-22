:- module( kb, [ stessa_frase/2
               , writeKB/0
               , expandKB/0
               , explainKB/0
               , resultKB/0
               , assertFact/1
               , assertTag/4
               , assertTag/5
               , assertTag/6
               , nextIDTag/1
               , assertDoc/1
               , assertDocs/1
               , vicini/2
               , spiegaTutto/2
               , assertadocumenti/0
               ]
).
:- consult('dataset.pl').
:- use_module(library(lists)).
:- use_module(lexer).

:- dynamic(fatto/1).
:- dynamic(kb:tag/2).
:- dynamic(kb:spiega/2).
:- dynamic(kb:depends/2).
:- dynamic(kb:next/2).
:- dynamic(kb:token/2).
:- dynamic(kb:vuole/1).
:- dynamic(kb:documento/2).
:- dynamic(kb:appartiene/2).

assertadocumenti:-
    findall(Doc, doc(Doc), ListaDocumenti),
    assertDocs(ListaDocumenti).

assertDoc( Documento ) :-
    to_string(Documento, Stringa),
    nextIDDocument(ID),
    assertFact(kb:documento(ID, Stringa)).

assertDocs([]).
assertDocs([X|Xs]) :-
    to_string(X, Stringa),
    nextIDDocument(ID),
    assertFact(kb:documento(ID, Stringa)),
    assertDocs(Xs).

writeKB :-
    findall((IDDoc, Doc), kb:documento(IDDoc, Doc), ListaDoc),
    forall(member((IDDoc,Doc), ListaDoc), (
        lexer(Doc, ListaParole),

        nextIDToken(IDTokBOF),
        atom_concat(IDDoc, '_BOF', NomeToken),
        assertFact(kb:token(IDTokBOF, NomeToken)),
        assertFact(kb:appartiene(IDTokBOF, IDDoc)),        
        
        tokenizer(IDDoc, ListaParole, IDTokBOF)    
    ) ).

tokenizer( IDDoc, [ Parola | [] ], IDTokenPrecedente ) :-
    nextIDToken(IDTok),
    assertFact(kb:token(IDTok, Parola)),
    assertFact(kb:appartiene(IDTok, IDDoc)),
    assertFact(kb:next(IDTokenPrecedente, IDTok)),

    nextIDToken(IDTokEOF),
    atom_concat(IDDoc, '_EOF', EndToken),
    assertFact(kb:token(IDTokEOF, EndToken)),
    assertFact(kb:appartiene(IDTokEOF, IDDoc)),
    assertFact(kb:next(IDTok, IDTokEOF)).

tokenizer( IDDoc, [ Parola | Lista ], IDTokenPrecedente) :-
    nextIDToken(IDTok),
    assertFact(kb:token(IDTok, Parola)),
    assertFact(kb:appartiene(IDTok, IDDoc)),
    assertFact(kb:next(IDTokenPrecedente, IDTok)),
    tokenizer( IDDoc, Lista, IDTok).

%% Crea la Knowledge Base
expandKB :-
    base:tag_parola,
    base:tag_numero,
    kb:tag_newline,
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

assertFact(Fact):-
    \+( Fact ),
    !,
    assertz(Fact).
assertFact(_).

assertTag(Tag, IDDoc, Spiegazione, Dipendenze) :-
    nextIDTag(IDTag),
    assertFact(kb:tag(IDTag, Tag)),
    assertFact(spiega(IDTag,Spiegazione)),
    assertFact(kb:appartiene(IDTag, IDDoc)),
    forall( member(D,Dipendenze), (assertFact(depends(IDTag, D))) ).

assertTag(Tag, IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione) :-
    assertTag(Tag, IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

assertTag(Tag, IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze) :-
    nextIDTag(IDTag),
    assertFact(kb:tag(IDTag, Tag)),
    forall( member( Precedente, ListaPrecedenti ), ( assertFact(kb:next(Precedente, IDTag)) ) ),
    forall( member( Successivo, ListaSuccessivi ), ( assertFact(kb:next(IDTag, Successivo)) ) ),
%    atomic_list_concat( ['Trovato tag:', IDTag, 'con contenuto: '], ' ', Message),
%    write(Message), write(Tag), nl,
    assertFact(spiega(IDTag,Spiegazione)),
    assertFact(kb:appartiene(IDTag, IDDoc)),
    forall( member(D,Dipendenze), (assertFact(depends(IDTag, D))) ).



spiegaTutto(IDTag, Spiegazione) :-
    findall(X, depends(IDTag, X), Dipendenze),
    length(Dipendenze,0),
    !,
    spiega(IDTag, Spiegazione).
spiegaTutto(IDTag, Spiegazione) :-
    spiega(IDTag, SpiegazioneTag),
    findall(X, depends(IDTag, X), ListaDipendenze),
    spiegaLista(ListaDipendenze, ListaSpiegazioniDipendenze),
    atom_codes(NewLine,[10,13]),
    atomic_list_concat(ListaSpiegazioniDipendenze, NewLine, SpiegazioneDipendenze ),    
    atomic_list_concat([SpiegazioneTag,SpiegazioneDipendenze], NewLine, Spiegazione).    

spiegaLista([],[]).
spiegaLista([D|Ds],[S|Ss]):-
    spiegaTutto(D,S),
    spiegaLista(Ds,Ss).
    

nextIDDocument(IDDoc) :- 
    findall(_, kb:documento(_,_), List), 
    length(List, NDoc),
    atom_number(AtomNDoc, NDoc),
    atom_concat('doc', AtomNDoc, IDDoc).

nextIDTag(IDTag) :- 
    findall(_, kb:tag(_,_), List), 
    length(List, NTag),
    atom_number(AtomNTag, NTag),
    atom_concat('tag', AtomNTag, IDTag).

nextIDToken(IDTok) :- 
    findall(_, kb:token(_,_), List), 
    length(List, NTok),
    atom_number(AtomNTok, NTok),
    atom_concat('t', AtomNTok, IDTok).


newline(ID) :- 
    kb:token(ID, '\n').
newline(ID) :-
    kb:tag(ID, newline(_)).

tag_newline :-
    findall(_, tag_newline(_), _).

tag_newline(IDToken) :- 
    newline(IDToken),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NEW LINE] Presenza nel documento del newline'],' ',Spiegazione),
    kb:appartiene(IDToken, IDDoc),
    assertTag(newline(IDToken), IDDoc, ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

vicini(ID1, ID2) :- 
    kb:next(ID1, ID2), !.
vicini(ID1, ID2) :- 
    kb:next(ID2, ID1), !.

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
%distanza(ID1, ID2, 0) :-
%    kb:next(ID1, ID2), !.
%distanza(ID1, ID2, Dist) :-
%    kb:next(ID1, ID3),
%    distanza(ID3,ID2, Temp),
%    Dist is Temp+1.


stessa_frase(ID1, ID1).
stessa_frase(ID1, ID2) :-
    seguente_in_frase(ID1,ID2).
stessa_frase(ID1, ID2) :-
    seguente_in_frase(ID2,ID1).
