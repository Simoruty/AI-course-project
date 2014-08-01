:- set(c,2),set(i,1)?
:- modeh(1,block_check_move(+int,+piece,+colour,+pos,+pos))?
:- modeb(*,check(+int,r(-piece,-colour,-pos),r(-piece,+colour,-pos)))?
:- modeb(*,move_piece(+int,+piece,+colour,+pos,+pos))?

%:- modeb(1,equal_direction(+pos,+pos,+pos))?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first we will attempt a block check move where we take the piece 
% that is performing the check.

board(1,king,white,pos(d,1)).
board(1,queen,black,pos(d,3)).
board(1,queen,white,pos(e,2)).

board(2,king,white,pos(d,1)).
board(2,queen,white,pos(e,2)).
board(2,rook,black,pos(f,1)).

board(3,king,white,pos(d,1)).
board(3,rook,black,pos(a,1)).
board(3,queen,white,pos(a,2)).

board(1,knight,white,pos(c,5)).
board(1,knight,white,pos(c,6)).
board(3,bishop,white,pos(c,3)).


block_check_move(1,queen,white,pos(e,2),pos(d,3)).
block_check_move(2,queen,white,pos(e,2),pos(f,1)).
block_check_move(3,queen,white,pos(a,2),pos(a,1)).
block_check_move(1,knight,white,pos(c,5),pos(d,3)).
block_check_move(3,bishop,white,pos(c,3),pos(a,1)).

:- block_check_move(3,queen,white,pos(a,2),pos(d,3)).
:- block_check_move(3,queen,white,pos(a,2),pos(e,3)).
:- block_check_move(1,knight,white,pos(c,6),pos(d,3)).

board(4,king,white,pos(d,1)).
board(4,rook,black,pos(a,2)).
board(4,queen,white,pos(a,1)).

:- block_check_move(4,queen,white,pos(a,1),pos(a,2)).