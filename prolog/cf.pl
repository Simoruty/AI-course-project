:- module( cf, [cf/1] ).

:- use_module(conoscenza).
:- use_module(lexer).

cf(Token) :- token(_, Token), check_cf(Token).

check_cf(Atom) :-
    atom(Atom),
    atom_codes(Atom,String),
    length(String,16),
    String=[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16],
    ascii_char(C1),ascii_char(C2),ascii_char(C3),ascii_char(C4),ascii_char(C5),ascii_char(C6),
    ascii_number(C7),ascii_number(C8),
    ascii_char(C9),
    ascii_number(C10),ascii_number(C11),
    ascii_char(C12),
    ascii_number(C13),ascii_number(C14),ascii_number(C15),
    ascii_char(C16).
