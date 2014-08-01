:- set(c,2),set(i,1)?

:- modeh(1,check(+int,r(#piece,+colour,+pos),r(#piece,+colour,+pos)))?
:- modeb(1,board(+int,#piece,+colour,+pos))?
:- modeb(1,full_attackpawn(+int,r(#piece,+colour,+pos),r(#piece,+colour,+pos)))?

board(1,pawn,white,pos(d,4)).
board(1,king,black,pos(e,5)).
board(1,king,black,pos(e,8)).
board(1,pawn,white,pos(f,4)).

board(1,pawn,white,pos(f,7)).

check(1,r(pawn,white,pos(f,7)),r(king,black,pos(e,8))).
check(1,r(pawn,white,pos(d,4)),r(king,black,pos(e,5))).
check(1,r(pawn,white,pos(f,4)),r(king,black,pos(e,5))).

:- check(1,r(pawn,white,pos(d,4)),r(king,black,pos(e,8))).
:- check(1,r(pawn,white,pos(d,4)),r(king,black,pos(c,5))).
:- check(1,r(pawn,white,pos(f,4)),r(king,black,pos(g,5))).