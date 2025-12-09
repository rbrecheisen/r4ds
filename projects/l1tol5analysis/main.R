library(tidyverse)
library(patchwork)

scores_file_path <- "D:\\Mosamatic\\L1-L5\\Out\\defaultpipeline\\calculatescorestask\\bc_scores.csv"


load_original_scores <- function(file_path) {
  original_scores <- readr::read_delim(file_path, delim = ";", locale = readr::locale(decimal_mark = "."))
  return(original_scores)
}


pivot_scores <- function(scores) {
  scores_wide <- scores |>
    mutate(
      patient = stringr::str_extract(file, "^.+(?=_L[0-9]+[A-Z]\\.dcm$)"),
      slice   = stringr::str_extract(file, "L[0-9]+[A-Z](?=\\.dcm$)")
    ) |>
    filter(!is.na(slice)) |>
    pivot_wider(
      id_cols    = patient,
      names_from = slice,
      values_from = c(
        muscle_area, 
        muscle_ra,
        vat_area,    
        vat_ra,
        sat_area,    
        sat_ra
      ),
      names_glue = "{.value}_{slice}",
      values_fn  = \(x) x[1]
    )
}

scores <- load_original_scores(file_path = scores_file_path)
scores <- pivot_scores(scores)

generate_plot <- function(scores, tissue_prop) {
  scores_tissue_prop <- scores |>
    select(starts_with(tissue_prop))
  base_column <- paste0(tissue_prop, "_L3M")
  pvals <- tibble(
    column = setdiff(names(scores_tissue_prop), base_column),
    p_value = sapply(setdiff(names(scores_tissue_prop), base_column), function(col) {
      t.test(scores_tissue_prop[[col]], scores_tissue_prop[[base_column]])$p.value
    })
  )
  pvals <- pvals %>%
    mutate(
      slice_num = readr::parse_number(column),
      slice_pos = str_extract(column, "[BMO]"),
      slice_pos = factor(slice_pos, levels = c("O", "M", "B"))  # correct anatomical order
    )
  p <- ggplot(pvals, aes(x = p_value, y = fct_reorder2(column, slice_pos, slice_num))) +
    geom_point(size = 3) +
    geom_text(aes(label = sprintf("%.3g", p_value)), nudge_x = 0.02, size = 3, hjust = 0) +
    geom_vline(xintercept = 0.05, linetype = "dashed", color = "red") +
    scale_x_continuous("p-value") +
    scale_y_discrete(limits = rev) +
    ylab("Column") +
    theme_minimal()
  return(p)
}

tissue_props <- c(
  "muscle_area",
  "muscle_ra",
  "sat_area",
  "sat_ra",
  "vat_area",
  "vat_ra"
)

plots <- lapply(tissue_props, function(tp) {
  generate_plot(scores, tissue_prop = tp)
})

names(plots) <- tissue_props

wrap_plots(plots, ncol = 2)

readr::write_delim(scores, "D:/Mosamatic/L1-L5/Out/bc_scores_wide.csv", delim = ';')