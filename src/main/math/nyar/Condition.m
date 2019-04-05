Nyar`Core`Bool::usage = "";
Nyar`Core`Bool[True] = True;
Nyar`Core`Bool[False] = False;
Nyar`Core`Bool[n_Integer] := If[n == 0, True, False];

Nyar`Core`If::usage = "";
Nyar`Core`If::cond = "`1` is not compairable.";
Nyar`Core`If[cond_, then_, else_ : Null] := If[
	Nyar`Core`Bool[cond],
	then,
	else,
	Message[Nyar`Core`If::cond, Defer@cond];
]

Nyar`Core`ElseIf::usage = "";
Nyar`Core`ElseIf ~ SetAttributes ~ HoldAll;
Nyar`Core`ElseIf[expr_] := Hold@expr;
Nyar`Core`ElseIf[cond_, then_, exprs___] := ReleaseHold@Nyar`Core`If[cond, Hold@then, Nyar`Core`ElseIf@exprs]
