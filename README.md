---
title: "Markov Chains analysis and rendering tools"
author: "Fabio Caironi"
date: ""
output: html_document
---

## Introducion
This package is endowed with several tools for analyzing discrete homogeneous Markov chains. Namely: a **graph** rendering section, an **analysis** summary section and a **simulation** section. MC's here are treated as object of the class `markovchain`, which is defined in the omonimous package [markovchain](https://cran.r-project.org/web/packages/markovchain/index.html). In fact, this package leans on the latter as for MC's implementation and analysis, nonetheless provides a user-friendly rendering through a shiny app.

## Shiny app
Run the `mctools` shiny app and start working.
```R
library(mctools)
GUI()
```

Here below the MC's acquisition methods and outputs are listed and described.

### Manual input
A page dedicated to keyboard input will open as soon as the shiny app is run. Here you can create a Markov Chain by specifying the *number of states*, the *names of the states* and the *transition matrix*. All data you enter will be properly validated before creating any Markov Chain.

### Dataset input
The data input sidebar allows you to load data exported from the official [ESMA Central Repository](https://cerep.esma.europa.eu/cerep-web/homePage.xhtml), concerning rating activity and rating performance of **Credit Rating Agencies** (CRA). These statistics are available over a user-chosen period and rating type, for each CRA. You should also specify a time horizon (Short term / Long term). In our context, what is interesting are the [Transition matrices](https://cerep.esma.europa.eu/cerep-web/statistics/transitionMatrice.xhtml) of the rating activity, that you can download as a .csv file using the dedicated icon at the top right of the page.
The specific format of those files is a requirement for retrieving correctly the transition matrix, so do not try to read from a differently structured file. 
Five sample files downloaded from ESMA are avaiable in the package as well (and are presented in a selection list in the shiny app).

### Graph
A graph is rendered through the `diagram` package. Please, note that `mctools` is intended for small-dimensioned discrete Markov chains: although *analysis* and *simulation* will display outputs quite tidily even for a great number of states, the diagram plot won't look nice in that case (for rendering graphs with many nodes, such as social networks graphs, check out [here](https://plot.ly/r/network-graphs/)).

### Summary
In this section you can find a complete analysis of your MC. This will include analysis of reducibility, regularity, periodicity of MC, classification of its states, existence of stationary distributions and probabilistic analysis.

### Simulation
Thanks to a built-in function for MC's simulation provided by `markovchain`, this section allows you to simulate your MC by picking and initial state and a sample dimension.


### External references
To have an in-depth review of the package `markovchain` and its applications you may find very useful its vignette [An introduction to markovchain package](https://cran.r-project.org/web/packages/markovchain/vignettes/an_introduction_to_markovchain_package.pdf).

