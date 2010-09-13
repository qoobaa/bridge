module Bridge
  # Number of possible deals in bridge
  DEALS = 53_644_737_765_488_792_839_237_440_000

  # Card values - from A to 2
  CARD_VALUES = %w(A K Q J T 9 8 7 6 5 4 3 2)

  MAJORS = %w(S H)

  MINORS = %w(D C)

  # Trumps
  TRUMPS = MAJORS + MINORS

  # No trump string
  NO_TRUMP = "NT"

  # Array with card strings in the bridge deck (AKQJT98765432, four
  # suits). Contains "SA", "HT", etc.
  DECK = TRUMPS.map do |suit|
    CARD_VALUES.map { |card| suit + card }
  end.flatten

  # Direction strings "N", "E", "S" and "W"
  DIRECTIONS = %w(N E S W)

  # Possible contracts in ascending order. Contains "1C", "6NT", etc.
  CONTRACTS = %w(1 2 3 4 5 6 7).map do |level|
    (TRUMPS.reverse + [NO_TRUMP]).map { |suit| level + suit }
  end.flatten

  # Pass string
  PASS = "PASS"

  # Double string
  DOUBLE = "X"

  # Redouble string
  REDOUBLE = "XX"

  # Modifier bids (double and redouble)
  MODIFIERS = [DOUBLE, REDOUBLE]

  # All possible bids (including contracts, modifiers and pass)
  BIDS = CONTRACTS + MODIFIERS + [PASS]

  # 2 sides
  SIDES = %w{NS EW}

  # All possible vullnerabilites
  VULNERABILITIES = ["NONE", SIDES, "BOTH"].flatten

  class Imp
    # values in array: [not-vulnerable, vulnerable]
    POINTS =
      {
        "20" => [0,    0],
        "21" => [50,   50],
        "22" => [70,   70],
        "23" => [110,  110],
        "24" => [200,  290],
        "25" => [300,  440],
        "26" => [350,  520],
        "27" => [400,  600],
        "28" => [430,  630],
        "29" => [460,  660],
        "30" => [490,  690],
        "31" => [600,  900],
        "32" => [700,  1050],
        "33" => [900,  1350],
        "34" => [1000, 1500],
        "35" => [1100, 1650],
        "36" => [1200, 1800],
        "37" => [1300, 1950],
        "38" => [1300, 1950],
        "39" => [1300, 1950],
        "40" => [1300, 1950]
      }

      IMPS =
        {
          "0...10"      => 0,
          "20...40"     => 1,
          "50...80"     => 2,
          "90...120"    => 3,
          "130...160"   => 4,
          "170...210"   => 5,
          "220...260"   => 6,
          "270...310"   => 7,
          "320...360"   => 8,
          "370...420"   => 9,
          "430...490"   => 10,
          "500...590"   => 11,
          "600...740"   => 12,
          "750...890"   => 13,
          "900...1090"  => 14,
          "1100...1290" => 15,
          "1300...1490" => 16,
          "1500...1740" => 17,
          "1750...1990" => 18,
          "2000...2240" => 19,
          "2250...2490" => 20,
          "2500...2990" => 21,
          "3000...3490" => 22,
          "3500...3990" => 23,
          "4000...7600" => 24
        }
  end
end
