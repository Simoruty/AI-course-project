wordnum(A,[],T) :- tenu(A,[],T).
word1000(A,B,T+N) :- thou(A,[and|C],T), tenu(C,B,N).
word1000(A,B,T+H) :- thou(A,C,T), word100(C,B,H).
thou([D,thousand|R],R,T*1000) :- digit(D,T).
word100(A,[],H) :- hun(A,[],H).
hun([D,hundred|R],R,H*100) :- digit(D,H).
tenu([D],[],N) :- digit(D,N).
tenu([ten],[],10).
tenu([twelve],[],12).
tenu([thirteen],[],13).
tenu([sixteen],[],16).
digit(two,2).
digit(three,3).
digit(six,6).
digit(eight,8).
tenmult(thirty,30).
tenmult(forty,40).
tenmult(fifty,50).
tenmult(eighty,80).
tenmult(ninety,90).
