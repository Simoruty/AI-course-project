:- set(c,2),set(i,1)?

:- modeh(1,full_attackpawn(+int,r(#piece,+colour,+pos),r(#piece,+colour,+pos)))?
:- modeb(1,board(+int,#piece,+colour,+pos))?
:- modeb(1,checknoboard(+int,r(#piece,+colour,+pos),r(#piece,+colour,+pos)))?

board(1,pawn,white,pos(d,4)).
board(1,king,black,pos(c,5)).
board(1,king,black,pos(d,8)).
board(1,pawn,white,pos(c,7)).


board(1,pawn,black,pos(g,6)).
board(1,king,white,pos(f,5)).

full_attackpawn(1,r(pawn,white,pos(d,4)),r(king,black,pos(c,5))).
full_attackpawn(1,r(pawn,black,pos(g,6)),r(king,white,pos(f,5))).
full_attackpawn(1,r(pawn,white,pos(c,7)),r(king,black,pos(d,8))).

:- full_attackpawn(1,r(pawn,white,pos(d,4)),r(king,black,pos(d,8))).
:- full_attackpawn(1,r(pawn,white,pos(b,4)),r(king,black,pos(c,5))).
:- full_attackpawn(1,r(pawn,black,pos(e,6)),r(king,white,pos(f,5))).