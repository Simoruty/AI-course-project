:- set(c,3),set(i,1)?

:- modeh(1,checknoboard(+int,r(#piece,#colour,pos(+file,+rank)),
		 r(#piece,#colour,pos(+file,+rank))))?
:- modeb(*,board(+int,#piece,#colour,pos(+file,+rank)))?
:- modeb(*,fdiff(+file,+file,#int))?
:- modeb(*,rdist(+rank,+rank,#int))?

board(1,pawn,white,pos(d,4)).
board(1,pawn,white,pos(b,4)).
board(1,king,black,pos(c,5)).
board(1,pawn,white,pos(a,7)).
board(1,king,black,pos(f,4)).
board(1,pawn,white,pos(g,3)).
board(1,pawn,white,pos(b,2)).
board(1,pawn,white,pos(a,4)).

board(1,pawn,black,pos(d,7)).
board(1,pawn,black,pos(b,7)).
board(1,king,white,pos(c,6)).
board(1,pawn,black,pos(h,2)).
board(1,pawn,black,pos(f,7)).
board(1,pawn,black,pos(g,6)).
board(1,king,white,pos(f,5)).
board(1,pawn,black,pos(b,5)).
board(1,pawn,white,pos(h,6)).



checknoboard(1,r(pawn,white,pos(d,4)),r(king,black,pos(c,5))).
checknoboard(1,r(pawn,white,pos(b,4)),r(king,black,pos(c,5))).
checknoboard(1,r(pawn,white,pos(g,3)),r(king,black,pos(f,4))).
checknoboard(1,r(pawn,black,pos(d,7)),r(king,white,pos(c,6))).
checknoboard(1,r(pawn,black,pos(b,7)),r(king,white,pos(c,6))).
checknoboard(1,r(pawn,black,pos(g,6)),r(king,white,pos(f,5))).

:-checknoboard(1,r(pawn,white,pos(a,7)),r(king,black,pos(c,5))).
:-checknoboard(1,r(pawn,white,pos(a,4)),r(king,black,pos(c,5))).
:-checknoboard(1,r(pawn,white,pos(b,2)),r(king,black,pos(c,5))).
:-checknoboard(1,r(pawn,black,pos(h,2)),r(king,white,pos(c,6))).
:-checknoboard(1,r(pawn,black,pos(f,7)),r(king,white,pos(c,6))).
:-checknoboard(1,r(pawn,black,pos(b,5)),r(king,white,pos(c,6))).













































