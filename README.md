# Motivation

Getting up to speed with R using dose-response for 32 drugs against 6
bacterial strains.

# Tasks

In the following, we go through the most common steps in data analysis:
exploration and transformation (i.e. deriving new variables). Integral
to both steps is visualization i.e. making graphs.

## Explore

As a first look, the exploratory plots are informative and serve as a
quality control i.e. you know now that there is nothing extra suspicious
going on. Raw OD will suffice for that.

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

## Transform

To quantify the growth (either rate or yield) one needs to subtract the
background from raw OD. There are two ways to do that: 1) using a
readout from just the medium; 2) using the smallest value per well
(i.e. OD in one of the first timepoints of a particular well). I prefer
to use the former whenever possible.

1.  Add an `OD` variable to your dataframe for background subtracted OD.
    You need two things: 1) to `group` the data and 2) a way to point to
    background wells. Since grouping takes a bit practice until it
    becomes easy, I will just say that you need to subtract background
    on each day, on each plate, in each timepoint. The wells with no
    bacteria were encoded to have `uM = -1` i.e. after appropriate
    grouping it comes down to: `OD = OD/OD[uM == -1]`. Input
    [data](doc/tasks/03_dat.csv) is the same as in step 3 above. And if
    you now plot everything exactly as in step 3 above, except having OD
    on y-axis, here’s what [output](doc/tasks/04_out.pdf) should look
    like.

2.  Constrain the OD at limit of detection. You might have noticed on
    the previous plot that some of the growth curves start at very low
    values. In fact, some of the ODs ended up negative. This is because
    the values are actually lower bound by limit of detection (LOD).
    Experience tells that at OD<sub>595</sub> with 30 µL/well in LB, the
    limit of detection is ~0.03. So the final step for deriving
    background subtracted ODs is to constrain OD at 0.03. Multiple ways
    are again possible, I would go for `ifelse` statement. Here’s what
    the resulting [output](doc/tasks/05_out.pdf) plot should look like.
