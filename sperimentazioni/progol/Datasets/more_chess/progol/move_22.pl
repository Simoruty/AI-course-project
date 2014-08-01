:- set(c,2),set(i,1)?

:- modeh(1,move2(+int,#piece,+colour,+pos,+pos))?
:- modeb(1,move2pawn(+int,#piece,+colour,+pos,+pos))?
:- modeb(*,attack2(+int,r(#piece,+colour,+pos),r(-piece,-colour,+pos)))?


board(1,pawn,white,pos(d,2)).
board(1,rook,black,pos(a,4)).
board(1,pawn,white,pos(b,3)).
board(1,queen,white,pos(c,4)).

board(1,pawn,black,pos(g,6)).
board(1,rook,white,pos(f,5)).
board(1,rook,white,pos(g,5)).




move2(1,pawn,white,pos(d,2),pos(d,3)).
move2(1,pawn,white,pos(d,2),pos(d,4)).
move2(1,pawn,white,pos(b,3),pos(a,4)).
move2(1,pawn,black,pos(g,6),pos(f,5)).



:- move2(1,pawn,white,pos(d,5),pos(d,6)).
:- move2(1,pawn,white,pos(d,2),pos(h,2)).
:- move2(1,rook,black,pos(a,4),pos(a,6)).
:- move2(1,pawn,white,pos(b,3),pos(c,4)).
:- move2(1,pawn,black,pos(g,6),pos(g,5)).