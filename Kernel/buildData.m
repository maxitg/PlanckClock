(* The backtick magic is necessary to prevent it being interpreted as a beginning of a template argument. *)
Package["PlanckClock<*"`"*>"]

PackageExport["$PlanckClockGitSHA"]
PackageExport["$PlanckClockBuildTime"]

$PlanckClockGitSHA::usage = usageString[
  "$PlanckClockGitSHA gives the Git SHA of the repository from which PlanckClock was built."];

$PlanckClockBuildTime::usage = usageString[
  "$PlanckClockBuildTime gives the date object at which PlanckClock was built."];

(* This is a template file. Data is inserted at build time. *)

$PlanckClockGitSHA = <*ToString[gitSHA[], InputForm]*>; (* gitSHA[] is defined in buildInit.wl *)
$PlanckClockBuildTime = <*ToString[DateObject[TimeZone -> "UTC"], InputForm]*>;
