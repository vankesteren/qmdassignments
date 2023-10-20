# qmdassignments

Convenient RStudio addin for working with qmd assignments:

- Create an assignment from a basic template
- Render assignments to two files with one click: one file with questions only and one with solutions
- Add new questions with automatic numbering with a small RStudio snippet

## Getting started

```r
remotes::install_github("vankesteren/qmdassignments")
```

and then run

```r
qmdassignments::create()
```

(or go to Addins > create assignment in the toolbar)

NB: save this file as a .qmd file, not an .Rmd file as the save dialog suggests!
