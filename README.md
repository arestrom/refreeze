
refreeze
========

### Notes on how to create (*freeze*) a standalone shiny application

The [RStudio Shiny](https://shiny.rstudio.com/) web development framework provides a great set of tools to quickly create web applications for scientific and data management use. It is especially good for building user-friendly one-off applications to accomplish specific tasks such as exploring, analyzing or validating data...or producing estimates and reports.

Often the main roadblock when creating shiny applications is not development, but deployment. Intended users are typically non-programmers, and may be uncomfortable running scripts. Within organizations, deploying to a webserver may be difficult or impossible given the inevitable hurdles of IT bureaucracy, security issues, or procurement. When the intended user base is relatively small, creating a standalone program may be the simplest and fastest way to get needed tools into the hands of users. Especially whan those programs do not require administrative rights to install.

Unlike scripts that can be subject to errors as the underlying R engine and dependent package universe changes, a standalone application is frozen in time. It will always work as when first constructed. Executable installers cost nothing to copy and disribute.

Procedure
---------

The following steps document *one* simple and opinionated way to freeze a shiny application. Next steps are to test and document procedures on how to package up standalone shiny apps using [Electron](https://electronjs.org/) on the front-end. See: [r-shiny-electron](https://github.com/dirkschumacher/r-shiny-electron), [Rinno](https://ficonsulting.github.io/RInno/), [deploy-shiny-electron](https://www.travishinkelman.com/post/deploy-shiny-electron/), [electron-quick-start](https://github.com/ColumbusCollaboratory/electron-quick-start).

-   Create a new folder with the application name in the `C:\data\RStudio\Applications` folder. For example: `C:\data\RStudio\Applications\flight_proof`

-   Download the latest version of [R-Portable](https://sourceforge.net/projects/rportable/files/R-Portable/) to the new folder. Then double-click the e.g. `R-Portable_3.5.2.paf.exe` to run. This will create the R-Portable folder in your new application folder. No admin privileges are needed to install R-Portable.

-   If a 32-bit version of R is needed to run your application, for example when a 32-bit MS Access database needs to be accessible, do not click `Yes` to the `Run R Portable` checkbox during the installation process...as the default assumes you want 64-bit R.

-   Install needed libraries: Although it may not be necessary, for 32-bit R library installs, I normally navigate to the `R-Portable\App\R-Portable\bin\i386` folder and then click on `Rgui.exe` to open the RGUI. I then install any libraries using 32-bit R.

-   Using the RGUI (whether 64-bit or 32-bit) open the `library_install_pak.R` script located at: [refreeze](https://github.com/arestrom/refreeze). A copy is also normally kept in the `RStudio\Applications` folder. Edit as needed to add required libraries. This script uses the new `pak` package to ensure all package dependencies are installed along with the primary libraries in the `library()` calls. Prior to using the `pak` method, getting all required packages loaded could be a long and tedious process of testing, failing, and installing yet another package. Enter `Yes` when asked to set up `pak` for initial use. You will be asked to say `Yes` on more time to install packages after they have been downloaded. You may need to click in the R console to see progress as packages are installed.

-   Copy the your `ui.R`, `server.R`, and `global.R` scripts along with any other needed scripts into a folder named `shiny` in the top-level directory of your application. For example: `C:\data\RStudio\Applications\flight_proof\shiny`. There should also be a `www` subfolder containing images, rmarkdown .rmd files, etc.

-   Make sure and edit the `server.R` file to uncomment the `stopApp()` function at the very bottom of the `server.R` script. This is needed to make sure the R.exe is properly closed when the application exits. The function looks like:

``` r
# close the R session when Chrome closes
  session$onSessionEnded(function() {
    stopApp()
    q("no")
  })
```

-   Copy the `run.vbs`, `runShinyApp.R`, and `.ico` into the top level of the app folder

-   Rename the `.ico` as needed. There should be no need to edit the other files. You will only need to edit the `run.vbs` if 32-bit R is needed. In that case the text of the `run.vbs` script will be `R-Portable\App\R-Portable\bin\i386\R.exe` instead of `R-Portable\App\R-Portable\bin\x64\R.exe`.

-   Download and install [Inno Setup](http://www.jrsoftware.org/isinfo.php). Then edit a copy of the `flight_proof.iss` Inno Setup script, or similar, and rename as needed to the application name.

-   Double-click on the `app_name.iss` file to open `Inno Setup`. In the `AppID` field, highlight all but the first curly brace, and under `Tools` click on the `Generate GUID` option. This will overwrite the section with a new GUID.

-   To create the application installer, click on `Build – Compile`. An executable installer will be created in your application directory.

-   After compiling and installing the application, try running. In case the application fails to load, navigate to the `out.txt` folder in the App directory that the installer created, for example: `C:\data\Intertidal\Apps\FlightProof\out.txt`. The `out.txt` file will indicate any errors encountered and will identify any packages that are still not present...or that failed to load. Only one package at a time will fail, so in the past, before using the `pak` package, multiple iterations were typically needed to identify all missing packages.

-   In the past, after each iteration of a failed load, I would add missing packages to the list in the `LibraryInstall.R` script and re-run using the appropriate `R.exe` in the newly installed App folder. Then rinse and repeat until the app ran properly and no more errors are encountered. I would have to kill R processes using task manager between most package installs. So if this happens to you, keep task manager open. You do not have to close the `RGui.exe`. See the previous `LibraryInstall.R` script for an example of how to add just one package at a time for each iteration.

-   After all dependencies are satisfied, rerun the `flight_proof.iss` Inno Setup script to recompile. The application should now install with all needed dependencies satisfied.
