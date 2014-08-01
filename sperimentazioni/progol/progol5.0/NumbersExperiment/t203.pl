word1000(A,[],T) :- thou(A,[],T).
word1000(A,B,T+H) :- thou(A,C,T), word100(C,B,H).
tenu([D],[],N) :- digit(D,N).
tenu([ten],[],10).
tenu([thirteen],[],13).
tenu([sixteen],[],16).
tenu([seventeen],[],17).
tenu([eighteen],[],18).
digit(one,1).
digit(two,2).
digit(three,3).
digit(four,4).
digit(five,5).
digit(six,6).
tenmult(forty,40).
tenmult(fifty,50).
tenmult(sixty,60).
tenmult(seventy,70).
tenmult(eighty,80).
tenmult(ninety,90).
