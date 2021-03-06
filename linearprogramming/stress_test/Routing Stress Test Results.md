# Routing Stress Test Results

TLDR: It's worse than we thought.

## Timing Tests

All times are in seconds.

### n1-highcpu-2

||C=1 |C=2 |C=3 |C=4 |C=5 |C=6 |
|---|---|---|---|---|---|---|
|T=1| 3.10 | 2.75 | 5.79 |18.66|69.24|3289.66|
|T=2|3.45|2.69|7.47|79.87|9670.57||
|T=3|3.45|3.15|3.81|4121.82|>259200||
|T=4|2.78|3.20|5.14||||
|T=5|2.78|4.39|540.10||||
|T=6|3.31|3.77|||||
|T=7|3.48|8.79|||||
|T=8|2.97|14.42|||||
|T=9|4.58|21.84|||||

### n1-highcpu-16

||C=1 |C=2 |C=3 |C=4 |C=5 |C=6 |
|---|---|---|---|---|---|---|
|T=1|2.47|2.30|4.79|18.48|137.24||
|T=2|2.23|2.48|7.26|64.60|||
|T=3|2.31|2.63|3.27||||
|T=4|2.60|2.76|4.63||||
|T=5|2.46|3.32|524.17||||
|T=6|2.41|3.33|||||
|T=7|2.51|7.47|||||
|T=8|2.59|12.90|||||
|T=9|3.96|18.28|||||

### n1-highmem-2
||C=1 |C=2 |C=3 |C=4 |C=5 |C=6 |
|---|---|---|---|---|---|---|
|T=1|2.47|2.25|5.63|23.02|168.50||
|T=2|2.39|2.59|6.82|242.34|||
|T=3|2.54|2.74|3.31|1137.38|||
|T=4|2.55|2.94|4.90||||
|T=5|2.95|3.49|||||
|T=6|2.44|3.28|||||
|T=7|2.65|7.91|||||
|T=8|2.63|12.96|||||
|T=9|3.95|19.06|||||

## CPU vs Memory

We're definitely CPU-limited.

![out.png](out.jpg)

## Code Profiling Results

[Line by line results](https://raw.githubusercontent.com/CSSE497/PathfinderRouting/topic/profiling/stress_test/profile-4-vehicles-3-commodities.txt)

For a ~5-second request, 1515942/1518016 = 99.86337% of the request was spent inside the solving mechanism.