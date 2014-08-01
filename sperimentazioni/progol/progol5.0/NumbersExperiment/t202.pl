wordnum(A,[],T) :- tenu(A,[],T).
wordnum(A,[],T) :- word100(A,[],T).
wordnum(A,[],T) :- word1000(A,[],T).
word1000(A,B,T+H) :- thou(A,C,T), word100(C,B,H).
word100(A,[],H) :- hun(A,[],H).
word100(A,B,H+T) :- hun(A,[and|C],H), tenu(C,B,T).
hun([D,hundred|R],R,H*100) :- digit(D,H).
tenu([D],[],N) :- digit(D,N).
tenu([ten],[],10).
tenu([twelve],[],12).
tenu([thirteen],[],13).
tenu([T],[],N) :- tenmult(T,N).
digit(one,1).
digit(four,4).
digit(five,5).
digit(nine,9).
tenmult(forty,40).
tenmult(seventy,70).
tenmult(eighty,80).
tenmult(ninety,90).
