
refreeze
========

### Notes on how to create (*freeze*) a standalone shiny application

The [RStudio Shiny](https://shiny.rstudio.com/) web development framework provides a great set of tools to quickly create web applications for scientific and data management use. It is especially good for building user-friendly one-off applications to accomplish specific tasks such as exploring, analyzing or validating data...or producing estimates and reports.

Often the main roadblock when creating shiny applications is not development, but deployment. Intended users are typically non-programmers, and may be uncomfortable running scripts. Within organizations, deploying small, non-standard, projects to a webserver may be difficult or impossible given the inevitable hurdles of IT bureaucracy, security issues, or procurement. When the intended user base is relatively small, creating a standalone program may be the simplest and fastest way to get needed tools into the hands of users. Especially whan those programs do not require the end-user to have administrative rights in order to install on their local machines.

Unlike scripts that can be subject to errors as the underlying R engine and dependent package universe changes, a standalone application is frozen in time. It will always work as when first constructed. Executable installers cost essentially nothing to copy and distribute.

Procedure
---------

The following steps document *one* simple and opinionated way to freeze a shiny application that I have successfully used over the past few years. I am writing this mostly for myself to avoid forgetting the procedure and repeating common mistakes. It is based on this [blog post](http://blog.analytixware.com/2014/03/packaging-your-shiny-app-as-windows.html) from 2014 when the shiny framework was still in early development. Next steps are to test and document procedures on how to package up standalone shiny apps using [Electron](https://electronjs.org/) on the front-end. See: [r-shiny-electron](https://github.com/dirkschumacher/r-shiny-electron), [Rinno](https://ficonsulting.github.io/RInno/), [deploy-shiny-electron](https://www.travishinkelman.com/post/deploy-shiny-electron/), [electron-quick-start](https://github.com/ColumbusCollaboratory/electron-quick-start).

-   Create a new folder in your application working directory. In my case this would be `C:\data\RStudio\Applications`. For the `flight_proof` application used as an example below, the path would be: `C:\data\RStudio\Applications\flight_proof`

-   Download the latest version of [R-Portable](https://sourceforge.net/projects/rportable/files/R-Portable/) to the new folder. Then double-click the e.g. `R-Portable_3.5.2.paf.exe` to run. This will create the `R-Portable` folder in your new application folder. No admin privileges are needed to install `R-Portable`.

-   If a 32-bit version of R is needed to run your application, for example when a 32-bit MS Access database needs to be accessible, do not click `Yes` to the `Run R Portable` checkbox during the installation process...as the default assumes you want 64-bit R.

-   Install needed libraries: Normally you would install any needed packages by running the Rgui.exe located at `R-Portable\App\R-Portable\bin\x64`. For the less common cases where 32-bit R is needed I normally navigate to the `R-Portable\App\R-Portable\bin\i386` folder and then click on `Rgui.exe` to open the RGUI. I then install any libraries using 32-bit R. It may not make any difference either way.

-   Using the Rgui (whether 64-bit or 32-bit) open the `library_install_pak.R` script located at: [refreeze](https://github.com/arestrom/refreeze). A copy is also normally kept in the `RStudio\Applications` folder. Edit as needed to add required libraries. This script uses the new `pak` package to ensure all package dependencies are installed along with the primary libraries in the `library()` calls. Prior to using the `pak` method, getting all required packages loaded could be a long and tedious process of testing, failing, and installing yet another package.

-   After opening the `library_install_pak.R` script in the `R-Portable` Rgui, highlight the relevant lines needed to install needed packages. Then click on `Run line or selection` icon. Enter `Yes` when asked to set up `pak` for initial use. You will be asked to say `Yes` on more time to install packages after they have been downloaded. You may need to click in the R console to see progress as packages are installed.

-   Copy your `ui.R`, `server.R`, and `global.R` scripts along with any other needed scripts needed for your application into a folder named `shiny` in the top-level directory of your application. For example: `C:\data\RStudio\Applications\flight_proof\shiny`. There should also be a `www` subfolder containing any images, rmarkdown .rmd files, etc.

-   Make sure and edit the `server.R` file to uncomment the `stopApp()` function at the very bottom of the `server.R` script. This is needed to make sure the `R.exe` is properly closed when the application exits. The function looks like this:

``` r
# close the R session when Chrome closes
  session$onSessionEnded(function() {
    stopApp()
    q("no")
  })
```

-   The [refreeze](https://github.com/arestrom/refreeze) repository contains example materials needed for the next steps. Copy the `run.vbs`, `runShinyApp.R`, and `FlightProof.ico` from the repository into the top level of your app folder. You should also copy the `flight_proof.iss` file. I normally keep a copy of all application `.iss` scripts in the application parent directory, in my case `C:\data\RStudio\Applications`.

-   Rename the `FlightProof.ico` as needed, or find another icon to use. There should be no need to edit the other files. You will only need to edit the `run.vbs` if 32-bit R is needed. In that case the text of the `run.vbs` script will be `R-Portable\App\R-Portable\bin\i386\R.exe` instead of `R-Portable\App\R-Portable\bin\x64\R.exe`.

-   Download and install [Inno Setup](http://www.jrsoftware.org/isinfo.php). Then edit a copy of the `flight_proof.iss` Inno Setup script, and rename as needed to the application name.

-   Double-click on the `app_name.iss` file to open `Inno Setup`. In the `AppID` field, highlight all but the first curly brace, and under `Tools` click on the `Generate GUID` option. This will overwrite the section with a new GUID. Edit the other fields as needed to specify things such as the application name and version number, the source directory for the application files, and the destination directory for the setup executable. Make sure that the `PrivilegesRequired=none` field is set to `none`. This will ensure that end-users can run the setup executable without needing administrative privileges. In practice I have found that the setup dialogue may still ask for an administrative login to install, but the normal account and password will work.

-   To create the application setup installer, click on `Build – Compile`. This will bundle up all materials needed for you application and create an executable installer in your application directory. Your application, along with the current version of R and all needed packages, are now frozen in time.

-   After compiling and installing the application, try running. In case the application fails to load, navigate to the `out.txt` folder in the App directory that the installer created, for example: `C:\data\Intertidal\Apps\FlightProof\out.txt`. The `out.txt` file will indicate any errors encountered and will identify any packages that are still not present...or that failed to load. Only one package at a time will fail, so in the past, before using the `pak` package, multiple iterations were typically needed to identify all missing packages.

-   Also in the past, after each iteration of a failed load, I would add missing packages to the list in the `library_install.R` script and re-run using the appropriate `R.exe` in the newly installed App folder. Then rinse and repeat until the app ran properly and no more errors are encountered. I would have to kill R processes using task manager between most package installs. So if this happens to you, keep task manager open. You do not have to close the `Rgui.exe`.

-   After all dependencies are satisfied, rerun the `flight_proof.iss` Inno Setup script to recompile. The application should now install with all needed dependencies satisfied.
