#=========================================================================
# Identify all package dependencies...includes recursive search
#
# AS 2020-09-28
#=========================================================================

# # Add list of libraries from global
# library(shiny)
# library(shinydashboard)
# library(shinydashboardPlus)
# library(shinyTime)
# library(shinyjs)
# library(tippy)
# library(RPostgres)
# library(glue)
# library(tibble)
# library(DBI)
# library(pool)
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
lib_pkg = c("shiny", "shinydashboard", "shinydashboardPlus",
            "shinyTime", "shinyjs", "tippy", "RPostgres",
            "glue", "tibble", "DBI", "pool", "dplyr", "DT",
            "leaflet", "mapedit", "leaflet.extras", "sf",
            "lubridate", "uuid", "shinytoastr", "shinycssloaders",
            "stringi")
dep_pkg = tools::package_dependencies(lib_pkg, recursive = TRUE)
dep_vec = unique(as.vector(unlist(dep_pkg)))
all_pkg = unique(c(unique(lib_pkg), dep_vec))
all_pkg

# Find all packages in base
base_pkg = rownames(installed.packages(priority = "base"))
base_pkg

# Pull out only packages not in base
needed_pkg = all_pkg[!all_pkg %in% base_pkg]
sort(needed_pkg)

# Find full set of installed packages...after installing any missing ones
final_pkg = rownames(installed.packages())

# Check if all_pkg are now in final_pkg....need to test this last line
all(final_pkg %in% final_pkg)
