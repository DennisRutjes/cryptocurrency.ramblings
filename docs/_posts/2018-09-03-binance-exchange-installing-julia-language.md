---
title: Binance exchange  Installing Julia
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
tags: beginner cryptocurrency julia jupyter 
---


## Julia lang
Julia language is a scripted language with a twist. The scripts get compiled and are super fast! The syntax is easy to learn, I will provide with the necessary code snippets to get stuff done.

Julia is used in the domains of data science, machine learning, financial markets and has a nice plotting interface and its free!

# Install Julia lang
Head down to [Julialang](https://julialang.org/) website and click the download link for version 1.0, click on the executable to get started. 

To interact with Julia we have the following options:
 
 * Julia REPL console, this is Sparta!!
 * Jupyter notebook
 * Visual Studio code with Julia Plugin, currently with version 1.0 there are issues [error](https://github.com/JuliaEditorSupport/julia-vscode/issues/537)
 * Atom editor + Julia-client provides the best visual integration *) []Juno IDE](http://junolab.org) 


*) for starters the atom editor is recommended.

## Julia Read Eval Print Loop (REPL)

This is the initial environment after executing Julia, for example I can start the Jupyter notebook server from this REPL.
The Julia cmd can be used to start script files and the REPL to do quick evaluation of calculation. 

![Julialang Jupyter]({{ "/assets/images/julia-jupyter.png" | relative_url }})

## Install Jupyter notebook server

Installation as a notebook server has the advantage that no 3rd party software outside Julia ecosystem are necessary.

```julia

import Pkg;
# check if IJulia is installed.
if get(Pkg.installed(),"IJulia",-1) == -1
    Pkg.add("IJulia")
end

# start notebook server
using Julia
notebook()
``` 

Test snippet performed on each julia development environment.

```julia

import Pkg
Pkg.add("PlotThemes")
Pkg.add("Plots")
using Plots
theme(:dark)
gr()
plot(Plots.fakedata(50,5),w=3)
``` 

Below is the end result, the jupyter server has started kernel Julia 1.0
 
![Jupyter Julia]({{ "/assets/images/jupyter-julia.png" | relative_url }})

## Visual Studio Code and Julia plugin
Install Microsofts [Visual Studio Code](https://code.visualstudio.com) and the Julia plugin, things (currently only for version 0.6.x) should work out of the box when Julia is on your PATH or installed in the default directory.

![Visual Code]({{ "/assets/images/visual-studio-code-julia.PNG" | relative_url }})

## Atom editor with the Julia-client plugin
Also, Atom provides a decent Julia integration a may suit your needs, the editor's styling is really beautiful.

![Atom Julia IDE]({{ "/assets/images/atom-julia-ide.png" | relative_url }})

