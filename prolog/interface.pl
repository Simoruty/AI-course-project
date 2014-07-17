:- module( interface, 
            [ tag_default/0
            , mostra_tag_da_estrarre/0
            , spiegazioneGUI/0
            ] 
).

:- use_module(kb).

tag_default :-
    kb:assertFact(kb:vuole(cf)),
    kb:assertFact(kb:vuole(comune)),
    kb:assertFact(kb:vuole(mail)),
    kb:assertFact(kb:vuole(tel)),
    kb:assertFact(kb:vuole(persona)),
    kb:assertFact(kb:vuole(data)),
    kb:assertFact(kb:vuole(soggetto)),
    kb:assertFact(kb:vuole(curatore)), 
    kb:assertFact(kb:vuole(giudice)),
    kb:assertFact(kb:vuole(richiesta_valuta)),
    kb:assertFact(kb:vuole(numero_pratica)).

check_vuole_numero_pratica('Selezionato') :-
    kb:vuole(numero_pratica), !.
check_vuole_numero_pratica('Non Selezionato').

check_vuole_soggetto('Selezionato') :-
    kb:vuole(soggetto).
check_vuole_soggetto('Non Selezionato').

check_vuole_giudice('Selezionato') :-
    kb:vuole(giudice), !.
check_vuole_giudice('Non Selezionato').

check_vuole_richiesta_valuta('Selezionato') :-
    kb:vuole(richiesta_valuta).
check_vuole_richiesta_valuta('Non Selezionato').

check_vuole_curatore('Selezionato') :-
    kb:vuole(curatore), !.
check_vuole_curatore('Non Selezionato').

check_vuole_comune('Selezionato') :-
    kb:vuole(comune).
check_vuole_comune('Non Selezionato').

check_vuole_cf('Selezionato') :-
    kb:vuole(cf), !.
check_vuole_cf('Non Selezionato').

check_vuole_persona('Selezionato') :-
    kb:vuole(persona).
check_vuole_persona('Non Selezionato').

check_vuole_mail('Selezionato') :-
    kb:vuole(mail), !.
check_vuole_mail('Non Selezionato').

check_vuole_tel('Selezionato') :-
    kb:vuole(tel).
check_vuole_tel('Non Selezionato').

check_vuole_data('Selezionato') :-
    kb:vuole(data), !.
check_vuole_data('Non Selezionato').

tag_da_estrarreGUI :- 
	nl,write('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'),nl,
	nl,write('                           Tag da estrarre                          '),nl,
	nl,write('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'),nl,
	nl,write('  1. numero pratica: '),check_vuole_numero_pratica(N),write(N),
	nl,write('  2. soggetto: '),check_vuole_soggetto(Soggetto),write(Soggetto),
	nl,write('  3. giudice '),check_vuole_giudice(Giudice),write(Giudice),
	nl,write('  4. richiesta valuta: '),check_vuole_richiesta_valuta(Richiesta),write(Richiesta),
	nl,write('  5. curatore: '),check_vuole_curatore(Curatore),write(Curatore),
	nl,write('  6. Comune: '),check_vuole_comune(Comune),write(Comune),
	nl,write('  7. Codice fiscale: '),check_vuole_cf(Cf),write(Cf),
	nl,write('  8. Persona: '),check_vuole_persona(Persona),write(Persona),
	nl,write('  9. Email: '),check_vuole_mail(Mail),write(Mail),
	nl,write('  10. Telefono: '),check_vuole_tel(Tel),write(Tel),
	nl,write('  11. Data: '),check_vuole_data(Data),write(Data), nl,
    nl,write('  12. Seleziona tutto'),nl,
    nl,write('  13. Deseleziona tutto'),nl,nl,
	nl,write('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'),nl,nl.

mostra_tag_da_estrarre :-
    tag_da_estrarreGUI,
	leggi_scelta('Inserire la scelta: (0 per l\'estrazione) ',0,13,Scelta),
    condizione(Scelta).

condizione(0).
condizione(Scelta):-
    seleziona_tag(Scelta), 
    mostra_tag_da_estrarre.

spiegazioneGUI:-
    nl,nl,
    write('Spiegazione di tag? (y/n): '),
    read(Risposta),nl,
    spiegaGUI(Risposta).

spiegaGUI('y'):-
    richiediTagdaSpiegare.
    
spiegaGUI('n'):-
    write('Bye').

spiegaGUI(_):-
    write('Inserire y o n : '),
    spiegazioneGUI.

check_risposta(Risposta,Spiegazioni):-
    kb:spiegaTutto(Risposta,Spiegazioni).

check_risposta(Risposta,'Tag sbagliato').

richiediTagdaSpiegare:-
    write('Inserisci il nome del tag da spiegare: '),
    read(Risposta),
    check_risposta(Risposta,Spiegazioni),
    write(Spiegazioni),
    nl,nl,
    write('Altra spiegazione? (y/n): '),
    read(Risp),
    altraspiegaGUI(Risp).

altraspiegaGUI('y'):-
    richiediTagdaSpiegare.
    
altraspiegaGUI('n'):-
    write('Bye').

altraspiegaGUI(_):-
    write('Inserire y o n : '),
    richiediTagdaSpiegare.
    
%% Inserire numero compreso tra 0 e 13
leggi_scelta(Domanda,Valore1,Valore2,Risposta):-
	write(Domanda),
	repeat,
		write(' ('),write(Valore1),write('-'),write(Valore2),write('): '),
		read(Risposta),
		integer(Risposta),
		Risposta >= Valore1,
		Risposta =< Valore2,
	!.

% Cambia settaggi numero di pratica
seleziona_tag(1) :- 
    kb:vuole(numero_pratica),
    retract(kb:vuole(numero_pratica)).

seleziona_tag(1) :- 
    kb:assertFact(kb:vuole(numero_pratica)).

% Cambia settaggi soggetto
seleziona_tag(2) :- 
    kb:vuole(soggetto),
    retract(kb:vuole(soggetto)).

seleziona_tag(2) :- 
    kb:assertFact(kb:vuole(soggetto)).

% Cambia settaggi giudice
seleziona_tag(3) :- 
    kb:vuole(giudice),
    retract(kb:vuole(giudice)).

seleziona_tag(3) :-
    kb:assertFact(kb:vuole(giudice)).

% Cambia settaggi richiesta di valuta
seleziona_tag(4) :- 
    kb:vuole(richiesta_valuta),
    retract(kb:vuole(richiesta_valuta)).

seleziona_tag(4) :- 
    kb:assertFact(kb:vuole(numero_pratica)).

% Cambia settaggi curatore
seleziona_tag(5) :- 
    kb:vuole(curatore), !,
    retract(kb:vuole(curatore)).

seleziona_tag(5) :- 
    kb:assertFact(kb:vuole(curatore)).

% Cambia settaggi comune
seleziona_tag(6) :- 
    kb:vuole(comune),
    retract(kb:vuole(comune)).

seleziona_tag(6) :- 
    kb:assertFact(kb:vuole(comune)).

% Cambia settaggi codice fiscale
seleziona_tag(7) :- 
    kb:vuole(cf),
    retract(kb:vuole(cf)).

seleziona_tag(7) :- 
    kb:assertFact(kb:vuole(cf)).

% Cambia settaggi persona
seleziona_tag(8) :- 
    kb:vuole(persona),
    retract(kb:vuole(persona)),
    retract(kb:vuole(soggetto)),
    retract(kb:vuole(curatore)),
    retract(kb:vuole(giudice)).

seleziona_tag(8) :- 
    kb:assertFact(kb:vuole(persona)).

% Cambia settaggi mail
seleziona_tag(9) :- 
    kb:vuole(mail),
    retract(kb:vuole(mail)).

seleziona_tag(9) :- 
    kb:assertFact(kb:vuole(mail)).

% Cambia settaggi telefono
seleziona_tag(10) :- 
    kb:vuole(tel),
    retract(kb:vuole(tel)).

seleziona_tag(10) :- 
    kb:assertFact(kb:vuole(tel)).

% Cambia settaggi data
seleziona_tag(11) :- 
    kb:vuole(data),
    retract(kb:vuole(data)).

seleziona_tag(11) :- 
    kb:assertFact(kb:vuole(data)).

% Seleziona tutto
seleziona_tag(12) :- 
    retractall(kb:vuole(_)),
    tag_default.

% Deseleziona tutto
seleziona_tag(13) :- 
    retractall(kb:vuole(_)).
