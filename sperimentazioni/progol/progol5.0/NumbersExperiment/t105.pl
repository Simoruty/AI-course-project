wordnum(A,[],T) :- tenu(A,[],T).
wordnum(A,[],T) :- word100(A,[],T).
wordnum(A,[],T) :- word1000(A,[],T).
word1000(A,[],T) :- thou(A,[],T).
word1000(A,B,T+N) :- thou(A,[and|C],T), tenu(C,B,N).
word100(A,[],H) :- hun(A,[],H).
word100(A,B,H+T) :- hun(A,[and|C],H), tenu(C,B,T).
tenu([D],[],N) :- digit(D,N).
tenu([twelve],[],12).
tenu([thirteen],[],13).
tenu([fourteen],[],14).
tenu([sixteen],[],16).
tenu([seventeen],[],17).
tenu([eighteen],[],18).
tenu([nineteen],[],19).
tenu([T],[],N) :- tenmult(T,N).
digit(two,2).
digit(three,3).
digit(four,4).
digit(five,5).
digit(six,6).
digit(seven,7).
digit(eight,8).
digit(nine,9).
tenmult(twenty,20).
tenmult(thirty,30).
tenmult(forty,40).
tenmult(fifty,50).
tenmult(sixty,60).
tenmult(ninety,90).
