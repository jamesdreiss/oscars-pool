## OSCARS POOL

This is a program made with R / ggplot2 (v2.2.1) that machine processes ballots, winners, and plots standings for your Oscars pool.

Key features (and the reasons for the program's existence, since I wasn't able to find any web based system that offered these things):

* Quickly determine where you and your friends stand in your pool during the ceremony with a multi-layered plot
* Tailor a points system for your pool, e.g. 5 points for correctly picking Best Picture
* Blind ballots- it's no fun when the picks in your pool are totally homogeneous; blind ballots encourage everyone to do a bit of research rather than follow the pack, and this gives you that option
* Create HTML tables of everyone's picks

[Here are the full results and picks](http://www.jamesdreiss.com/oscars_2018.html) from my pool for the 2018 awards, with just the standings plot below.

![Alt text](data/samples/prev_years/standings_2018.png?raw=true)

How does it work?

1. Send `ballot_%Y.txt` to your friends
2. Have them write their name under "name:" duh
3. Have them make their picks by deleting the nominees who they think will lose
4. That's it (i.e. instruct your pool to not otherwise alter the ballot; the `~` and `:` characters, for instance, are needed for parsing)

A NOTE FROM 2019: I'm now using an HTML form and a backend service to receive picks and export a csv that's read by calling `PicksDF`. So, another option!

The completed ballots (or csv of picks) should be placed in `data/completed_ballots`. If desired, alter the number of points per category in `winners.csv`. During the ceremony, update `winners.csv` with the winners in each category (exactly as they're named on the ballot) and the order that they're announced, then source `oscars.R` and call `Plot(df)` to create the standings plot.

Enjoy!