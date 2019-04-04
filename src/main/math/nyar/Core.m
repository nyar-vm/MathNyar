Unprotect@HoldForm;
Format[HoldForm[x_], StandardForm] := With[
	{boxes = MakeBoxes@GeneralUtilities`PrettyForm@x},
	RawBoxes@InterpretationBox[StyleBox[boxes], HoldForm[x]]
]
Protect@HoldForm;
ToExpression[expr, StandardForm, HoldForm]