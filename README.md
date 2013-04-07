# bridge

Contract bridge utils.

## Bid

## Card

## Deal

## Trick

## Score

You can create Score object passing 3 arguments:
```
Bridge::Score.new("6NTXN", "BOTH", "=")
```

Arguments:

* contract -- String, where first sign is level, second suit (C D H S NT), optional double or redouble (X or XX) and declarer at the end
* vulnerable -- String, ["NONE", "EW", "NS", "BOTH"]
* tricks -- Integer or String, when Integer is passed it's number of tricks taken by declarer side, String can be relative to contract level i.e. "+1", "-2", "="

Methods:

* Score#made? -- Boolean
* Score#result -- Integer, relative to contract level i.e. -1 (one down), 1 (overtrick), 0 (contract made)
* Score#result_string -- String, relative to contract level i.e "+1", "=", "-3"
* Score#points -- Integer, calculated full value

You can also ask for all possible contracts finished with given points:
```
Bridge::Score.with_points(980)
#=> ["1NTX+4v", "2C/DX+4v", "6H/S="]
```

## Points

### Chicago

You can calculate how many IMP points you won by:
```
Bridge::Points::Chicago.new(:hcp => 25, :points => 420, :vulnerable => false).imps
```

Arguments:

* :hcp -- Integer (range between 20 and 40), which means how many honour card points has side
* :vulnerable -- Boolean, side with given hcp is vulnerable?
* :points -- Integer, the result at the end of board (can be calculated by Bridge::Score)

## Copyright

Copyright (c) 2010 Jakub Kuźma. See LICENSE for details.
