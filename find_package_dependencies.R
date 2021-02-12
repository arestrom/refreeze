#=========================================================================
# Identify all package dependencies...includes recursive search
#
# AS 2021-02-12
#=========================================================================

# # Add list of libraries from global
# library(shiny)
# library(shinydashboard)
# library(shinydashboardPlus)
# library(shinyWidgets)
# library(shinyjs)
# library(shinyTime)
# library(tippy)
# library(glue)
# library(pool)
# library(tibble)
# library(DBI)
# library(RPostgres)
# library(dplyr)
# library(DT)
# library(leaflet)
# library(mapedit)
# library(leaflet.extras)
# library(sf)
# library(lubridate)
# library(uuid)
# library(shinytoastr)
# library(shinycssloaders)
# library(stringi)

# Get list of dependencies
lib_pkg = c("shiny", "shinydashboard", "shinydashboardPlus", "shinyWidgets",
            "shinyjs", "shinyTime", "tippy", "glue", "tibble", "DBI", "RPostgres",
            "dplyr", "DT", "leaflet", "mapedit", "leaflet.extras", "sf", "lubridate",
            "uuid", "shinytoastr", "shinycssloaders", "stringi")
dep_pkg = tools::package_dependencies(lib_pkg, recursive = TRUE)
dep_vec = unique(as.vector(unlist(dep_pkg)))
all_pkg = unique(c(unique(lib_pkg), dep_vec))
sort(all_pkg)

# Find all packages in base
base_pkg = rownames(installed.packages(priority = "base"))
sort(base_pkg)

# Find all newly installed packages in package library
rp_lib = .libPaths()[2]
rp_lib
new_pkg = rownames(installed.packages(rp_lib, priority = "NA"))
sort(new_pkg)

# Pull out only packages not in base or new_pkg
needed_pkg = all_pkg[!all_pkg %in% c(new_pkg, base_pkg)]
sort(needed_pkg)

# Print full set needed
paste0(paste0("'", needed_pkg, "'", collapse = ", "))

# Find full set of installed packages...after installing any missing ones
final_pkg = rownames(installed.packages())

# Check if all_pkg are now in final_pkg....need to test this last line
all(all_pkg %in% final_pkg)
