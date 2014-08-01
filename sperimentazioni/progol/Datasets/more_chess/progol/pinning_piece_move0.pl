:- set(c,3),set(i,1)?

:- modeh(1,pinning_piece_move(+int,+piece,+colour,+pos,+pos))?
:- modeb(*,pin(+int,r(-piece,-colour,-pos),r(+piece,+colour,+pos),
			r(-piece,+colour,-pos)))?
:- modeb(1,move_piece_check(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,same_line(-pos,+pos,+pos))?


% I don't understand why putting +'s in the middle of the modb
% pin declaration stops it being included in the most spec clause??

board(1,king,white,pos(d,1)).
board(1,rook,white,pos(d,2)).
board(1,queen,black,pos(d,8)).

board(1,bishop,white,pos(c,2)).
board(1,bishop,black,pos(a,4)).

pinning_piece_move(1,rook,white,pos(d,2),pos(d,8)).
pinning_piece_move(1,bishop,white,pos(c,2),pos(b,3)).

:- pinning_piece_move(1,rook,white,pos(d,2),pos(e,3)).
:- pinning_piece_move(1,bishop,white,pos(c,2),pos(b,1)).

board(1,rook,white,pos(g,7)).

:- pinning_piece_move(1,rook,white,pos(g,7),pos(h,7)).
:- pinning_piece_move(1,rook,white,pos(d,2),pos(a,4)).


board(2,bishop,white,pos(a,1)).
board(2,rook,white,pos(a,8)).
board(2,queen,white,pos(h,1)).

board(2,rook,black,pos(d,8)).
board(2,king,black,pos(h,8)).
board(2,queen,black,pos(h,4)).
board(2,bishop,black,pos(g,7)).

pinning_piece_move(2,rook,black,pos(d,8),pos(b,8)).
pinning_piece_move(2,queen,black,pos(h,4),pos(h,3)).
pinning_piece_move(2,bishop,black,pos(g,7),pos(b,2)).

board(3,pawn,white,pos(d,2)).
board(3,king,white,pos(d,1)).
board(3,queen,black,pos(d,4)).

:- pinning_piece_move(3,pawn,white,pos(d,2),pos(d,4)).


pinning_piece_move(1,rook,white,pos(d,2),pos(d,8)).
pinning_piece_move(1,bishop,white,pos(c,2),pos(a,4)).

pinning_piece_move(2,rook,black,pos(d,8),pos(a,8)).
pinning_piece_move(2,queen,black,pos(h,4),pos(h,1)).
pinning_piece_move(2,bishop,black,pos(g,7),pos(a,1)).