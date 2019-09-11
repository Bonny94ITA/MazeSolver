%depthLimit_search(Soluzione,Soglia)
depthLimit_search(Soluzione,Soglia):-
    iniziale(S),
    dfsAux(S,Soluzione,[S],Soglia).

%dfsAux(S,ListaAzioni,Visitati,Soglia)
dfsAux(S,[],_,_):-finale(S).
dfsAux(S,[Azione|AzioniTail],Visitati,Soglia):-
    Soglia>0,
    applicabile(Azione,S),
    trasforma(Azione,S,SNuovo),
    \+member(SNuovo,Visitati),
    NuovaSoglia is Soglia-1,
    dfsAux(SNuovo,AzioniTail,[SNuovo|Visitati],NuovaSoglia).