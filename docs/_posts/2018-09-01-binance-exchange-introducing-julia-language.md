---
title: Binance exchange  Introducing Julia language
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
  this week: Introducing Julia'
classes: wide
category: programming julia julialang
tags: beginner cryptocurrency julia
---


## Julialang
Julia language is a scripted language with a twist. The scripts get compiled and are super fast! The syntax is easy to learn, I will provide with the necessary code snippets to get stuff done.

 Julia is used in the domains of data science, machine learning, financial markets and has a nice plotting interface.

# Install Julia lang
Head down to [Julialang](https://julialang.org/)  website and click the download link for version 1.0, click on the executable to get started. 
To interact with Julia in a Jupyter notebook type the following in the Julia console. This may take a while the first time, consecutive startups will be fast.


## Install with jupyter notebook server

```julia

import Pkg;
# check if IJulia is installed allreadey
if get(Pkg.installed(),"IJulia",-1) == -1
    Pkg.add("IJulia")
end

# start notebook server
using Julia
notebook()
``` 
 
![Julialang Jupyter]({{ "/assets/images/julia-jupyter.png" | relative_url }})


