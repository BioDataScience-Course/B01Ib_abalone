# Check exercises for the project

options(cli.num_colors = 256)
options(cli.hyperlink = TRUE)
library(testthat)
local_edition(3)
library(parsermd)
suppressMessages(library(learnitgrid))
#SciViews::R(lang = "fr", silent = TRUE)

source("tools_tests.R")

test_dir("testthat", reporter = sddReporter, times = 20L)
