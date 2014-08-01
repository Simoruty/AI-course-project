:- set(c,1),set(i,1)?

:- modeh(1,move_piece_check(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,block_check_move(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,non_block_move(+int,+piece,+colour,+pos,+pos))?

board(1,king,white,pos(d,1)).
board(1,queen,white,pos(d,2)).
board(1,rook,black,pos(d,8)).
board(1,knight,white,pos(c,4)).

move_piece_check(1,queen,white,pos(d,2),pos(d,4)).
move_piece_check(1,queen,white,pos(d,2),pos(d,8)).
move_piece_check(1,knight,white,pos(c,4),pos(b,6)).
move_piece_check(1,knight,white,pos(c,4),pos(d,6)).
move_piece_check(1,rook,black,pos(d,8),pos(d,2)).

:- move_piece_check(1,knight,white,pos(c,4),pos(d,8)).
:- move_piece_check(1,rook,black,pos(d,8),pos(c,1)).

board(2,king,white,pos(d,1)).
board(2,rook,black,pos(d,4)).
board(2,queen,white,pos(e,3)).
board(2,knight,white,pos(c,4)).

move_piece_check(2,queen,white,pos(e,3),pos(d,4)).
move_piece_check(2,queen,white,pos(e,3),pos(d,3)).
move_piece_check(2,queen,white,pos(e,3),pos(d,2)).

:- move_piece_check(2,knight,white,pos(c,4),pos(b,6)).
:- move_piece_check(2,queen,white,pos(e,3),pos(f,3)).