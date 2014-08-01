:- set(c,2),set(i,1)?
:- modeh(1,equal_direction(+pos,+pos,+pos))?
:- modeb(*,direction(+pos,+pos,-pos))?





% positive examples.

equal_direction(pos(d,4),pos(d,5),pos(d,6)).
equal_direction(pos(d,4),pos(e,5),pos(f,6)).
equal_direction(pos(f,3),pos(d,5),pos(b,7)).
equal_direction(pos(b,7),pos(b,5),pos(b,1)).

% negatives

:- equal_direction(pos(a,1),pos(b,2),pos(b,4)).
:- equal_direction(pos(b,4),pos(b,2),pos(b,6)).
:- equal_direction(pos(d,2),pos(f,4),pos(b,2)).
:- equal_direction(pos(b,2),pos(b,4),pos(b,3)).