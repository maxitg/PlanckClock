<|
  "$PlanckClockGitSHA" -> <|
    "tests" -> {
      VerificationTest[
        StringLength @ $PlanckClockGitSHA,
        40
      ],

      VerificationTest[
        StringMatchQ[$PlanckClockGitSHA, HexadecimalCharacter...]
      ]
    }
  |>,

  "$PlanckClockBuildTime" -> <|
    "tests" -> {
      VerificationTest[
        DateObjectQ @ $PlanckClockBuildTime
      ],

      VerificationTest[
        $PlanckClockBuildTime["TimeZone"],
        "UTC"
      ],

      (* could not be built in the future *)
      VerificationTest[
        $PlanckClockBuildTime < Now
      ],

      (* could not be built before $PlanckClockBuildTime was implemented *)
      VerificationTest[
        DateObject[{2020, 5, 12, 0, 0, 0}, TimeZone -> "UTC"] < $PlanckClockBuildTime
      ]
    }
  |>
|>
