wordnum(A,[],T) :- tenu(A,[],T).
wordnum(A,[],T) :- word1000(A,[],T).
word1000(A,[],T) :- thou(A,[],T).
word1000(A,B,T+N) :- thou(A,[and|C],T), tenu(C,B,N).
word1000(A,B,T+H) :- thou(A,C,T), word100(C,B,H).
word100(A,[],H) :- hun(A,[],H).
word100(A,B,H+T) :- hun(A,[and|C],H), tenu(C,B,T).
hun([D,hundred|R],R,H*100) :- digit(D,H).
tenu([D],[],N) :- digit(D,N).
tenu([ten],[],10).
tenu([twelve],[],12).
tenu([thirteen],[],13).
tenu([fourteen],[],14).
tenu([nineteen],[],19).
tenu([T],[],N) :- tenmult(T,N).
tenu([T,D],[],N+M) :- tenmult(T,N), digit(D,M).
digit(three,3).
digit(four,4).
digit(five,5).
digit(six,6).
digit(seven,7).
digit(eight,8).
tenmult(twenty,20).
tenmult(thirty,30).
tenmult(forty,40).
tenmult(fifty,50).
tenmult(sixty,60).
tenmult(seventy,70).
tenmult(eighty,80).
tenmult(ninety,90).
