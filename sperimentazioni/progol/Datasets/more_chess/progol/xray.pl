:- set(c,4),set(i,1)?
:- modeh(1,xray2(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos),+pos))?
:- modeb(1,long_range_piece(+piece))?
:- modeb(1,move1(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,land_on2(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos)))?
:- modeb(1,equal_direction(+pos,+pos,+pos))?

board(1,knight,white,pos(d,4)).
board(1,rook,black,pos(d,1)).
board(1,bishop,white,pos(a,1)).
board(1,queen,white,pos(a,4)).
board(1,pawn,white,pos(g,2)).
board(1,bishop,black,pos(g,3)).

% positives.

xray2(1,r(rook,black,pos(d,1)),r(knight,white,pos(d,4)),pos(d,6)).
xray2(1,r(rook,black,pos(d,1)),r(knight,white,pos(d,4)),pos(d,8)).
xray2(1,r(bishop,white,pos(a,1)),r(knight,white,pos(d,4)),pos(f,6)).
xray2(1,r(bishop,white,pos(a,1)),r(knight,white,pos(d,4)),pos(h,8)).
xray2(1,r(pawn,white,pos(g,2)),r(bishop,black,pos(g,3)),pos(g,4)).

% negatives.

:- xray2(1,r(knight,white,pos(d,4)),r(rook,black,pos(d,1)),pos(h,1)).
:- xray2(1,r(rook,black,pos(d,1)),r(bishop,white,pos(a,1)),pos(a,1)).
:- xray2(1,r(bishop,white,pos(a,1)),r(knight,white,pos(d,4)),pos(d,3)).
:- xray2(1,r(rook,black,pos(d,1)),r(queen,white,pos(f,1)),pos(h,1)).
:- xray2(1,r(bishop,white,pos(a,1)),r(knight,white,pos(d,4)),pos(b,2)).
:- xray2(1,r(bishop,white,pos(a,1)),r(rook,black,pos(d,1)),pos(f,1)).
:- xray2(1,r(rook,black,pos(d,1)),r(knight,white,pos(d,4)),pos(d,2)).
:- xray2(1,r(rook,black,pos(h,1)),r(queen,white,pos(h,4)),pos(h,8)).
:- xray2(1,r(bishop,white,pos(a,1)),r(rook,black,pos(b,2)),pos(c,3)).
:- xray2(1,r(pawn,white,pos(g,2)),r(bishop,black,pos(g,3)),pos(g,5)).