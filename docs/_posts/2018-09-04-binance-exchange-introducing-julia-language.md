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

Julia is used in the domains of data science, machine learning, financial markets and has a nice plotting interface and its free!

# Install Julia lang
Head down to [Julialang](https://julialang.org/) website and click the download link for version 1.0, click on the executable to get started. 

To interact with Julia we have the folowing options:
 
 * Do everything in Julia REPL console, this is Sparta!!
 * in a Jupyter notebook
 * Visual Studio code with Julia Plugin
 * Atom editor + julia-client, provides the best visual integration

## Install jupyter notebook server

Installation as a notebook server has the advantage that no additional downloads outside Julia are nesesarry.

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

Below an excerpt of the log being produced in the Julia console 
 
![Julialang Jupyter]({{ "/assets/images/julia-jupyter.png" | relative_url }})

## Visual Studio Code and Julia plugin
Install Microsofts Visual Code and the Julia plugin, things should work out of the box.

![Visual Code]({{ "/assets/images/visualcode-julia-ide.png" | relative_url }})


## Atom editor with julia-client plugin
Also atom provides a decent Julia integration a may suite your needs, the editor styling is realy beautiful.

![Atom Julia IDE]({{ "/assets/images/atom-julia-ide.png" | relative_url }})

