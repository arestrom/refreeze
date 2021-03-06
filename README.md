
# Shiny standalone (refreeze)

#### Notes and resources for how to create (*freeze*) a standalone shiny application

## Introduction

The [RStudio Shiny](https://shiny.rstudio.com/) web development
framework provides a great set of tools to quickly create web
applications for scientific and data management use. It is especially
good for building user-friendly one-off applications to accomplish
specific tasks such as exploring, analyzing or validating data…or
producing estimates and reports.

Often the main roadblock when creating shiny applications is not
development, but deployment. Shiny webapps can always be run locally
from the command line or [RStudio](https://www.rstudio.com/), but
intended users are typically non-programmers, and may be uncomfortable
running scripts. Deploying to low-cost services such as
[shinyapps.io](https://www.shinyapps.io/) may not be an option if local
databases need to be accessed. Within organizations, deploying small,
non-standard projects to a webserver may be difficult or impossible
given the inevitable hurdles of IT bureaucracy, security issues, or
procurement. When the intended user base is relatively small, creating a
standalone program may be the simplest and fastest way to get needed
tools into the hands of users…especially when those programs do not
require the end-user to have administrative rights in order to install
on their local machines.

Unlike scripts that can be subject to errors as the underlying R engine
and dependent package universe changes, a standalone application is
frozen in time. It will always work as when first constructed.
Executable installers cost essentially nothing to copy and distribute.
Scaling the user base is a non-issue.

## Roadmap

The following steps document *one* simple and opinionated way to freeze
shiny applications for local installs on Windows machines as standalone
applications. I have successfully used this method since 2014 and am
documenting the steps mostly for myself to avoid forgetting the
procedure and repeating common mistakes. It is based on this [blog
post](http://blog.analytixware.com/2014/03/packaging-your-shiny-app-as-windows.html)
from 2014 when the shiny framework was still in early development. Next
steps are to test and document procedures on how to package standalone
shiny apps using [Electron](https://electronjs.org/) on the front-end.
See:
[r-shiny-electron](https://github.com/dirkschumacher/r-shiny-electron),
[electricShine](https://github.com/chasemc/electricShine),
[deploy-shiny-electron](https://www.travishinkelman.com/post/deploy-shiny-electron/),
[electron-quick-start](https://github.com/ColumbusCollaboratory/electron-quick-start).

### Project setup

-   Create a new shiny application in an RStudio project. Test thorougly
    to make sure everything works as intended. Include
    [validate()](https://shiny.rstudio.com/reference/shiny/1.0.4/validate.html)
    and [need()](https://shiny.rstudio.com/articles/validation.html)
    functions liberally to avoid the possibility your application may
    crash after it has been packaged as a standalone program. Crashes
    typically require that the offending R process be killed using
    Windows Task Manager before the program can be restarted…not ideal
    for end-users. In practice, this is exceedingly rare as long as
    basic best practices are followed.

-   I normally copy finalized shiny code intended to run standalone over
    to a separate applications directory. Create a new folder in your
    applications working directory. In my case this would be
    `C:\Documents\RStudio\Apps`. For the `flight_proof` application used
    as an example below, the path would be:
    `C:\Documents\RStudio\Apps\flight_proof`

-   Download the latest *suitable* version of
    [R-Portable](https://sourceforge.net/projects/rportable/files/R-Portable/)
    to the new folder. Then double-click the (currently)
    `R-Portable_3.6.3.paf.exe` to run. This will create the `R-Portable`
    folder in your new application folder. No admin privileges are
    needed to install `R-Portable`. Although at this writing there is an
    existing `R-Portable_4.0.0_paf.exe`, that version appears to have
    issues with the Rcpp package. Consequently, until an newer version
    of R-Portable is released, use the one listed above.

-   If a 32-bit version of R is needed to run your application, for
    example when a 32-bit MS Access database needs to be accessible, do
    not click `Yes` to the `Run R Portable` checkbox during the
    installation process…as the default assumes you want 64-bit R.

-   Install needed R packages, and package dependencies. Normally you
    would install any required packages by running the `Rgui.exe`
    located at `R-Portable\App\R-Portable\bin\x64`. For the less common
    cases where 32-bit R is needed I normally navigate to the
    `R-Portable\App\R-Portable\bin\i386` folder and then click on
    `Rgui.exe` to open the Rgui. I then install any needed packages
    using 32-bit R. It may not make any difference either way.

-   Using the Rgui (whether 64-bit or 32-bit) open the
    `library_install.R` script located in the
    [refreeze](https://github.com/arestrom/refreeze) repository. You
    will also need the `find_package_dependencies.R` script to do a deep
    recursive search of all required packages and dependencies. Copies
    of these scripts are also normally kept in the `RStudio\Apps`
    folder. Run the dependencies script to identify dependencies, then
    edit the package installation script as needed to add required
    libraries.

-   Copy your `ui.R`, `server.R`, and `global.R` shiny scripts, or any
    other scripts needed for your application, into a folder named
    `shiny` in the top-level directory of your application. For example:
    `C:\Documents\RStudio\Apps\flight_proof\shiny`. There should also be
    a `www` subfolder containing any images, rmarkdown .rmd files, etc.,
    directly under the `shiny` folder.

-   Make sure and edit the `server.R` file to uncomment the `stopApp()`
    function at the very bottom of the `server.R` script. This is needed
    to make sure the `R.exe` is properly closed when the application
    exits. It is normally commented out during development. The function
    looks like this:

``` r
# close the R session when the browser closes
  session$onSessionEnded(function() {
    stopApp()
    q("no")
  })
```

-   The [refreeze](https://github.com/arestrom/refreeze) repository
    contains example materials needed for the next steps. Copy the
    `run.vbs`, `runShinyApp.R`, and `FlightProof.ico` from the
    repository into the top level of your app folder. You should also
    copy the `flight_proof.iss` script that will be needed to create the
    setup executable. I normally keep a copy of all application `.iss`
    scripts in the applications parent directory, in my case
    `C:\Documents\RStudio\Apps`.

-   Rename the `FlightProof.ico` as needed, or find another icon to use.
    There should be no need to edit the other files. You will only need
    to edit `run.vbs` if 32-bit R is needed. In that case the text of
    the `run.vbs` script will be
    `R-Portable\App\R-Portable\bin\i386\R.exe` instead of
    `R-Portable\App\R-Portable\bin\x64\R.exe`.

### Create Windows installer

-   Download and install [Inno
    Setup](http://www.jrsoftware.org/isinfo.php). Then edit a copy of
    the `flight_proof.iss` Inno Setup script, and rename as needed to
    your new application name, for example, `app_name.iss`.

-   Double-click on the `app_name.iss` script to open the `Inno Setup`
    program. In the `AppID` field, highlight all but the first curly
    brace, and under `Tools` click on the `Generate GUID` option. This
    will overwrite the section with a new GUID. Every time you create a
    new version, a new GUID should be generated. Edit the other fields
    as needed to specify things such as the application name and version
    number, the source directory for the application files, and the
    destination directory for the setup executable. Make sure that the
    `PrivilegesRequired` field is set to `none`. This will ensure that
    end-users can run the setup executable without needing
    administrative privileges. In practice I have found that the setup
    dialogue may still ask for an administrative login in order to run
    the installer, but your normal login account name and password will
    work.

-   To create the application setup installer, click on
    `Build – Compile`. This will bundle up all materials needed for you
    application and create an executable installer in your application
    directory. Your application, along with the current version of R and
    all needed packages, are now frozen in time.

### Connecting to databases

-   When needing to connect to databases, providing connection
    credentials requires special handling. A secure and relatively
    foolproof method is to use the `odbc` package, and then set up each
    user with a DSN. This can be done by typing `odbc` into the Windows
    search bar, then clicking on the `ODBC Data Sources` application to
    set up a `User DSN`. Typically, this will be a 64-bit DSN.
    Connecting via ODBC to a `PostgreSQL` database means that you will
    also need to have the [PostgreSQL ODBC
    driver](https://odbc.postgresql.org/) installed on your computer.

-   If you are trying to connect to an `PostgreSQL` database, my current
    favorite method is to use the `RPostgres` package. This may change
    in the future, but for now it provides better handling of uuids and
    odd text encodings. It can also be much faster when writing large
    files. `RPostgres` includes it’s own driver, so no separate driver
    needs to be installed.

#### Storing database connection credentials

-   When connecting via `RPostgres` or other database drivers using
    `RStudio`, a common way to provide connection credentials such as
    `host`, `username` or `password`, is to enter the values in an
    `.Renviron` file. You can then use the `Sys.getenv()` function to
    pull them out. To make this work with `R-Portable` requires some
    customization. The simplest method is to place the `.Renviron` file
    in the `R_HOME` path of your `R-Portable` installation. Then add the
    following line in your global.R file:
    `readRenviron("C:/data/Apps/FlightProof/R-Portable/App/R-Portable/.Renviron")`.
    Note that the path includes the name of your application. You can
    then use `Sys.getenv()` to pull out any of the variables listed in
    the `.Renviron` file. This will work despite the fact that the
    `run.vbs` file invokes `R.exe` using the `--vanilla` flag, which
    instructs R not to read the `.Renviron` file.

-   A safer method to store credentials is to use your operating
    system’s credential manager. This functionality can be accessed
    using the `keyring` package. For Windows users the credentials will
    then be stored as encrypted values in the Windows Credential
    Manager. For an example of how this can be implemented using
    standalone Windows apps, please see the `Chehalis` and `MarSS`
    repositories. Details can be found in the `global.R`, `server.R`,
    and files in the `connect` folder.

### In case of failure

-   If after installing the application, it crashes, or fails to load,
    navigate to the `out.txt` folder in the App directory that the
    installer created, for example:
    `C:\Documents\Intertidal\Apps\FlightProof\out.txt`. The `out.txt`
    file will log the first fatal error encountered. In the case of
    missing dependencies it will identify any packages that you may
    still be missing. Each missing dependency will trigger a crash, so
    in the past, before using the `find_package_dependencies.R` script,
    multiple iterations were typically needed to identify all missing
    package dependencies. Hopefully, this will now be a rare event.

-   In case the application crashes or fails to load, you will also most
    likely need to kill any R processes still active using Windows Task
    Manager. You will then need to fix the source of the crash, usually
    a missing package dependency, and recompile the application.
