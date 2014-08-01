:- set(c,4),set(i,1)?
:- modeh(1,attack2(+int,r(#piece,#colour,pos(+file,+rank)),r(+piece,#colour,
	pos(+file,+rank))))?
:- modeb(1,board(+int,#piece,#colour,pos(+file,+rank)))?
:- modeb(1,board(+int,+piece,#colour,pos(+file,+rank)))?
:- modeb(1,rdist(+rank,+rank,#int))?
:- modeb(1,fdiff(+file,+file,#int))?

board(1,pawn,white,pos(d,4)).
board(1,pawn,white,pos(g,2)).
board(1,pawn,white,pos(g,7)).
board(1,pawn,white,pos(b,7)).

board(1,rook,black,pos(e,5)).
board(1,knight,black,pos(c,5)).
board(1,queen,black,pos(f,3)).
board(1,bishop,white,pos(h,3)).
board(1,bishop,black,pos(e,6)).
board(1,knight,black,pos(h,8)).
board(1,rook,black,pos(f,8)).
board(1,queen,black,pos(g,8)).
board(1,queen,black,pos(a,8)).

% pos examples.

attack2(1,r(pawn,white,pos(d,4)),r(knight,black,pos(c,5))).
attack2(1,r(pawn,white,pos(d,4)),r(rook,black,pos(e,5))).
attack2(1,r(pawn,white,pos(g,7)),r(knight,black,pos(h,8))).
attack2(1,r(pawn,white,pos(g,7)),r(rook,black,pos(f,8))).
attack2(1,r(pawn,white,pos(g,2)),r(queen,black,pos(f,3))).
attack2(1,r(pawn,white,pos(b,7)),r(queen,black,pos(a,8))).

% neg examples

:- attack2(1,r(pawn,white,pos(g,2)),r(knight,black,pos(h,8))).
:- attack2(1,r(pawn,white,pos(f,4)),r(rook,black,pos(e,5))).
:- attack2(1,r(pawn,white,pos(e,4)),r(queen,black,pos(e,5))).
:- attack2(1,r(pawn,white,pos(g,2)),r(bishop,white,pos(h,3))).
:- attack2(1,r(pawn,white,pos(g,2)),r(knight,black,pos(c,5))).
:- attack2(1,r(pawn,white,pos(g,7)),r(queen,black,pos(g,8))).
:- attack2(1,r(pawn,white,pos(g,7)),r(rook,black,pos(e,5))).
:- attack2(1,r(pawn,white,pos(b,7)),r(rook,black,pos(c,8))).