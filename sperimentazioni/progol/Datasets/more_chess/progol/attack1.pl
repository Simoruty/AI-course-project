:- set(c,4),set(i,1)?
:- modeh(1,attack2(+int,r(#piece,#colour,pos(+file,+rank)),r(+piece,#colour,
	pos(+file,+rank))))?
:- modeb(1,board(+int,#piece,#colour,pos(+file,+rank)))?
:- modeb(1,board(+int,+piece,#colour,pos(+file,+rank)))?
:- modeb(1,rdist(+rank,+rank,#int))?
:- modeb(1,fdiff(+file,+file,#int))?



board(1,pawn,black,pos(e,5)).
board(1,pawn,black,pos(b,7)).
board(1,pawn,black,pos(b,2)).
board(1,pawn,black,pos(g,2)).

board(1,rook,white,pos(d,4)).
board(1,knight,white,pos(f,4)).
board(1,queen,white,pos(c,6)).
board(1,bishop,black,pos(a,6)).
board(1,bishop,white,pos(d,3)).
board(1,knight,white,pos(a,1)).
board(1,rook,white,pos(c,1)).
board(1,queen,white,pos(b,1)).
board(1,queen,white,pos(h,1)).

attack2(1,r(pawn,black,pos(e,5)),r(knight,white,pos(f,4))).
attack2(1,r(pawn,black,pos(e,5)),r(rook,white,pos(d,4))).
attack2(1,r(pawn,black,pos(b,2)),r(knight,white,pos(a,1))).
attack2(1,r(pawn,black,pos(b,7)),r(queen,white,pos(c,6))).
attack2(1,r(pawn,black,pos(b,2)),r(rook,white,pos(c,1))).
attack2(1,r(pawn,black,pos(g,2)),r(queen,white,pos(h,1))).

:- attack2(1,r(pawn,black,pos(b,7)),r(knight,white,pos(a,1))).
:- attack2(1,r(pawn,black,pos(c,5)),r(rook,white,pos(d,4))).
:- attack2(1,r(pawn,black,pos(d,5)),r(queen,white,pos(d,4))).
:- attack2(1,r(pawn,black,pos(b,7)),r(bishop,black,pos(a,6))).
:- attack2(1,r(pawn,black,pos(b,2)),r(queen,white,pos(b,1))).
:- attack2(1,r(pawn,black,pos(b,2)),r(rook,white,pos(d,4))).
:- attack2(1,r(pawn,black,pos(g,2)),r(rook,white,pos(f,1))).
