
# Set path to library
rp_lib = .libPaths()[2]

# Verify path
rp_lib

# Set option to not check for source packages
options(install.packages.check.source = "no")

# Install packages
install.packages(c("shiny", "shinydashboard", "shinydashboardPlus", "shinyTime", "shinyjs", "tippy",
                   "RPostgres", "glue", "tibble", "DBI", "pool", "dplyr",
                   "DT", "leaflet", "mapedit", "leaflet.extras", "sf", "lubridate",
                   "uuid", "shinytoastr", "shinycssloaders", "stringi", "httpuv", "mime",
                   "jsonlite", "xtable", "digest", "htmltools", "R6", "sourcetools",
                   "later", "promises", "crayon", "rlang", "fastmap", "withr",
                   "commonmark", "base64enc", "Rcpp", "BH", "magrittr", "htmlwidgets",
                   "yaml", "bit64", "blob", "hms", "plogr", "bit",
                   "vctrs", "pkgconfig", "ellipsis", "cli", "fansi", "lifecycle",
                   "pillar", "assertthat", "utf8", "dbplyr", "purrr", "tidyselect",
                   "generics", "crosstalk", "lazyeval", "markdown", "png", "RColorBrewer",
                   "raster", "scales", "sp", "viridis", "leaflet.providers", "xfun",
                   "farver", "labeling", "munsell", "viridisLite", "lattice", "ggplot2",
                   "gridExtra", "gtable", "isoband", "MASS", "mgcv", "colorspace",
                   "testthat", "nlme", "Matrix", "evaluate", "pkgload", "praise",
                   "desc", "pkgbuild", "rprojroot", "rstudioapi", "callr", "prettyunits",
                   "backports", "processx", "ps", "leafem", "leafpm", "mapview",
                   "miniUI", "stringr", "leafpop", "satellite", "webshot", "classInt",
                   "units", "e1071", "class", "KernSmooth", "brew", "svglite",
                   "plyr", "gdtools", "systemfonts", "cpp11"),
                 rp_lib, repos = "http://cran.rstudio.com/", type = "win.binary", dependencies = TRUE)

# Install from github..Got rid of remisc dependency. Not using iformr for now.
#withr::with_libpaths(new = rp_lib, remotes::install_github('arestrom/remisc'), build = FALSE)
#withr::with_libpaths(new = rp_lib, remotes::install_github('arestrom/iformr'), build = FALSE)

