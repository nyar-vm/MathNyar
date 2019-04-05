Nyar`Core`If[a,0];
Nyar`Core`If[Not[a],null];
Nyar`Core`If[a,0,1];
Nyar`Core`If[Greater[a,0],null,null];
Nyar`Core`ElseIf[Less[a,0],null,Less[a,1],null];
Nyar`Core`ElseIf[Less[a,1],Set[b,1],Less[a,2],Set[b,2],Less[a,3],Set[b,3],Set[b,4]];
