#=
note_book_install:
- Julia version: 
- Author: drutjes
- Date: 2018-08-18
=#

import Pkg;

if get(Pkg.installed(),"IJulia",-1) == -1
    Pkg.add("IJulia")
end

