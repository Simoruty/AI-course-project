:- module(tagger, [tagger/2] ).

:- use_module(syntax).

:- use_module(persona).
:- use_module(mail).
:- use_module(money).
:- use_module(date).
:- use_module(comuni).
:- use_module(codice_fiscale).
:- use_module(numero_telefono).
:- use_module(indirizzo).


tagger(ListToken,ListTagged) :-
    tag_persona(ListToken,A),
    tag_indirizzo(A,A1),
    tag_mail(A1,B),
    tag_money(B,C),
	tag_date(C,D),
    tag_comune(D,E),
    tag_cf(E,F),
    tag_numero_telefono(F,G),
    filter_stopwords(G,ListTagged).
