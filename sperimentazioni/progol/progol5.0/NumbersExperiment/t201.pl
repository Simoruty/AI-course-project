wordnum(A,[],T) :- tenu(A,[],T).
word1000(A,B,T+N) :- thou(A,[and|C],T), tenu(C,B,N).
word100(A,B,H+T) :- hun(A,[and|C],H), tenu(C,B,T).
hun([D,hundred|R],R,H*100) :- digit(D,H).
tenu([D],[],N) :- digit(D,N).
tenu([ten],[],10).
tenu([twelve],[],12).
tenu([fourteen],[],14).
tenu([seventeen],[],17).
digit(four,4).
digit(six,6).
digit(seven,7).
digit(nine,9).
tenmult(twenty,20).
tenmult(thirty,30).
tenmult(forty,40).
tenmult(sixty,60).
tenmult(seventy,70).
tenmult(eighty,80).
tenmult(ninety,90).
