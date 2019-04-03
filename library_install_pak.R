
# flight_proof
rp_lib = .libPaths()[2]
install.packages("pak", rp_lib, repos = "http://cran.rstudio.com/", dependencies = TRUE)
pak::pkg_install(lib = rp_lib, pkg = c("dplyr", "glue", "tibble", "lubridate", "shiny", "leaflet",
                                  "sf", "mapview", "markdown", "DT", "purrr", "shinythemes"))



