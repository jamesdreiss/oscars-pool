## OSCARS POOL

This is a program made with R / ggplot2 that machine processes ballots, winners, and plots standings for your Oscars pool.

Key features (and the reasons for the program's existence, since I wasn't able to find any web based system that offered these things):

* Quickly determine where you and your friends stand in your pool during the ceremony with a multi-layered plot
* Tailor a points system for your pool, e.g. 5 points for correctly picking Best Picture
* Blind ballots- it's no fun when the picks in your pool are totally homogeneous; blind ballots encourage everyone to do a bit of research rather than follow the pack, and this gives you that option
* Create HTML tables of everyone's picks

[Here are the full results and picks](http://www.jamesdreiss.com/oscars_2015.html) from my pool for the 2015 awards, with just the standings plot below.

![Alt text](data/samples/standings_2015.png?raw=true)

How does it work?

1. Send `ballot_2016.txt` to your friends
2. Have them write their name under "name:" duh
3. Have them make their picks by deleting the nominees who they think will lose
4. That's it (i.e. instruct your pool to not otherwise alter the ballot; the `~` and `:` characters, for instance, are needed for parsing)

Once you've received everyone's ballots, place them in `data/completed_ballots` and source `oscars.R`. If desired, alter the number of points per category in `winners.csv`. During the ceremony, update `winners.csv` with the winners in each category (exactly as they're named on the ballot) and the order that they're announced, and then call `Plot(df)` to create the standings plot. Feel free to test with the data included in `samples`

Enjoy!