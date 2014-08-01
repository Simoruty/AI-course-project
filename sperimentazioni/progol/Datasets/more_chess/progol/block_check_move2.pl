:- set(c,3),set(i,1)?
:- modeh(1,block_check_move(+int,+piece,+colour,+pos,+pos))?
:- modeb(*,move_piece(+int,+piece,+colour,+pos,+pos))?
:- modeb(*,check(+int,r(-piece,-colour,-pos),r(-piece,+colour,-pos)))?
:- modeb(1,equal_direction(-pos,+pos,-pos))?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this part of block check attempts to learn when we move a piece
% in the way of a check.

board(1,king,white,pos(d,1)).
board(1,queen,black,pos(d,4)).
board(1,queen,white,pos(e,2)).
board(1,knight,white,pos(c,5)).

block_check_move(1,queen,white,pos(e,2),pos(d,2)).
block_check_move(1,queen,white,pos(e,2),pos(d,3)).
block_check_move(1,knight,white,pos(c,5),pos(d,3)).

:- block_check_move(1,knight,white,pos(c,5),pos(d,2)).
:- block_check_move(1,queen,white,pos(e,2),pos(e,4)).


board(2,king,white,pos(d,1)).
board(2,rook,black,pos(a,2)).
board(2,queen,white,pos(h,2)).

:- block_check_move(2,queen,white,pos(h,2),pos(d,2)).
:- block_check_move(2,queen,white,pos(h,2),pos(g,7)).

board(3,king,white,pos(h,5)).
board(3,bishop,black,pos(d,1)).
board(3,rook,white,pos(e,1)).
board(3,bishop,white,pos(h,1)).
board(3,queen,white,pos(a,4)).

block_check_move(3,queen,white,pos(a,4),pos(g,4)).
block_check_move(3,bishop,white,pos(h,1),pos(f,3)).
block_check_move(3,rook,white,pos(e,1),pos(e,2)).