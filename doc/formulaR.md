# Formula interface in R

Let us take a step back and look at some data built in R. `cars` dataset
describes the speed of cars and the corresponding distance it takes to
stop.

    p1 = cars %>% 
      ggplot(aes(speed, dist)) +
      geom_point()
    p1

![](formulaR_files/figure-markdown_strict/unnamed-chunk-1-1.png)

There is a trend in the data: with increased speed, cars stop at a
longer distance. One way to illustrate this trend comes with `ggplot2`:

    p1 + geom_smooth()

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](formulaR_files/figure-markdown_strict/unnamed-chunk-2-1.png)

The result is a familiar loess function from MS Excel. The trend,
however, seems unnecessary wiggly and linear trend line would probably
suffice. To do that with `ggplot2`, issue `method = 'lm'` to
`geom_smooth`:

    p1 + geom_smooth(method = 'lm')

    ## `geom_smooth()` using formula 'y ~ x'

![](formulaR_files/figure-markdown_strict/unnamed-chunk-3-1.png)

What if we would like to know the equation for such a linear model? To
do that, we use `lm` (stands for linear model) function:

    mod = lm(dist ~ speed, data = cars)

`lm` uses formula interface (`y ~ x`): we tell `lm` this way that we
want to explain the `distance` using `speed` and direct the function for
these variables in cars dataframe.

The intercept and slope can be printed out:

    mod

    ## 
    ## Call:
    ## lm(formula = dist ~ speed, data = cars)
    ## 
    ## Coefficients:
    ## (Intercept)        speed  
    ##     -17.579        3.932

Formula interface is used throughout R. We can use it for plotting.
Instead of:

    plot(cars$speed, cars$dist)

![](formulaR_files/figure-markdown_strict/unnamed-chunk-6-1.png)

we can do:

    plot(dist ~ speed, cars)

![](formulaR_files/figure-markdown_strict/unnamed-chunk-7-1.png)

Notice that in the formula interface, *y* comes first.

It is beyond the scope, but we can add the linear model to our last
plot:

    plot(dist ~ speed, cars)
    abline(mod)

![](formulaR_files/figure-markdown_strict/unnamed-chunk-8-1.png)
