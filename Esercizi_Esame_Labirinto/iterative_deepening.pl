%Labirinti
%Esempio 10 x 10
num_col(10).
num_righe(10).

%occupata(pos(1,5)).
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

/*
%Esempio 3 x 3
num_col(3).
num_righe(3).

occupata(pos(0,0)).
%occupata(pos(2,2)).
%occupata(pos(2,3)).
%occupata(pos(3,2)).

iniziale(pos(1,1)).
finale(pos(3,3)).
*/

/********************************************/

%Check sull'applicabilità della mossa.
applicabile(nord,pos(R,C)) :-  R>1, R1 is R-1, \+ occupata(pos(R1,C)).
applicabile(sud,pos(R,C)) :-  num_righe(NR), R<NR, R1 is R+1, \+ occupata(pos(R1,C)).
applicabile(ovest,pos(R,C)) :-  C>1, C1 is C-1, \+ occupata(pos(R,C1)).
applicabile(est,pos(R,C)) :-  num_col(NC), C<NC, C1 is C+1, \+ occupata(pos(R,C1)).

%Esecuzione dell'azione se applicabile.
trasforma(est,pos(R,C),pos(R,C1)) :- C1 is C+1. 
trasforma(ovest,pos(R,C),pos(R,C1)) :- C1 is C-1. 
trasforma(sud,pos(R,C),pos(R1,C)) :- R1 is R+1. 
trasforma(nord,pos(R,C),pos(R1,C)) :- R1 is R-1.

/********************************************/

%depthSearch(Soluzione)
depthSearch(Soluzione):-
    iniziale(S),
    dfs(S,Soluzione,[S]).

%dfs(S,Soluzione,Visitati)
dfs(S,[],_):-finale(S).
dfs(S,[Az|SequenzaAzioni],Visitati):-
    applicabile(Az,S),
    trasforma(Az,S,S_Nuovo),
    \+member(S_Nuovo,Visitati),
    dfs(S_Nuovo,SequenzaAzioni,[S_Nuovo|Visitati]).

/********************************************/

%iterativeDeepeningSearch(Soluzione,GrandezzaLabX,GrandezzaLabY)
iterativeDeepeningSearch(Soluzione,GrandezzaLabX,GrandezzaLabY):-
	GrandezzaLab is GrandezzaLabX * GrandezzaLabY,
    iterativeDeepeningHelper(Soluzione,1,1,GrandezzaLab).

%iterativeDeepeningHelper(Soluzione,Limite,GrandezzaLab)
iterativeDeepeningHelper(Soluzione,Limite,Altezza,GrandezzaLab):-
	Limite =< GrandezzaLab,
    depthLimitSearch(Soluzione,Limite,Altezza).

%iterativeDeepeningHelper(Soluzione,Limite,GrandezzaLab)
iterativeDeepeningHelper(Soluzione,Limite,Altezza,GrandezzaLab):-
	Limite =< GrandezzaLab,
	%print(" " + Altezza + " "),
	NuovaAltezza is Altezza + 1,
    NuovoLimite is Limite + 1,
    iterativeDeepeningHelper(Soluzione,NuovoLimite,NuovaAltezza,GrandezzaLab).

%depthLimitSearch(Soluzione,Soglia,Altezza)
depthLimitSearch(Soluzione,Soglia,Altezza):-
    iniziale(S),
    dfsAux(S,Soluzione,[S],Soglia,Altezza).

%dfsAux(S,ListaAzioni,Visitati,Soglia,Altezza)
dfsAux(S,[],_,_,Altezza):- finale(S), write(Altezza).
dfsAux(S,[Azione|AzioniTail],Visitati,Soglia,Altezza):-
    Soglia > 0,   
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovaSoglia is Soglia - 1,
    dfsAux(SNuovo,AzioniTail,[SNuovo|Visitati],NuovaSoglia,Altezza).