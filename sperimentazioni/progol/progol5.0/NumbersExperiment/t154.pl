wordnum(A,[],T) :- word100(A,[],T).
word1000(A,B,T+N) :- thou(A,[and|C],T), tenu(C,B,N).
word100(A,B,H+T) :- hun(A,[and|C],H), tenu(C,B,T).
hun([D,hundred|R],R,H*100) :- digit(D,H).
tenu([D],[],N) :- digit(D,N).
tenu([eleven],[],11).
tenu([twelve],[],12).
tenu([thirteen],[],13).
tenu([fifteen],[],15).
tenu([sixteen],[],16).
tenu([seventeen],[],17).
tenu([eighteen],[],18).
digit(one,1).
digit(three,3).
digit(four,4).
digit(five,5).
digit(six,6).
digit(seven,7).
digit(eight,8).
tenmult(thirty,30).
tenmult(fifty,50).
tenmult(sixty,60).
tenmult(seventy,70).
tenmult(eighty,80).
tenmult(ninety,90).
