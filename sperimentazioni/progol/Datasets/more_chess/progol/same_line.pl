:- modeh(1,same_line(+pos,+pos,+pos))?
:- modeb(1,equal_direction(+pos,+pos,+pos))?



% positives

same_line(pos(d,4),pos(f,6),pos(g,7)).
same_line(pos(d,4),pos(g,7),pos(f,6)).
same_line(pos(d,3),pos(d,7),pos(d,5)).
same_line(pos(d,3),pos(d,5),pos(d,7)).
same_line(pos(h,1),pos(f,3),pos(g,2)).

% ngatives

:- same_line(pos(f,6),pos(d,4),pos(g,7)).
:- same_line(pos(d,4),pos(f,6),pos(d,6)).
:- same_line(pos(f,3),pos(h,1),pos(a,8)).