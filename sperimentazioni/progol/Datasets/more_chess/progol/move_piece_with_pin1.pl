:- set(c,2),set(i,1)?

:- modeh(1,move_piece_with_pin(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,move_piece_check(+int,+piece,+colour,+pos,+pos))?
:- modeb(1,nott(pin(+int,-r,r(+piece,+colour,+pos),-r)))?


board(2,king,white,pos(d,1)).
board(2,queen,white,pos(e,1)).
board(2,queen,black,pos(e,8)).

move_piece_with_pin(2,queen,white,pos(e,1),pos(e,8)).
move_piece_with_pin(2,queen,white,pos(e,1),pos(c,3)).
move_piece_with_pin(2,queen,white,pos(e,1),pos(a,5)).

:- move_piece_with_pin(2,queen,white,pos(e,1),pos(a,1)).


board(3,king,white,pos(d,1)).
board(3,knight,white,pos(d,2)).
board(3,rook,black,pos(d,7)).

:- move_piece_with_pin(3,knight,white,pos(d,2),pos(c,4)).
