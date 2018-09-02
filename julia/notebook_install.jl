import Pkg
Pkg.add("PlotThemes")
Pkg.add("Plots")

using Plots
theme(:dark)
gr()
plot(Plots.fakedata(50,5),w=3)


