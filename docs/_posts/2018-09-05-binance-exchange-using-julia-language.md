---
title: Binance exchange Julia as a finance tool
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
  teaser: "/assets/images/julia-logo.svg"
excerpt: 'This weekly blog series is a journey into cryptocurrency trading for beginners,
  this week: Using Julia as an anlytics tool'
classes: wide
category: programming julia julialang
tags: beginner cryptocurrency julia jupyter 
---


## Julia lang
We will be using the [Juno IDE](http://junolab.org) (atom + plugin) see post about [installing julia](https://cryptocurrency.ramblings.news/cryprocurrency%20trading/2018/09/03/binance-exchange-installing-julia-language.html) 

In this post we will gather data via the Binance API with Julia.

The question we are asking : 'What currency should I choose to trade in?' 

The following are available to us :

* BTC, Bitcoin [market](https://coinmarketcap.com/currencies/bitcoin/)
* ETH, Ethereum [market](https://coinmarketcap.com/currencies/ethereum/)
* BNB, Binance coin [market](https://coinmarketcap.com/currencies/binance-coin/)
* USDT, Tether [market](https://coinmarketcap.com/currencies/tether/)

We will investigate to total assets / currency and calculate the total traded volume, make a nice graph from the data all with Julia :-)





