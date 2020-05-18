<|
  "meta" -> <|
    "init" -> (
      $testsDirectory = If[$TestFileName =!= "",
        FileNameJoin[Most @ FileNameSplit @ $TestFileName],
        FileNameJoin[Append[Most[FileNameSplit[$ScriptCommandLine[[1]]]], "Tests"]]
      ];
    ),
    "tests" -> {
      (* All public symbols have usage message *)

      VerificationTest[
        AllTrue[
          ReleaseHold[{Function[symbol, MessageName[symbol, "usage"], HoldFirst] /@
            ("PackageExports" /. Package`PackageInformation["PlanckClock`"])}],
          StringQ]
      ],

      (* All public symbols have syntax information *)

      VerificationTest[
        AllTrue[
          ReleaseHold[{Function[
              symbol,
              {SymbolName[Unevaluated[symbol]], SyntaxInformation[symbol]},
              HoldFirst] /@
            ("PackageExports" /. Package`PackageInformation["PlanckClock`"])}],
          If[StringStartsQ[#[[1]], "$"], #[[2]] === {}, #[[2]] =!= {}] &]
      ],

      (* Test coverage: all public symbols appear in unit tests *)

      With[{testsDirectory = $testsDirectory}, VerificationTest[
        AllTrue[
          ReleaseHold[{Function[
              symbol,
              SymbolName[Unevaluated[symbol]],
              HoldFirst] /@
            ("PackageExports" /. Package`PackageInformation["PlanckClock`"])}],
          StringContainsQ[StringJoin[Import[
            FileNameJoin[Append[FileNameSplit @ testsDirectory, "*.wlt"]],
            "Text"]], #] &]
      ]]
    },
    "options" -> {
      "Parallel" -> False
    }
  |>
|>
