wordnum(A,[],T) :- word100(A,[],T).
wordnum(A,[],T) :- word1000(A,[],T).
word1000(A,B,T+H) :- thou(A,C,T), word100(C,B,H).
thou([D,thousand|R],R,T*1000) :- digit(D,T).
word100(A,[],H) :- hun(A,[],H).
word100(A,B,H+T) :- hun(A,[and|C],H), tenu(C,B,T).
hun([D,hundred|R],R,H*100) :- digit(D,H).
tenu([D],[],N) :- digit(D,N).
tenu([ten],[],10).
tenu([eleven],[],11).
tenu([twelve],[],12).
tenu([thirteen],[],13).
tenu([fifteen],[],15).
tenu([eighteen],[],18).
tenu([T,D],[],N+M) :- tenmult(T,N), digit(D,M).
digit(one,1).
digit(six,6).
digit(eight,8).
digit(nine,9).
tenmult(twenty,20).
tenmult(fifty,50).
tenmult(sixty,60).
tenmult(seventy,70).
tenmult(eighty,80).
tenmult(ninety,90).
