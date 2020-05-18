#!/usr/bin/env wolframscript

$successQ = True;

(* If any messages are produced, fail with non-zero exit code. *)
Check[
  $repoRoot = DirectoryName[$InputFileName];
  $latestPacletFiles = MaximalBy[
    FileNames[FileNameJoin[{$repoRoot, "PlanckClock-*.paclet"}]], FileInformation[#, "LastModificationDate"] &];
  
  If[Length[$latestPacletFiles] == 0,
    Print[
      "No paclet files PlanckClock-*.paclet were found. ",
      "Run ./build.wls."];
    Exit[1];
  ];

  If[PacletFind["PlanckClock"] =!= {}, PacletUninstall["PlanckClock"]];

  If[PacletObjectQ[PacletInstall[First[$latestPacletFiles], "IgnoreVersion" -> True]],
    Print["Installed. Restart running kernels to complete installation."],
    Print["Install failed."];
    $successQ = False];,

  $successQ = False;
];

Exit[If[$successQ, 0, 1]]
