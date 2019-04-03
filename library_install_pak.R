
# Set the library path
rp_lib = .libPaths()[2]

# Run this first to install the pak package
install.packages("pak", rp_lib, repos = "http://cran.rstudio.com/", dependencies = TRUE)

# After pak has been installed, run the pkg_install() function to install appliction dependencies  
pak::pkg_install(lib = rp_lib, pkg = c("dplyr", "glue", "tibble", "lubridate", "shiny", "leaflet",
                                  "sf", "mapview", "markdown", "DT", "purrr", "shinythemes"))



