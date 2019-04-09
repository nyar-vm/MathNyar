(* ::Package:: *)

SetDirectory@NotebookDirectory[];
inline = Import["Nyar.g4", "Text"];
lines = StringSplit[StringDelete[inline, "\n "], {"\n"}];
replace = StringCases[name__ ~~ ":" ~~ pattern__ ~~ ";" :> StringDelete[name, " "] -> "(" <> pattern <> ")"];
rmLine = !Or[
	StringStartsQ[#, "/*"],
	StringStartsQ[#, "//"],
	StringEndsQ[#, "@Inline"]
]&;
out = If[StringContainsQ[#, "//"], First@StringSplit[#, "//"], #]& /@ Select[lines, rmLine];
out[[1]] = "grammar NyarInline;\n// $antlr-format useTab false ;reflowComments false;\n// $antlr-format alignColons hanging;";
rules=Flatten[replace /@ Select[lines, StringEndsQ["@Inline"]]];
output = FixedPoint[StringReplace[#,rules]&,StringRiffle[out, "\n"]]
Export["NyarInline.g4", output, "Text"];