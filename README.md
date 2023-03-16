[![DOI](https://zenodo.org/badge/615039897.svg)](https://zenodo.org/badge/latestdoi/615039897)

# Combined dataset of elemental X-ray line properties

This R package contains a dataset of X-ray line (transition) and edge energies,
natural line widths, and fluorescence yields for the elements Z=4 (Be) to Z=103 (Lr).

This package also provides a matching algorithm that given a set of energies
can suggest the most closely matching elemental transitions based on some
rudimentary heuristics.



## Install this package

To use this package, install it directly from this repo:

```
install.packages("remotes")
remotes::install_github("solarchemist/xraylines")
```

If you encounter bugs or have any feedback
[please open an issue](https://github.com/solarchemist/xraylines/issues).


## Develop this package

Check out the source code from this repo:
```
git clone https://github.com/solarchemist/xraylines.git
```

I suggest the following package rebuild procedure:

+ Run `devtools::check()` (use `document=TRUE` to also update the docs).
  Should complete with no warnings or errors, and 2 notes:
```
── R CMD check results ──────────────────── xraylines 0.1.1.9000 ────
Duration: 12.7s

❯ checking top-level files ... NOTE
  Non-standard file/directory found at top level:
    ‘CITATION.cff’

❯ checking package subdirectories ... NOTE
  Found the following CITATION file in a non-standard place:
    CITATION.cff
  Most likely ‘inst/CITATION’ should be used instead.

0 errors ✔ | 0 warnings ✔ | 2 notes ✖
```
+ Run `devtools::build_vignettes()`. This recompiles the vignettes
  and populates the `doc/` directory.
+ Manually remove the line `doc` from `.gitignore` because we want the built
  vignette to be available on the remote repo (the build step keeps adding this line).


## Contributions welcome!

[Open an issue](https://github.com/solarchemist/xraylines/issues) or
[contact me](https://solarchemist.se/contact/) with your bug reports and any feedback.



## Citation

To cite `xraylines` in publications use:

Taha Ahmed (2023). Combined dataset of elemental X-ray line properties.
DOI: [10.5281/zenodo.7742595 ](https://doi.org/10.5281/zenodo.7742595 ).

Or see the `CITATION.cff` file in this repo
([learn about CFF](https://citation-file-format.github.io)).
