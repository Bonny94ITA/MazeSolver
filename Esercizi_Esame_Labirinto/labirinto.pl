
% Esempio 10 x 10

num_col(10).
num_righe(10).

occupata(pos(2,5)).
occupata(pos(3,5)).
occupata(pos(4,5)).
occupata(pos(5,5)).
occupata(pos(6,5)).
occupata(pos(7,5)).
occupata(pos(7,1)).
occupata(pos(7,2)).
occupata(pos(7,3)).
occupata(pos(7,4)).
occupata(pos(5,7)).
occupata(pos(6,7)).
occupata(pos(7,7)).
occupata(pos(8,7)).
occupata(pos(4,7)).
occupata(pos(4,8)).
occupata(pos(4,9)).
occupata(pos(4,10)).

iniziale(pos(4,2)).

finale(pos(7,9)).



%Check sull'applicabilitdella mossa.
applicabile(nord,pos(R,C)) :-  R>1, R1 is R-1, \+ occupata(pos(R1,C)).
applicabile(sud,pos(R,C)) :-  num_righe(NR), R<NR, R1 is R+1, \+ occupata(pos(R1,C)).
applicabile(ovest,pos(R,C)) :-  C>1, C1 is C-1, \+ occupata(pos(R,C1)).
applicabile(est,pos(R,C)) :-  num_col(NC), C<NC, C1 is C+1, \+ occupata(pos(R,C1)).

%Esecuzione dell'azione se applicabile.
trasforma(est,pos(R,C),pos(R,C1)) :- C1 is C+1. 
trasforma(ovest,pos(R,C),pos(R,C1)) :- C1 is C-1. 
trasforma(sud,pos(R,C),pos(R1,C)) :- R1 is R+1. 
trasforma(nord,pos(R,C),pos(R1,C)) :- R1 is R-1.

profonditaLimitata(MaxDepth, Soluzione):-
   iniziale(S),
   ric_prof_MaxDepth(S, [S], MaxDepth, Soluzione).
ric_prof_MaxDepth(S,_,_,[]):-finale(S),!.
ric_prof_MaxDepth(S, Visitati, MaxDepth, [Azione|AltreAzioni]):-
   MaxDepth > 0,
   applicabile(Azione, S),
   trasforma(Azione, S, SNuovo),
   \+member(SNuovo, Visitati),
   MaxDepth1 is MaxDepth-1,
   ric_prof_MaxDepth(SNuovo,[SNuovo|Visitati], MaxDepth1, AltreAzioni).