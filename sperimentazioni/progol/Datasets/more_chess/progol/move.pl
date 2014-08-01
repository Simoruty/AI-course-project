:- set(c,2),set(i,1)?

:- modeh(1,move(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,move_piece_with_pin(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,kingmove(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,nott(check(+int,r(-piece,+colour,-pos),-r)))?

board(1,king,white,pos(d,4)).
board(1,rook,black,pos(a,4)).
board(1,queen,white,pos(b,8)).

move(1,king,white,pos(d,4),pos(d,3)).
move(1,king,white,pos(d,4),pos(c,3)).
move(1,king,white,pos(d,4),pos(c,5)).
move(1,queen,white,pos(b,8),pos(b,4)).

:- move(1,queen,white,pos(b,8),pos(b,5)).
:- move(1,rook,black,pos(a,4),pos(c,4)).

board(2,rook,white,pos(a,1)).
board(2,knight,white,pos(c,1)).
board(2,king,white,pos(d,1)).

board(2,king,black,pos(d,8)).
board(2,rook,black,pos(a,8)).
board(2,knight,black,pos(c,8)).

move(2,knight,white,pos(c,1),pos(b,3)).
move(2,rook,white,pos(a,1),pos(a,8)).
move(2,king,white,pos(d,1),pos(e,2)).

:- move2(2,king,white,pos(d,1),pos(f,3)).
:- move2(2,knight,white,pos(c,1),pos(h,5)).


board(3,king,black,pos(d,8)).
board(3,king,white,pos(d,1)).
board(3,rook,black,pos(a,1)).

move(3,king,white,pos(d,1),pos(d,2)).
:- move(3,king,black,pos(d,8),pos(d,7)).

