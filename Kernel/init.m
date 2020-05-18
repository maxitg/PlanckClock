Unprotect["PlanckClock`*"];

ClearAll @@ (# <> "*" & /@ Contexts["PlanckClock`*"]);

Get["PlanckClock`Kernel`usageString`"];

SetAttributes[#, {Protected, ReadProtected}] & /@ Evaluate @ Names @ "PlanckClock`*";
