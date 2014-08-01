:- set(c,4),set(i,1)?

:- modeh(1,pin_blocker(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos),
	               r(#piece,+colour,+pos)))?
:- modeb(1,blocked_from_king(+int,r(+piece,+colour,+pos),
	r(#piece,+colour,+pos)))?
:- modeb(1,long_range_piece(+piece))?
:- modeb(1,board(+int,+piece,+colour,+pos))?
:- modeb(1,equal_direction(+pos,+pos,+pos))?

board(1,queen,white,pos(d,1)).
board(1,pawn,white,pos(d,2)).
board(1,rook,white,pos(d,3)).
board(1,bishop,white,pos(a,4)).
board(1,rook,white,pos(g,4)).
board(1,queen,black,pos(h,4)).
board(1,queen,white,pos(d,8)).
board(1,rook,black,pos(d,7)).
board(1,bishop,white,pos(d,6)).
board(1,queen,white,pos(a,7)).
board(1,knight,white,pos(b,6)).


board(1,king,black,pos(d,4)).


pin_blocker(1,r(queen,white,pos(d,1)),r(pawn,white,pos(d,2)),
		r(king,black,pos(d,4))).
pin_blocker(1,r(queen,white,pos(d,1)),r(rook,white,pos(d,3)),
		r(king,black,pos(d,4))).
pin_blocker(1,r(queen,white,pos(d,8)),r(rook,black,pos(d,7)),
		r(king,black,pos(d,4))).
pin_blocker(1,r(queen,white,pos(d,8)),r(bishop,white,pos(d,6)),
		r(king,black,pos(d,4))).
pin_blocker(1,r(queen,white,pos(a,7)),r(knight,white,pos(b,6)),
		r(king,black,pos(d,4))).


:- pin_blocker(1,r(pawn,white,pos(d,2)),r(rook,white,pos(d,3)),
		r(king,black,pos(d,4))).
:- pin_blocker(1,r(rook,white,pos(g,4)),r(knight,black,pos(f,4)),
		r(king,black,pos(d,4))).
:- pin_blocker(1,r(queen,black,pos(h,4)),r(rook,white,pos(g,4)),
		r(king,black,pos(d,4))).
:- pin_blocker(1,r(queen,white,pos(d,1)),r(bishop,white,pos(a,4)),
		r(king,black,pos(d,4))).
:- pin_blocker(1,r(queen,white,pos(d,8)),r(bishop,white,pos(d,5)),
		r(king,black,pos(d,4))).
:- pin_blocker(1,r(queen,white,pos(d,1)),r(queen,black,pos(d,2)),
		r(king,black,pos(d,4))).
:- pin_blocker(1,r(queen,white,pos(a,7)),r(rook,white,pos(b,6)),
		r(king,black,pos(d,4))).

board(2,king,white,pos(g,4)).
board(2,queen,black,pos(a,4)).
board(2,knight,white,pos(b,4)).
board(2,bishop,white,pos(c,4)).
board(2,rook,black,pos(g,8)).
board(2,queen,white,pos(g,5)).

pin_blocker(2,r(queen,black,pos(a,4)),r(knight,white,pos(b,4)),
	r(king,white,pos(g,4))).
pin_blocker(2,r(queen,black,pos(a,4)),r(bishop,white,pos(c,4)),
	r(king,white,pos(g,4))).

pin_blocker(2,r(rook,black,pos(g,8)),r(queen,white,pos(g,5)),
	r(king,white,pos(g,4))).




