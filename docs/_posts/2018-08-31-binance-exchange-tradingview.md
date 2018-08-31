---
title: Binance exchange trading view
layout: single
author_profile: true
read_time: true
comments: true
share: true
related: true
header:
  overlay_image: "/assets/images/binance-web-interface.jpg"
  caption: 
  overlay_filter: rgba(37, 42, 52, 0.5)
  teaser: "/assets/images/klines-detail.png"
excerpt: "This weekly blog series is a journey into cryptocurrency trading for beginners, this week: 
The Binance Trading View"
classes: wide
category: cryprocurrency trading
tags: beginner cryptocurrency binance trading view 
---

## Binance exchange - Trading view

Below we see the basic binance exchange trading view, we will cover all the parts.

![Binance Trading View Basic]({{ "/assets/images/trading-view-basic.jpg" | relative_url }})

## news area
Here is the small news ticker of Binance news, for a more detailed view click on the [news](https://support.binance.com/hc/en-us/categories/115000056351) link.

Currently, there is a NULS Competition going on with 50,000 NULS giveaway! 

The competition rules are preventing me to participate, but this is interesting anyway, let's select the NULS via the symbols view.

## symbols info
Here you can choose from the trading symbols offered by Binance.
I have picked NULS for the reason shown above and marked it as a favorite, this will enable easy access when I return to the trading view page.

## symbol info
After selecting the NULS symbol, the trading details are shown. 
I presume that the competition kicked off a 13% + increase in the value during the last 24H.

* I have seen this before with VIB, it can be profitable to keep an eye out for these competitions!

## order book
The order book can be a usable tool, when orders are placed they will turn up here.

The green area of the order book represents the buy orders the red area for sell orders e.g. :
*  first bid/buy entry there is an amount of 39 (NULS) @ 0.00026177 BTC being placed
*  the sell entry is an amount of 760 (NULS) @ 0.00026185 BTC are placed.

It looks that the there are more sell orders than buy orders will the price go down?

To see if I am correct we have to take a look at the chart view.

 * Do you trade with the order book data? please put your experiences/thoughts in the comments section below.

## chart view
Here you can see the price development of the selected symbol.
You can select 'real time' or an interval ranging from 1 minute up to 1 month

When you have selected an interval the so-called candlestick graph is shown, with some imagination you can see the candlewick :-)

The individual candles represent the open(O) price at the beginning of the interval, the close(C) price at the end of the interval 
and the high(H) and low(L) prices.

* <img class="img-left" style="width:40px" alt="binance signup referral" src="/assets/images/green-candle.png"/>  close(C) price greather then (>)  greater than open(O) price, upward trend. 
* <img class="img-left" style="width:40px" alt="binance signup referral" src="/assets/images/red-candle.png"/> close(H) price greather then (>)  greater than open(C) price, downward trend.

In the next post, we will use [Julialang](https://julialang.org/) to identify the interesting candlestick combinations and  how to choose your asset portfolio.

## buy/sell view
In this section of the trading view, orders can be placed.

* a reminder use the money you can afford to lose!

### limit
Limit orders can be executed when you are not online, you define a threshold value when to buy or when to sell. 
There is no guarantee that if the market has reached that specific value that order is filled, depends on your position in the queue (order book)

The limit can be executed immediately if the market conforms to the trade order,

### market

Buy/Sell immediately against market conditions, this requires you to be online and is the fastest way to react on market development.

### stop-limit

This is a variant on the limit and can trigger a limit order when a certain threshold is reached for example:

when the market value >= 0.00026185 place a limit sell order for 0.00026200.

## trade history
All trades currently executed for the specific asset, when switched to your section,
your recent 24H trade history, I use it to determine the sell value for the specific asset

## recent market activity
Notable movements in recent market activity are shown here.

# what's up next?
Next posts I will be determining what to trade based upon data gathered with [Julialang](https://julialang.org/) (small intermediate post how to install Julia coming up).