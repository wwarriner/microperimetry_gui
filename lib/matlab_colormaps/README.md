# MATLAB Colormaps

A collection of scientific and aesthetic colormaps usable in MATLAB, currently under construction!

All colormaps are designed to function exactly like the built-ins:
- Call `viridis` or `viridis()` to return a `256 x 3` array of RGB color values in the range `[0,1]`.
- Call `viridis(m)` to return an `m x 3` array of RGB color values in the range `[0,1]`, interpolated linearly from the base data.

To showcase any colormap against several tests and samples, call `showcase_cmap(viridis)`.

# Acknowledgements and Sources

Please contact me if you believe I am missing a license, a source, or have misattributed anything. I absolutely want to give credit where credit is due because your hard work is important to me and to my peers.

- **Jan Brewer** for popularizing the idea of accessible colormaps in the scientific community via a well-researched dissertation effort and providing a helpful website demonstrating the colormaps in action. [[source](https://colorbrewer2.org/)]
- **Fabio Crameri** for numerous colormaps and for a robust scientific approach to scientific color graphics in two dimensions. [[source](http://www.fabiocrameri.ch/colourmaps.php)]
- **Kenneth Moreland** for devising a general method for producing useful colormaps appropriate for illuminated surface representations in three dimensions, and related research, and for the numeric values of the blackbody colormap. [[source](https://www.kennethmoreland.com/color-advice/)]
- **Nathaniel J. Smith** and **Stefan van der Walt** for inferno, magma and plasma. [[source](https://bids.github.io/colormap/)]
- **Eric Firing** for viridis. [[source](https://bids.github.io/colormap/)]
- **Jamie R. Nuñez**, **Christopher R. Anderton** and **Ryan S. Renslow** for a well-researched and mathematically optimized color-deficiency safe colormap inspired by viridis. [[source](https://doi.org/10.1371/journal.pone.0199239)]
- **Charlie Loyd** for sinebow, a smoother variant of the circular HSV. [[source](https://basecase.org/env/on-rainbows)]
- **Bastion Bechtold** for twilight, a color-deficiency safe, perceptually uniform, symmetric diverging colormap. [[source](https://github.com/bastibe/twilight/blob/master/twilight.m)]
