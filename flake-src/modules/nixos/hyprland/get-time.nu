def "format date ordinal" [
  --date (-d): datetime
] {

  mut date = if $in != null {
    $in
  } else if ($date != null) {
    $date
  } else {
    date now
  }

  let date = $date | date to-record

  print $date
  let day = $date | get day
  print $day

  let suffix = match $day {
    (4..20, 24..30) => {
      "th"
    }
    _ => {
      ["st", "nd", "rd"] | get (($day - 1) mod 10)
    }
  }

  print $"($day | into string)($suffix)"

  # if (4 <= $day <= 20 || 24 <= $day || $day <= 30)) {
  #   print $day + "th"
  # } else {
  #   print $day + ["st", "nd", "rd"][($day - 1) % 10]
  # }
}

"2025/05/15" | into datetime | format date ordinal;