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
  teaser: "/assets/images/julia-logo.svg"
excerpt: 'This weekly blog series is a journey into crypto currency trading for beginners,
  this week: what should I buy ?'
classes: wide
category: programming julia
tags: cryptocurrency julia binance api
---

# Intro
The focus of this weekly blog series will shift to analyzing strategies for buying/selling assets. 
To see whether the strategy pans out or not a longer validation period is required and the results get posted (bi-)monthly.

So without further ado the first simple strategy.
# Follow the loser strategy, is it a winner?
Every strategy has the intention to buy low and sell high ;-), to spread the risk don't put all your BTC on one asset!
Why not investigate which assets are relatively low compared to their historic minimum and buy those? What comes down must go up?

## strategy implementation

1. we will be using BTC as a base currency, see the previous post
1. select TOP 40 of the highest trade volumes, higher volumes give us a greater chance of buying/selling at market price
1. sort the previous result based upon how close they to the minimum of the last 6 months
1. analyze top 5 of the results and by 50% of the BTC volume if you think that the asset has hit rock bottom, apply this for a maximum of 3 to 5 assets depending on the BTC budget.
1. create a limit order 1,05 of the buy value aiming for roughly a 5% profit, keep in mind for limit order the total value must be > 0.001 BTC
1. when a limit order has been fulfilled, rinse and repeat.


when using a notebook server : [Jupyter NoteBook](https://github.com/DennisRutjes/cryptocurrency.ramblings/blob/master/julia/notebooks/whattotrade.ipynb)
,you will find the code snippets to copy past in to your favourite IDE (shift-enter to run) at the end of this blog.

steps 1 through 3 are solved using julia :

| Row | symbol   | current  | min      | changeMin | max        | changeMax | trades   | volume     |
    |----:|:---------|---------:|---------:|----------:|-----------:|----------:|---------:|-----------:|
    | 1   | ADABTC   | 1.224e-5 | 1.201e-5 | 1.91507   | 4.19e-5    | 70.7876   | 10002471 | 2.03423e10 |
    | 2   | LENDBTC  | 1.81e-6  | 1.76e-6  | 2.84091   | 1.086e-5   | 83.3333   | 1264351  | 3.55424e9  |
    | 3   | WPRBTC   | 2.7e-6   | 2.61e-6  | 3.44828   | 1.905e-5   | 85.8268   | 1806929  | 2.37858e9  |
    | 4   | SNGLSBTC | 2.93e-6  | 2.83e-6  | 3.53357   | 2.295e-5   | 87.2331   | 1184985  | 2.31718e9  |
    | 5   | GTOBTC   | 1.01e-5  | 9.69e-6  | 4.23117   | 6.95e-5    | 85.4676   | 2831588  | 3.14215e9  |
    

step 4: seems ADABTC is a good candidate! lets go with that one!

steps 5 and 6 will be done during this month, the results will be posted next month or so, see you then!

    
# Julia code :

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
```

## Creating generic functions for Binance API data retrieval


```julia
# show all data for a given value
function showAll(value)
    show(IOContext(stdout, :displaysize => (10^6, 10^6)), "text/plain", value)
end

using HTTP, JSON, Dates
import Printf.@sprintf

# base URL of the Binance API
const BINANCE_API_REST = "https://api.binance.com/api/v1/ticker/";

# function HTTP response 2 JSON
function r2j(response)
    JSON.parse(String(response))
end

# retrieve data from binance for "allPrices", "24hr", "allBookTickers"
function getBinanceDataFor(withSubject)
    r = HTTP.request("GET", string(BINANCE_API_REST, withSubject))
    r2j(r.body)
end

# current Binance market
function getBinanceMarket()
    r = HTTP.request("GET", "https://www.binance.com/exchange/public/product")
    r2j(r.body)["data"]
end

# binance get candlesticks/klines data
function getBinanceKline(symbol, startDateTime, endDateTime ; interval="1m")
    startTime = @sprintf("%.0d",Dates.datetime2unix(startDateTime) * 1000)
    endTime = @sprintf("%.0d",Dates.datetime2unix(endDateTime) * 1000)
    query = string("symbol=", symbol, "&interval=", interval, "&startTime=", startTime, "&endTime=", endTime)
    r = HTTP.request("GET", string("https://api.binance.com/api/v1/klines?",  query))
    r2j(r.body)
end

function getBinanceKlineDataframe(symbol, startDateTime, endDateTime ; interval="1m")
    klines = getBinanceKline(symbol, startDateTime, endDateTime; interval= interval)
    result = hcat(map(z -> map(x -> typeof(x) == String ? parse(Float64, x) : x, z), klines)...)';

    #println(size(result))
    if size(result,2) == 0
        return nothing
    end

    symbolColumnData = map(x -> symbol, collect(1:size(result, 1)));
    df = DataFrame([symbolColumnData, Dates.unix2datetime.(result[:,1]/1000) ,result[:,2],result[:,3],result[:,4],result[:,5],result[:,6],result[:,8],Dates.unix2datetime.(result[:,7] / 1000),result[:,9],result[:,10],result[:,11]], [:symbol,:startDate,:open,:high,:low,:close,:volume,:quoteAVolume, :endDate, :trades, :tbBaseAVolume,:tbQuoteAVolume]);
end

# getFloatValueArray
getFloatValueArray(withKey, withDictArr) = map(dict -> parse(Float32, dict[withKey]) ,withDictArr)
getStringValueArray(withKey, withDictArr) = map(dict -> convert(String, dict[withKey]) ,withDictArr)
# filter
filterOnRegex(matcher,withDictArr; withKey="symbol") = filter(x-> match(Regex(matcher), x[withKey]) != nothing, withDictArr);
```

## Retrieve Market Symbols ending with BTC


```julia
using DataFrames,Statistics;

# get 24H tickerdata of all assets
hr24 = getBinanceDataFor("24hr");
# previous post we determined that BTC currency was the most obvious currency to tade in, most avalable symbols, second highest USDT $ volume.
hr24BTC = filterOnRegex("BTC\$", hr24)

# all symbols ending with BTC
symbols = sort!(getStringValueArray("symbol", hr24BTC));
```

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

    retrieving data from binance 2018-09-09T12:42:44.868 for : ADABTC ADXBTC AEBTC AGIBTC AIONBTC AMBBTC APPCBTC ARDRBTC ARKBTC ARNBTC ASTBTC BATBTC BCCBTC BCDBTC BCNBTC BCPTBTC BLZBTC BNBBTC BNTBTC BQXBTC BRDBTC BTGBTC BTSBTC CDTBTC CHATBTC CLOAKBTC CMTBTC CNDBTC CVCBTC DASHBTC DATABTC DENTBTC DGDBTC DLTBTC DNTBTC DOCKBTC EDOBTC ELFBTC ENGBTC ENJBTC EOSBTC ETCBTC ETHBTC EVXBTC FUELBTC FUNBTC GASBTC GNTBTC GRSBTC GTOBTC GVTBTC GXSBTC HCBTC HOTBTC HSRBTC ICNBTC ICXBTC INSBTC IOSTBTC IOTABTC IOTXBTC KEYBTC KMDBTC KNCBTC LENDBTC LINKBTC LOOMBTC LRCBTC LSKBTC LTCBTC LUNBTC MANABTC MCOBTC MDABTC MFTBTC MODBTC MTHBTC MTLBTC NANOBTC NASBTC NAVBTC NCASHBTC NEBLBTC NEOBTC NPXSBTC NULSBTC NXSBTC OAXBTC OMGBTC ONTBTC OSTBTC PHXBTC PIVXBTC POABTC POEBTC POLYBTC POWRBTC PPTBTC QKCBTC QLCBTC QSPBTC QTUMBTC RCNBTC RDNBTC REPBTC REQBTC RLCBTC RPXBTC SALTBTC SCBTC SKYBTC SNGLSBTC SNMBTC SNTBTC STEEMBTC STORJBTC STORMBTC STRATBTC SUBBTC SYSBTC THETABTC TNBBTC TNTBTC TRIGBTC TRXBTC TUSDBTC VENBTC VETBTC VIABTC VIBBTC VIBEBTC WABIBTC WANBTC WAVESBTC WINGSBTC WPRBTC WTCBTC XEMBTC XLMBTC XMRBTC XRPBTC XVGBTC XZCBTC YOYOBTC ZECBTC ZENBTC ZILBTC ZRXBTC

## sort on volume/trades


```julia
sort!(alldata, [:volume,:trades]; rev=true);
```

## who is the loser ?


```julia
head(sort(alldata[1:40,:], [:changeMin]; rev=false))
```


<table class="data-frame"><thead><tr><th></th><th>symbol</th><th>current</th><th>min</th><th>changeMin</th><th>max</th><th>changeMax</th><th>trades</th><th>volume</th></tr></thead><tbody><tr><th>1</th><td>ADABTC</td><td>1.228e-5</td><td>1.201e-5</td><td>2.24813</td><td>4.19e-5</td><td>70.6921</td><td>10002842</td><td>2.03433e10</td></tr><tr><th>2</th><td>WPRBTC</td><td>2.68e-6</td><td>2.61e-6</td><td>2.68199</td><td>1.905e-5</td><td>85.9318</td><td>1806944</td><td>2.37861e9</td></tr><tr><th>3</th><td>LENDBTC</td><td>1.81e-6</td><td>1.76e-6</td><td>2.84091</td><td>1.086e-5</td><td>83.3333</td><td>1264368</td><td>3.55447e9</td></tr><tr><th>4</th><td>SNGLSBTC</td><td>2.92e-6</td><td>2.83e-6</td><td>3.18021</td><td>2.295e-5</td><td>87.2767</td><td>1184982</td><td>2.31718e9</td></tr><tr><th>5</th><td>FUNBTC</td><td>2.25e-6</td><td>2.17e-6</td><td>3.68664</td><td>6.51e-6</td><td>65.4378</td><td>1659178</td><td>6.09257e9</td></tr><tr><th>6</th><td>VIBBTC</td><td>4.81e-6</td><td>4.63e-6</td><td>3.88769</td><td>2.9e-5</td><td>83.4138</td><td>1143303</td><td>2.57617e9</td></tr></tbody></table>


