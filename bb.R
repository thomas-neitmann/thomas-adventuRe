library(ggcharts)
library(dplyr)
data("biomedicalrevenue")

label <- function(x) {
  if (x %in% c("Roche", "Novartis")) {
    paste0("<span style='color:#D52B1E'>**", x, "**</span>")
  } else {
    paste0("<span style='color:gray'>", x, "</span>")
  }
}

spec <- ggcharts::highlight_spec(
  what = c("Roche", "Novartis"),
  highlight_color = "#D52B1E",
  other_color = "gray"
)

biomedicalrevenue %>%
  filter(year == 2018) %>%
  bar_chart(
    company,
    revenue,
    highlight = spec,
    top_n = 10
  ) +
  scale_x_discrete(labels = Vectorize(label)) +
  labs(
    x = NULL,
    y = "Revenue in 2018 (Billion USD)",
    title = glue::glue("Two {shiny::span('**Swiss**', style='color:#D52B1E')} Companies Are Among The Top 10 Big Pharma")
  ) +
  mdthemes::md_theme_minimal_vgrid() +
  theme(plot.title.position = "plot")
