:- set(c,2),set(i,1)?

:- modeh(1,move_piece_with_pin(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,move_piece_check(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,nott(pin(+int,-r,r(+piece,+colour,+pos),-r)))?
:- modeb(1,pinning_piece_move(+int,+piece,+colour,+pos,+pos))?

board(1,king,white,pos(d,1)).
board(1,rook,black,pos(d,8)).
board(1,queen,white,pos(d,2)).

move_piece_with_pin(1,queen,white,pos(d,2),pos(d,8)).
move_piece_with_pin(1,queen,white,pos(d,2),pos(d,7)).
move_piece_with_pin(1,queen,white,pos(d,2),pos(d,4)).


:- move_piece_with_pin(1,queen,white,pos(d,2),pos(e,2)).
