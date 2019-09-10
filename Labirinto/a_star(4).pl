/*% Esempio 3 x 3
num_col(3).
num_righe(3).

occupata(pos(0,0)).

iniziale(pos(1,1)).
finale(pos(3,3)).
*/

% Esempio 10 x 10
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


/*% Esempio 100 x 100
num_col(100).
num_righe(100).

occupata(pos(0,0)).

iniziale(pos(1,1)).
finale(pos(100,100)).
*/

%check su applicabilità mossa.
applicabile(nord,pos(R,C)) :- R>1, R1 is R-1, \+ occupata(pos(R1,C)).
applicabile(est,pos(R,C)) :- num_col(NC), C<NC, C1 is C+1, \+ occupata(pos(R,C1)).
applicabile(sud,pos(R,C)) :- num_righe(NR), R<NR, R1 is R+1, \+ occupata(pos(R1,C)).
applicabile(ovest,pos(R,C)) :- C>1, C1 is C-1, \+ occupata(pos(R,C1)).

%Esecuzione dell'azione se applicabile.
trasforma(est,pos(R,C),pos(R,C1)) :-   C1 is C+1.
trasforma(ovest,pos(R,C),pos(R,C1)) :- C1 is C-1.
trasforma(sud,pos(R,C),pos(R1,C)) :-   R1 is R+1.
trasforma(nord,pos(R,C),pos(R1,C)) :-  R1 is R-1.

% stato rappresentato da nodo(F,S, ListaAzioniPerS)
aStar(Soluzione) :-
    iniziale(S),
    fCosto(S, 0, F),
    aStarAux( [nodo(F,S,[], 0) ], [], Soluzione),!.

% aStarAux(CodaNodiDaEsplorare, NodiEspansi, Soluzione)
aStarAux([nodo(_F, S, ListaAzioniPerS, _G)|_], _, ListaAzioniPerS) :- finale(S).
aStarAux([nodo(F, S, ListaAzioniPerS, G)|Frontiera], NodiEspansi, Soluzione) :-
    findall(Az, applicabile(Az, S), ListaAzioniApplicabili),
    generaFigli(nodo(F, S,ListaAzioniPerS, G), ListaAzioniApplicabili, NodiEspansi, ListaFigliS),
    aggiornamentoFrontiera(ListaFigliS, Frontiera, NuovaFrontiera),!,
    %write(NuovaFrontiera),nl,nl,
    aStarAux(NuovaFrontiera, [S|NodiEspansi], Soluzione),!.

% generaFigli(Nodo, ListaAzioniApplicabili, ListaStatiVisitati, Frontiera,ListaNodiFigli)
generaFigli(_, [], _, []).
generaFigli(nodo(F, S,ListaAzioniPerS,G), [Azione|AltreAzioni], ListaStatiVisitati, [nodo(FNuovo, SNuovo, ListaAzioniNuovo ,GNuovo)|AltriFigli]) :-
    trasforma(Azione, S, SNuovo),
    \+member(SNuovo, ListaStatiVisitati),
    gCosto(G,GNuovo),
    fCosto(SNuovo, GNuovo, FNuovo),
    append(ListaAzioniPerS, [Azione], ListaAzioniNuovo),
    generaFigli(nodo(F, S, ListaAzioniPerS, G), AltreAzioni, ListaStatiVisitati, AltriFigli).

generaFigli(Nodo, [_|AltreAzioni], ListaStatiVisitati, ListaNodiFigli) :-
    generaFigli(Nodo, AltreAzioni, ListaStatiVisitati, ListaNodiFigli).

/* * * * * * * * * * INIZIO * * * * * * * * * * *
 * * * * * * * * * * UTILS  * * * * * * * * * * */

 %aggiornamentoFrontiera(ListaFigli,Frontiera, NuovaFrontiera)
 aggiornamentoFrontiera([], FrontieraFinale, FrontieraFinale).
 aggiornamentoFrontiera([Figlio|AltriFigli], Frontiera, NuovaFrontiera) :-
   eliminaDuplicati(Figlio, Frontiera, FrontieraNoDup),
   aggiuntaOrdinataElem(Figlio, FrontieraNoDup, FrontieraNoDupConFiglio),
   aggiornamentoFrontiera(AltriFigli, FrontieraNoDupConFiglio, NuovaFrontiera), !.
 
 aggiornamentoFrontiera([_|AltriFigli], Frontiera, NuovaFrontiera) :-
   aggiornamentoFrontiera(AltriFigli, Frontiera, NuovaFrontiera).

%eliminaDuplicati(Figlio, Frontiera, NuovaFrontiera)
eliminaDuplicati(_, [], []).
eliminaDuplicati(nodo(_,S,_,G), [nodo(_,S1,_,G1)|AltriNodi], AltriNodi) :-
    S == S1,
    G =< G1,!.
eliminaDuplicati(A, [N|RestoFrontiera], [N|RestoNuovaFrontiera]) :-
 eliminaDuplicati(A, RestoFrontiera, RestoNuovaFrontiera).

%aggiuntaOrdinataElem(Figlio, FrontieraSenzaDuplicati, FrontieraFinale),
aggiuntaOrdinataElem(Figlio, [], [Figlio]).
aggiuntaOrdinataElem(nodo(F, S,ListaAzioniPerS,G), [nodo(F1 ,S1, ListaAzioniPerS1, G1)|RestoFrontiera],
                    [nodo(F, S,ListaAzioniPerS,G)|[nodo(F1 ,S1, ListaAzioniPerS1, G1)|RestoFrontiera]]) :-
                    F < F1, !.

aggiuntaOrdinataElem(X, [Y|Resto1], [Y|Resto2]) :-
  aggiuntaOrdinataElem(X, Resto1, Resto2), !.

%fCosto(StatoCorrente,CostoDiG, CostoDiF).
fCosto(Stato, G, F):-
    finale(Goal),
    distanzaManhattan(Stato,Goal,H),
    F is G + H.

%gCosto(CostoCamminoNodoCorrente,CostoCamminoDelFiglioDelNodoCorrente)
gCosto(G,G1) :- G1 is G+1.

%distanzaManhattan(Stato1, Stato2, DistanzaStati_1-2).
distanzaManhattan(pos(X1,Y1),pos(X2,Y2),Distanza) :-
    Distanza is abs(X1-X2) + abs(Y1-Y2).