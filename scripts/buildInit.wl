Needs["PacletManager`"];

If[PacletFind["GitLink", "Internal" -> All] === {},
  PacletInstall["https://www.wolframcloud.com/obj/maxp1/GitLink-2019.11.26.01.paclet"];
];
Needs["GitLink`"];

$repoRoot = FileNameJoin[{DirectoryName[$InputFileName], ".."}];
$buildDirectory = FileNameJoin[{$repoRoot, "Build"}];

deleteBuildDirectory[] := If[FileExistsQ[$buildDirectory], DeleteDirectory[$buildDirectory, DeleteContents -> True]];

copyWLSourceToBuildDirectory[] := With[{
    files = Append[Import[FileNameJoin[{$repoRoot, "Kernel"}]], FileNameJoin[{"..", "PacletInfo.m"}]]},
  If[!FileExistsQ[#], CreateDirectory[#]] & /@ {$buildDirectory, FileNameJoin[{$buildDirectory, "Kernel"}]};
  CopyFile[FileNameJoin[{$repoRoot, "Kernel", #}], FileNameJoin[{$buildDirectory, "Kernel", #}]] & /@ files;
];

$baseVersionPacletMessage = "Will create paclet with the base version number.";
updateVersion::noGitLink = "Could not find GitLink. " <> $baseVersionPacletMessage;

updateVersion[] /; Names["GitLink`*"] =!= {} := Module[{
    versionInformation, gitRepo, minorVersionNumber, versionString, pacletInfoFilename, pacletInfo},
  Check[
    versionInformation = Import[FileNameJoin[{$repoRoot, "scripts", "version.wl"}]];
    gitRepo = GitOpen[$repoRoot];
    minorVersionNumber = Max[0, Length[GitRange[
      gitRepo, Except[versionInformation["Checkpoint"]], GitMergeBase[gitRepo, "HEAD", "master"]]] - 1];
    pacletInfoFilename = FileNameJoin[{$buildDirectory, "PacletInfo.m"}];
    pacletInfo = Association @@ Import[pacletInfoFilename];
    versionString = pacletInfo[Version] <> "." <> ToString[minorVersionNumber];,

    Return[]];

  Export[pacletInfoFilename, Paclet @@ Normal[Join[pacletInfo, <|Version -> versionString|>]]];
  versionString
];

updateVersion[] /; Names["GitLink`*"] === {} := Message[updateVersion::noGitLink];

gitSHA[] /; Names["GitLink`*"] =!= {} := Module[{gitRepo, sha, cleanQ},
  gitRepo = GitOpen[$repoRoot];
  sha = GitSHA[gitRepo, gitRepo["HEAD"]];
  cleanQ = AllTrue[# === {} &]@GitStatus[gitRepo];
  If[cleanQ, sha, sha <> "*"]
]

gitSHA::noGitLink = "Could not find GitLink. $PlanckClockGitSHA will not be available.";

gitSHA[] /; Names["GitLink`*"] === {} := (
  Message[gitSHA::noGitLink];
  Missing["NotAvailable"]
)

updateBuildData[] := With[{
    buildDataFile = File[FileNameJoin[{$buildDirectory, "Kernel", "buildData.m"}]]},
  FileTemplateApply[buildDataFile, buildDataFile];
]

packPaclet[] := PackPaclet[$buildDirectory, $repoRoot]
