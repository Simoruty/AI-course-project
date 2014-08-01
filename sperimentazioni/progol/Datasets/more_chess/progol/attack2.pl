:- set(c,3),set(i,1)?
:- modeh(1,attack2(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos)))?
:- modeb(1,colneq(+colour,+colour))?
:- modeb(1,attack_piece(+piece))?
:- modeb(1,land_on2(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos)))?

board(1,bishop,white,pos(d,4)).
board(1,rook,black,pos(b,6)).
board(1,queen,white,pos(b,2)).
board(1,pawn,white,pos(b,5)).
board(1,rook,white,pos(d,6)).

% pos examples

attack2(1,r(bishop,white,pos(d,4)),r(rook,black,pos(b,6))).
attack2(1,r(rook,black,pos(b,6)),r(pawn,white,pos(b,5))).
attack2(1,r(rook,black,pos(b,6)),r(rook,white,pos(d,6))).
attack2(1,r(rook,white,pos(d,6)),r(rook,black,pos(b,6))).
attack2(1,r(queen,white,pos(b,2)),r(rook,black,pos(b,6))).
attack2(1,r(rook,black,pos(b,6)),r(queen,white,pos(b,2))).

% neg examples.

:- attack2(1,r(bishop,white,pos(d,4)),r(queen,white,pos(b,2))).
:- attack2(1,r(queen,white,pos(b,2)),r(bishop,white,pos(d,4))).
:- attack2(1,r(pawn,white,pos(b,5)),r(rook,black,pos(b,6))).
:- attack2(1,r(rook,white,pos(d,6)),r(bishop,white,pos(d,4))).
:- attack2(1,r(bishop,white,pos(d,4)),r(queen,black,pos(g,1))).
:- attack2(1,r(bishop,white,pos(c,7)),r(rook,black,pos(b,6))).