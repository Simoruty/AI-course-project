:- set(c,3),set(i,1)?

:- modeh(1,defend2(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos)))?
:- modeb(1,land_on2(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos)))?

board(1,rook,white,pos(d,1)).
board(1,queen,white,pos(f,3)).
board(1,knight,white,pos(d,3)).
board(1,bishop,white,pos(e,4)).
board(1,queen,black,pos(h,1)).

% pos examples.

defend2(1,r(rook,white,pos(d,1)),r(knight,white,pos(d,3))).
defend2(1,r(queen,white,pos(f,3)),r(knight,white,pos(d,3))).
defend2(1,r(queen,white,pos(f,3)),r(rook,white,pos(d,1))).
defend2(1,r(bishop,white,pos(e,4)),r(queen,white,pos(f,3))).
defend2(1,r(bishop,white,pos(e,4)),r(knight,white,pos(d,3))).
defend2(1,r(queen,white,pos(f,3)),r(bishop,white,pos(e,4))).

% negative examples.

:- defend2(1,r(rook,white,pos(d,1)),r(queen,white,pos(f,3))).
:- defend2(1,r(bishop,white,pos(e,4)),r(rook,white,pos(d,1))).
:- defend2(1,r(queen,white,pos(f,3)),r(queen,black,pos(h,1))).
:- defend2(1,r(rook,white,pos(d,1)),r(queen,black,pos(h,1))).
:- defend2(1,r(knight,white,pos(d,3)),r(queen,white,pos(f,3))).
:- defend2(1,r(knight,white,pos(d,3)),r(rook,white,pos(d,1))).