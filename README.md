# Motivation

Getting up to speed with R using dose-response for 32 drugs against 6
bacterial strains.

# Tasks

In the following, we go through the most common steps in data analysis:
exploration and transformation (i.e. deriving new variables). Integral
to both steps is visualization i.e. making graphs.

## Explore

1.  Plot growth curves following raw OD in time. Input
    [data](doc/tasks/01_dat.csv) and expected
    [output](doc/tasks/01_out.pdf) plot are provided. The data is for
    azithromycin against *S. flexneri* M90T from day 2022-05-04 (first
    replicate). *A tip: Use `facet_wrap` with `ncol = 1` argument to
    have different concentrations on separate plots.*

2.  Try again, now with [data](doc/tasks/02_dat.csv) from two days (let
    us plot days in different color). In addition, transform the y-axis
    to logarithmic scale. Expected [output](doc/tasks/02_out.pdf). *A
    tip: you need to turn the `Date` variable into a factor.*

3.  Once more, now with [data](doc/tasks/03_dat.csv) from three days.
    Expected [output](doc/tasks/03_out.pdf). You will encounter an issue
    because there were two biological replicates on third day. There are
    multiple ways to overcome this, but for now, I recommend to solve by
    using `group` parameter of `aes`
    e.g. `ggplot(aes(..., group = Plt))`.
