# r3-workshop
Reproducible Reporting with R (R^3) for marine ecosystem indicators

## Render website

For some reason, RStudio's Build pane Build Website button keeps trying to render as bookdown. Instead using this command in the R Console:

```r
rmarkdown::render_site(".")
fs::file_touch("docs/.nojekyll") # git config core.fileMode false
```

