wordnum(A,[],T) :- word1000(A,[],T).
thou([D,thousand|R],R,T*1000) :- digit(D,T).
tenu([thirteen],[],13).
tenu([fifteen],[],15).
tenu([sixteen],[],16).
tenu([seventeen],[],17).
tenu([eighteen],[],18).
tenu([nineteen],[],19).
tenu([T],[],N) :- tenmult(T,N).
tenu([T,D],[],N+M) :- tenmult(T,N), digit(D,M).
digit(one,1).
digit(three,3).
digit(five,5).
digit(six,6).
digit(seven,7).
tenmult(thirty,30).
tenmult(forty,40).
tenmult(fifty,50).
tenmult(seventy,70).
tenmult(ninety,90).
