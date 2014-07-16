:- module( valuta, [
                      simbolo_valuta/1
                    , simbolo_valuta/2
                    , allsimbolo_valuta/1
                    , numero/1  
                    , numero/2
                    , allnumero/1
                    , tipo_richiesta/1
                    , tipo_richiesta/2
                    , alltipo_richiesta/1
                    , valuta/2
                    , valuta/3
                    , allvaluta/1
                    , richiesta_valuta/3
                    , richiesta_valuta/4
                    , allrichiesta_valuta/1
                    , risrichiesta_valuta/0
                    , tag_numero/0
                    , tag_richiesta_valuta/0
                   ] 
).

:- use_module(lexer).
:- use_module(kb).

%% Trova la prima tipo_richiesta di richiesta
tipo_richiesta(T) :-
    kb:tag(_, tipo_richiesta(T)).

tipo_richiesta(IDTag, T) :-
    kb:tag(IDTag, tipo_richiesta(T)).

%% Trova il primo numero 
numero(N) :-
    kb:tag(_, numero(N)).

numero(IDTag, N) :-
    kb:tag(IDTag, numero(N)).

%% Trova il primo simbolo di valuta
simbolo_valuta(S) :-
    kb:tag(_, simbolo_valuta(S)).

simbolo_valuta(IDTag, S) :-
    kb:tag(IDTag, simbolo_valuta(S)).

%% Trova la prima valuta
valuta(M,S) :-
    kb:tag(_, valuta(M, S)).

valuta(IDTag, M, S) :-
    kb:tag(IDTag, valuta(M, S)).

%% Trova la prima richiesta di valuta
richiesta_valuta(M,S,T) :-
    kb:tag(_, richiesta_valuta(M,S,T)).

richiesta_valuta(IDTag, M, S, T) :-
    kb:tag(IDTag, richiesta_valuta(M,S,T)).

%% Trova tutte le tipologie di richieste
alltipo_richiesta(ListaTipologie) :-
    findall((IDTag, T) ,kb:tag(IDTag, tipo_richiesta(T)), ListaTipologie).

%% Trova tutti i numeri
allnumero(ListaNumeri) :-
    findall((IDTag, N) ,kb:tag(IDTag, numero(N)), ListaNumeri).

%% Trova tutti i simboli di valuta
allsimbolo_valuta(ListaSimboliValute) :-
    findall((IDTag, S) ,kb:tag(IDTag, simbolo_valuta(S)), ListaSimboliValute).

%% Trova tutte le valute
allvaluta(ListaValute) :-
    findall((IDTag, M, S) ,kb:tag(IDTag, valuta(M,S)), ListaValute).

%% Trova tutte le richieste di valuta
allrichiesta_valuta(ListaRichieste) :-
    findall((IDTag, M, S, T) ,kb:tag(IDTag, richiesta_valuta(M,S,T)), ListaRichieste).

%% Risultati
risrichiesta_valuta :-
    \+kb:vuole(richiesta_valuta), !.
risrichiesta_valuta :-
    allrichiesta_valuta( ListaRichieste ),
    write('Le richieste di valuta trovate sono: '), 
    write( ListaRichieste ).

%% Tagga le richieste di valuta
tag_richiesta_valuta :-
    \+kb:vuole(richiesta_valuta), !.
tag_richiesta_valuta :-
    kb:fatto(richiesta_valuta), !.
tag_richiesta_valuta :-
    tag_valuta,
    tag_tipo_richiesta,
    findall((_,_,_), tag_richiesta_valuta(_,_,_), _),
    asserta(kb:fatto(richiesta_valuta)).

%% Tagga le valute
tag_valuta :-
    kb:fatto(valuta), !.
tag_valuta :-
    tag_simbolo_valuta,
    tag_numero,
    findall((_,_), tag_valuta(_,_), _),
    asserta(kb:fatto(valuta)).

%% Tagga i simboli di valuta
tag_simbolo_valuta :-
    kb:fatto(simbolo_valuta), !.
tag_simbolo_valuta :-
    findall(_, tag_euro(_), _),
    findall(_, tag_dollaro(_), _),
    asserta(kb:fatto(simbolo_valuta)).

%% Tagga i numeri
tag_numero :-
    kb:fatto(numero), !.
tag_numero :-
    findall(_, tag_numero(_), _),
    asserta(kb:fatto(numero)).

%% Tagga le tipologie
tag_tipo_richiesta :-
    kb:fatto(tipo_richiesta), !.
tag_tipo_richiesta :-
    findall(_, tag_chirografario(_), _),
    findall(_, tag_totale(_), _),
    findall(_, tag_privilegiato(_), _),
    asserta(kb:fatto(tipo_richiesta)).

%% Tagga i simboli di valuta
tag_euro(Token) :- 
    kb:token(IDToken, Token),
    euro(Token),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[SIMBOLO VALUTA] Presenza nel documento del simbolo',Token],' ',Spiegazione),
    assertTag(euro(Token), ListaPrecedenti, ListaSuccessivi,Spiegazione, []).

tag_dollaro(Token) :- 
    kb:token(IDToken, Token),
    dollaro(Token),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[SIMBOLO VALUTA] Presenza nel documento del simbolo',Token],' ',Spiegazione),
    assertTag(dollaro(Token), ListaPrecedenti, ListaSuccessivi,Spiegazione, []).


euro('€').
euro('euro').
euro('eur').
dollaro('$').
dollaro('usd').
dollaro('dollar').

%% Tagga i numeri
tag_numero(Num) :- 
    kb:token(IDToken1, Token1),
    atom_is_number(Token1),
    atom_number(Token1, Num),
    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NUMERO] Presenza nel documento del numero',Num],' ',Spiegazione),
    assertTag(numero(Num), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

%% Tagga i numeri con virgola
tag_numero(Num) :- 
    kb:token(IDToken1, Token1),

    atom_concat(_ParteInteraConVirgola, Decimale, Token1),
    atom_concat(ParteIntera, _DecimaleConVirgola, Token1),
    atom_concat(ParteIntera,',',_ParteInteraConVirgola),
    atom_concat(',',Decimale,_DecimaleConVirgola),

    atomic_list_concat([ParteIntera, Decimale],'.', AtomNum),

    atom_number(AtomNum, Num),

    findall( Precedente, kb:next(Precedente, IDToken1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[NUMERO] Presenza nel documento del numero ',ParteIntera,',',Decimale],'',Spiegazione),
    assertTag(numero(Num), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

%% Tagga le tipologie
tag_chirografario(Token) :- 
    kb:token(IDToken, Token),
    chiro(Token),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TIPO_RICHIESTA] Presenza nel documento del termine',Token],' ',Spiegazione),
    assertTag(chiro(Token), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

%% Tagga le tipologie
tag_privilegiato(Token) :- 
    kb:token(IDToken, Token),
    privilegiato(Token),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TIPO_RICHIESTA] Presenza nel documento del termine',Token],' ',Spiegazione),
    assertTag(privilegiato(Token), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

%% Tagga le tipologie
tag_totale(Token) :- 
    kb:token(IDToken, Token),
    totale(Token),
    findall( Precedente, kb:next(Precedente, IDToken), ListaPrecedenti ),
    findall( Successivo, kb:next(IDToken, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[TIPO_RICHIESTA] Presenza nel documento del termine',Token],' ',Spiegazione),
    assertTag(totale(Token), ListaPrecedenti, ListaSuccessivi, Spiegazione, []).

chiro('chirografario').
chiro('chirografaria').
chiro('chirografo').
chiro('chirografa').
chiro('chiro').
chiro('chir').
privilegiato('privilegiato').
privilegiato('privilegiata').
privilegiato('privil').
privilegiato('priv').
totale('totale').
totale('total').
totale('tot').

%% Tagga le valute €
tag_valuta(Moneta, 'euro') :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, euro(Simbolo)),
    kb:next(IDTag1, IDTag2),    
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Presenza nel documento del numero',Moneta,'seguito dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(valuta(Moneta, 'euro'), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

tag_valuta(Moneta, 'euro') :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, euro(Simbolo)),
    kb:next(IDTag2, IDTag1),    
    findall( Precedente, kb:next(Precedente, IDTag2), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Presenza nel documento del numero',Moneta,'preceduto dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(valuta(Moneta, 'euro'), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

%% Tagga le valute $
tag_valuta(Moneta, 'dollaro') :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, dollaro(Simbolo)),
    kb:next(IDTag1, IDTag2),    
    findall( Precedente, kb:next(Precedente, IDTag1), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag2, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Presenza nel documento del numero',Moneta,'seguito dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(valuta(Moneta, 'dollaro'), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).

tag_valuta(Moneta, 'dollaro') :-
    kb:tag(IDTag1, numero(Moneta)),
    kb:tag(IDTag2, dollaro(Simbolo)),
    kb:next(IDTag2, IDTag1),    
    findall( Precedente, kb:next(Precedente, IDTag2), ListaPrecedenti ),
    findall( Successivo, kb:next(IDTag1, Successivo), ListaSuccessivi ),
    atomic_list_concat(['[VALUTA] Presenza nel documento del numero',Moneta,'preceduto dal simbolo',Simbolo],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(valuta(Moneta, 'dollaro'), ListaPrecedenti, ListaSuccessivi, Spiegazione, Dipendenze).


%% Tagga le richieste di valuta
tag_richiesta_valuta(Moneta, Simbolo, 'totale') :-
    kb:tag(IDTag1, totale(Totale)),
    kb:tag(IDTag2, valuta(Moneta, Simbolo)),
    stessa_frase(IDTag1, IDTag2),
    atomic_list_concat(['[RICHIESTA VALUTA] Presenza nella stessa frase della valuta',Moneta,Simbolo,'e del termine',Totale],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(richiesta_valuta(Moneta, Simbolo, 'totale') , Spiegazione, Dipendenze).

tag_richiesta_valuta(Moneta, Simbolo, 'privilegiato') :-
    kb:tag(IDTag1, privilegiato(Priv)),
    kb:tag(IDTag2, valuta(Moneta, Simbolo)),
    stessa_frase(IDTag1, IDTag2),
    atomic_list_concat(['[RICHIESTA VALUTA] Presenza nella stessa frase della valuta',Moneta,Simbolo,'e del termine',Priv],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(richiesta_valuta(Moneta, Simbolo, 'privilegiato') , Spiegazione, Dipendenze).

tag_richiesta_valuta(Moneta, Simbolo, 'chirografario') :-
    kb:tag(IDTag1, chiro(Chiro)),
    kb:tag(IDTag2, valuta(Moneta, Simbolo)),
    stessa_frase(IDTag1, IDTag2),
    atomic_list_concat(['[RICHIESTA VALUTA] Presenza nella stessa frase della valuta',Moneta,Simbolo,'e del termine',Chiro],' ',Spiegazione),
    Dipendenze=[IDTag1, IDTag2],
    assertTag(richiesta_valuta(Moneta, Simbolo, 'chirografario') , Spiegazione, Dipendenze).
