---
title: Binance exchange applying buy/sell strategies
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
  teaser: "/assets/images/rockbottom.png"
excerpt: 'This weekly blog series is a journey into crypto currency trading for beginners,
  this week: what should I buy ?'
classes: wide
category: programming julia
tags: cryptocurrency julia binance api
---

# Intro
The focus of this weekly blog series will shift to analyzing strategies for buying/selling assets. 
To see whether the strategy pans out or not, a longer validation period is required and the results get posted (bi-)monthly.

So without further ado the first simple strategy.
# Follow the loser strategy, is it a winner?
Every strategy has the intention to buy low and sell high ;-), to spread the risk don't put all your BTC on one asset!
Why not investigate which assets are relatively low compared to their historic minimum and buy those? What comes down must go up?
## strategy implementation

1. we will be using BTC as a base currency, see the previous post
1. select TOP 40 of the highest trade volumes, higher volumes give us a greater chance of buying/selling at market price
1. sort the previous result based upon how close they to the minimum of the last 6 months
1. analyze top 5 of the results and by 50% of the BTC volume if you think that the asset has hit rock bottom (bollinger lower band), apply this for a maximum of 3 to 5 assets depending on the BTC budget. 
1. create a limit order 1,05 of the buy value aiming for roughly a 5% profit, keep in mind for limit order the total value must be > 0.001 BTC
1. when a limit order has been fulfilled, rinse and repeat.


when using a notebook server : [Jupyter NoteBook](https://github.com/DennisRutjes/cryptocurrency.ramblings/blob/master/julia/notebooks/whattotrade.ipynb)
, you will find the code snippets to copy paste in to your favourite IDE (shift-enter to run) at the end of this blog.

steps 1 through 3 are solved using julia :

| Row | symbol   | current  | min      | changeMin | max        | changeMax | trades   | volume     |
    |----:|:---------|---------:|---------:|----------:|-----------:|----------:|---------:|-----------:|
    | 1   | ADABTC   | 1.224e-5 | 1.201e-5 | 1.91507   | 4.19e-5    | 70.7876   | 10002471 | 2.03423e10 |
    | 2   | LENDBTC  | 1.81e-6  | 1.76e-6  | 2.84091   | 1.086e-5   | 83.3333   | 1264351  | 3.55424e9  |
    | 3   | WPRBTC   | 2.7e-6   | 2.61e-6  | 3.44828   | 1.905e-5   | 85.8268   | 1806929  | 2.37858e9  |
    | 4   | SNGLSBTC | 2.93e-6  | 2.83e-6  | 3.53357   | 2.295e-5   | 87.2331   | 1184985  | 2.31718e9  |
    | 5   | GTOBTC   | 1.01e-5  | 9.69e-6  | 4.23117   | 6.95e-5    | 85.4676   | 2831588  | 3.14215e9  |
    

step 4: seems ADABTC is a good candidate, lets go with that one!

![ADABTC Rock bottom]({{ "/assets/images/rockbottom.png" | relative_url }})

steps 5 and 6 will be done during this month, the results will be posted next month or so, see you then!

    
# [Julialang](https://julialang.org/) v1.0 code 


## Installing default packages


```julia
using Pkg;

# packages to install, first time can take a while downloading, please be patient ...
packages=["HTTP","JSON","DataFrames","Plots","StatPlots","PlotThemes","GR","PyPlot","PyCall","LaTeXStrings","Plotly","PlotlyJS"]

for package in packages
    if get(Pkg.installed(),package,-1) == -1
        println(" getting package : ", package)
        Pkg.add(package)
    end
end

using Pkg;
Pkg.add(PackageSpec(url="https://github.com/DennisRutjes/Binance.jl",rev="master"));

ENV["BINANCE_APIKEY"] = "N.A.";
ENV["BINANCE_SECRET"] = "N.A.";

```

    [32m[1m  Updating[22m[39m registry at `~/.julia/registries/General`
    [32m[1m  Updating[22m[39m git-repo `https://github.com/JuliaRegistries/General.git`
    [?25l[2K[?25h[32m[1m  Updating[22m[39m git-repo `https://github.com/DennisRutjes/Binance.jl`
    [?25l[2K[?25h[32m[1m Resolving[22m[39m package versions...
    [32m[1m  Updating[22m[39m `~/.julia/environments/v1.0/Project.toml`
    [90m [no changes][39m
    [32m[1m  Updating[22m[39m `~/.julia/environments/v1.0/Manifest.toml`
    [90m [no changes][39m


## Creating generic functions for Binance API data to DataFrame conversion


```julia
function getBinanceKlineDataframe(symbol, startDateTime, endDateTime ; interval="1m")
    klines = Binance.getKlines(symbol; startDateTime=startDateTime, endDateTime=endDateTime, interval= interval)
    result = hcat(map(z -> map(x -> typeof(x) == String ? parse(Float64, x) : x, z), klines)...)';

    #println(size(result))
    if size(result,2) == 0
        return nothing
    end

    symbolColumnData = map(x -> symbol, collect(1:size(result, 1)));
    df = DataFrame([symbolColumnData, Dates.unix2datetime.(result[:,1]/1000) ,result[:,2],result[:,3],result[:,4],result[:,5],result[:,6],result[:,8],Dates.unix2datetime.(result[:,7] / 1000),result[:,9],result[:,10],result[:,11]], [:symbol,:startDate,:open,:high,:low,:close,:volume,:quoteAVolume, :endDate, :trades, :tbBaseAVolume,:tbQuoteAVolume]);
end

# getFloatValueArray
getFloatValueArray(withKey, withDictArr) = map(dict -> parse(Float32, dict[withKey]) ,withDictArr);
getStringValueArray(withKey, withDictArr) = map(dict -> convert(String, dict[withKey]) ,withDictArr);
```

## Retrieve Market Symbols ending with BTC


```julia
using DataFrames,Statistics, Dates,Binance;

# get 24H tickerdata of all assets
hr24 = Binance.get24HR();
# previous post we determined that BTC currency was the most obvious currency to tade in, most avalable symbols, second highest USDT $ volume.
hr24BTC = Binance.filterOnRegex("BTC\$", hr24)

# all symbols ending with BTC
symbols = sort!(getStringValueArray("symbol", hr24BTC));
```

    ┌ Info: Recompiling stale cache file /Users/drutjes/.julia/compiled/v1.0/Binance/polIw.ji for Binance [840d5de0-b432-11e8-2099-35be2bba8ecc]
    └ @ Base loading.jl:1184


## Retrieve Data with interval 1 month "1M" and 1 minute "1m"


```julia
res = nothing;
# loop through all the symbols en retrieve kline data from binance api
current_datetime = now();
print("retrieving data from binance $current_datetime for :")

for symbol in symbols
    global res
    print(" $symbol")
    dfM = getBinanceKlineDataframe(symbol, now(UTC)-Month(6),now(); interval="1M")
    if(dfM == nothing)
        continue
    end

    # append most recent 5m data, if no trades occured skip this
    dfm = getBinanceKlineDataframe(symbol, now(UTC)-Minute(5),now(UTC); interval="1m")
    if(dfm == nothing)
        continue
    end

    append!(dfM,dfm)

    if res == nothing
        res = dfM;
    else
        append!(res,dfM)
    end
end

alldata = by(res, :symbol, df -> DataFrame(current = df[:close][end], min = minimum(df[:low]), changeMin = (df[:close][end] - minimum(df[:low]))/minimum(df[:low])*100, max =maximum(df[:high]), changeMax = (maximum(df[:high])-df[:close][end]) / maximum(df[:high])*100, trades =sum(df[:trades]),volume =sum(df[:volume])));

```

    retrieving data from binance 2018-09-09T18:53:17.593 for : ADABTC ADXBTC AEBTC AGIBTC AIONBTC AMBBTC APPCBTC ARDRBTC ARKBTC ARNBTC ASTBTC BATBTC BCCBTC BCDBTC BCNBTC BCPTBTC BLZBTC BNBBTC BNTBTC BQXBTC BRDBTC BTGBTC BTSBTC CDTBTC CHATBTC CLOAKBTC CMTBTC CNDBTC CVCBTC DASHBTC DATABTC DENTBTC DGDBTC DLTBTC DNTBTC DOCKBTC EDOBTC ELFBTC ENGBTC ENJBTC EOSBTC ETCBTC ETHBTC EVXBTC FUELBTC FUNBTC GASBTC GNTBTC GRSBTC GTOBTC GVTBTC GXSBTC HCBTC HOTBTC HSRBTC ICNBTC ICXBTC INSBTC IOSTBTC IOTABTC IOTXBTC KEYBTC KMDBTC KNCBTC LENDBTC LINKBTC LOOMBTC LRCBTC LSKBTC LTCBTC LUNBTC MANABTC MCOBTC MDABTC MFTBTC MODBTC MTHBTC MTLBTC NANOBTC NASBTC NAVBTC NCASHBTC NEBLBTC NEOBTC NPXSBTC NULSBTC NXSBTC OAXBTC OMGBTC ONTBTC OSTBTC PHXBTC PIVXBTC POABTC POEBTC POLYBTC POWRBTC PPTBTC QKCBTC QLCBTC QSPBTC QTUMBTC RCNBTC RDNBTC REPBTC REQBTC RLCBTC RPXBTC SALTBTC SCBTC SKYBTC SNGLSBTC SNMBTC SNTBTC STEEMBTC STORJBTC STORMBTC STRATBTC SUBBTC SYSBTC THETABTC TNBBTC TNTBTC TRIGBTC TRXBTC TUSDBTC VENBTC VETBTC VIABTC VIBBTC VIBEBTC WABIBTC WANBTC WAVESBTC WINGSBTC WPRBTC WTCBTC XEMBTC XLMBTC XMRBTC XRPBTC XVGBTC XZCBTC YOYOBTC ZECBTC ZENBTC ZILBTC ZRXBTC

## sort on volume/trades


```julia
sort!(alldata, [:volume,:trades]; rev=true);
```

## who is the loser ?


```julia
head(sort(alldata[1:40,:], [:changeMin]; rev=false))
```

<table class="data-frame"><thead><tr><th></th><th>symbol</th><th>current</th><th>min</th><th>changeMin</th><th>max</th><th>changeMax</th><th>trades</th><th>volume</th></tr></thead><tbody><tr><th>1</th><td>ADABTC</td><td>1.227e-5</td><td>1.201e-5</td><td>2.16486</td><td>4.19e-5</td><td>70.716</td><td>10013620</td><td>2.03832e10</td></tr><tr><th>2</th><td>FUNBTC</td><td>2.23e-6</td><td>2.17e-6</td><td>2.76498</td><td>6.51e-6</td><td>65.745</td><td>1659651</td><td>6.09706e9</td></tr><tr><th>3</th><td>SNGLSBTC</td><td>2.91e-6</td><td>2.83e-6</td><td>2.82686</td><td>2.295e-5</td><td>87.3203</td><td>1185198</td><td>2.31789e9</td></tr><tr><th>4</th><td>GTOBTC</td><td>1.002e-5</td><td>9.69e-6</td><td>3.40557</td><td>6.95e-5</td><td>85.5827</td><td>2833881</td><td>3.14644e9</td></tr><tr><th>5</th><td>LENDBTC</td><td>1.83e-6</td><td>1.76e-6</td><td>3.97727</td><td>1.086e-5</td><td>83.1492</td><td>1264670</td><td>3.55641e9</td></tr><tr><th>6</th><td>POEBTC</td><td>1.26e-6</td><td>1.2e-6</td><td>5.0</td><td>6.79e-6</td><td>81.4433</td><td>2420694</td><td>1.79134e10</td></tr></tbody></table>

