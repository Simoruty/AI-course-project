:- set(c,2),set(i,1)?
:- modeh(1,xray2k(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos),+pos))?
:- modeb(1,all_pieces(+piece))?
:- modeb(1,xray2(+int,r(+piece,+colour,+pos),r(+piece,+colour,+pos),+pos))?
:- modeb(1,col_equal(+colour,+colour))?

board(1,king,white,pos(d,4)).
board(1,queen,white,pos(f,6)).
board(1,knight,white,pos(f,2)).
board(1,rook,white,pos(b,4)).
board(1,rook,black,pos(f,4)).

xray2k(1,r(queen,white,pos(f,6)),r(rook,black,pos(f,4)),pos(f,3)).
xray2k(1,r(queen,white,pos(f,6)),r(rook,black,pos(f,4)),pos(f,2)).
xray2k(1,r(rook,black,pos(f,4)),r(queen,white,pos(f,6)),pos(f,7)).
xray2k(1,r(queen,white,pos(f,6)),r(knight,white,pos(f,2)),pos(f,1)).
xray2k(1,r(rook,white,pos(b,4)),r(king,white,pos(d,4)),pos(e,4)).
xray2k(1,r(rook,white,pos(b,4)),r(king,white,pos(d,4)),pos(f,4)).

:- xray2k(1,r(queen,white,pos(f,6)),r(rook,black,pos(f,4)),pos(g,4)).
:- xray2k(1,r(rook,black,pos(f,4)),r(king,white,pos(d,4)),pos(c,4)).
:- xray2k(1,r(rook,white,pos(b,4)),r(king,white,pos(d,4)),pos(d,3)).
