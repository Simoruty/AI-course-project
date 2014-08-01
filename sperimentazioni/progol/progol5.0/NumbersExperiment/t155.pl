wordnum(A,[],T) :- tenu(A,[],T).
word1000(A,[],T) :- thou(A,[],T).
word1000(A,B,T+N) :- thou(A,[and|C],T), tenu(C,B,N).
word100(A,B,H+T) :- hun(A,[and|C],H), tenu(C,B,T).
hun([D,hundred|R],R,H*100) :- digit(D,H).
tenu([D],[],N) :- digit(D,N).
tenu([eleven],[],11).
tenu([twelve],[],12).
tenu([fifteen],[],15).
tenu([sixteen],[],16).
tenu([eighteen],[],18).
tenu([T,D],[],N+M) :- tenmult(T,N), digit(D,M).
digit(one,1).
digit(two,2).
digit(three,3).
digit(four,4).
digit(six,6).
digit(seven,7).
digit(eight,8).
tenmult(twenty,20).
tenmult(thirty,30).
tenmult(forty,40).
tenmult(fifty,50).
tenmult(sixty,60).
tenmult(ninety,90).
