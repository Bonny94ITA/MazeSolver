% Esempio 3 x 3
num_col(10).
num_righe(10).

occupata(pos(0,0)).
%occupata(pos(2,2)).
%occupata(pos(2,3)).
%occupata(pos(3,2)).

iniziale(pos(1,1)).
finale(pos(10,10)).

applicabile(nord,pos(R,C)) :-  R>1, R1 is R-1, \+ occupata(pos(R1,C)).
applicabile(sud,pos(R,C)) :-  num_righe(NR), R<NR, R1 is R+1, \+ occupata(pos(R1,C)).
applicabile(ovest,pos(R,C)) :-  C>1, C1 is C-1, \+ occupata(pos(R,C1)).
applicabile(est,pos(R,C)) :-  num_col(NC), C<NC, C1 is C+1, \+ occupata(pos(R,C1)).

trasforma(est,pos(R,C),pos(R,C1)) :- C1 is C+1. 
trasforma(ovest,pos(R,C),pos(R,C1)) :- C1 is C-1. 
trasforma(sud,pos(R,C),pos(R1,C)) :- R1 is R+1. 
trasforma(nord,pos(R,C),pos(R1,C)) :- R1 is R-1.

f(G,Sum):-
	sum(G, 0, Sum).
poly_sum([(5,3), (1,2)], [(1,3)], Sum).