Nyar`Core`If[a,0];
Nyar`Core`If[Not[a],Set[b,1];Set[b,2]];
Nyar`Core`If[a,0,1];
Nyar`Core`If[Greater[a,0],Set[b,1],Set[b,Minus[1]]];
Nyar`Core`ElseIf[Less[a,0],Set[b,0],Less[a,1],Set[b,1]]
Nyar`Core`ElseIf[Less[a,0],Set[b,0],Less[a,1],Set[b,1],Less[a,2],Set[b,2],Less[a,3],Set[b,3],Set[b,4]]
