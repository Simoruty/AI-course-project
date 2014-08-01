:- set(c,2),set(i,1)?

:- modeh(1,land_on2(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos)))?
:- modeb(1,board(+int,+piece,+colour,+pos))?
:- modeb(1,move1(+int,+piece,+colour,+pos,+pos))?

board(1,bishop,white,pos(d,4)).
board(1,rook,black,pos(b,6)).
board(1,pawn,white,pos(b,2)).
% pos examples.

land_on2(1,r(bishop,white,pos(d,4)),r(rook,black,pos(b,6))).
land_on2(1,r(bishop,white,pos(d,4)),r(pawn,white,pos(b,2))).
land_on2(1,r(rook,black,pos(b,6)),r(pawn,white,pos(b,2))).

% neg examples.

:- land_on2(1,r(bishop,white,pos(d,4)),r(queen,white,pos(f,6))).
:- land_on2(1,r(pawn,white,pos(b,2)),r(rook,black,pos(b,6))).
:- land_on2(1,r(rook,black,pos(b,6)),r(bishop,white,pos(d,4))).