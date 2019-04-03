Randomize
CreateObject("Wscript.Shell").Run "R-Portable\App\R-Portable\bin\x64\R.exe CMD BATCH --vanilla --slave runShinyApp.R out.txt" & " " & RND & " ", 0, False
