library(dash)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(purrr)
library(ggthemes)
library(dashHtmlComponents)



df <- read.csv("data/athlete_events.csv")
df_new <- df %>%
  select(Year, Team, Sport, Medal, Sex) %>%
  filter(Sport=='Gymnastics')
countries<- c(unique(df_new$Team))
years <- c(unique(df_new$Year))


app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)
# app$layout(
#   dbcContainer(
#   div(
#     list(
#       dbcRow(list(
#                h1("Olympics Data Analysis")
#               )
#       ),
#       dbcRow(
#         list(
#           dbcCol(
#                  list(
#                    dccGraph(id = "bar_chart"),
#                    ,
#
#                   )
#                 )
#           )
#           ),
#         )
#       )
#   )
# ))

app$layout(
  dbcContainer(
    list(
      htmlH1(
        "Olympics Data Analysis"
      ),
      dbcLabel("Select Country", className = "h7"),
      dccDropdown(
        id = "dropdown",
        options = countries,
        value = c("United States")
      ),
      htmlHr(),
      dbcLabel("Select Year", className = "h7"),
      dccSlider(
        id = "year_id",
        min = 2004,
        max = 2016,
        step = 4,
        marks = list(
          "2004" = "2004",
          "2008" = "2008",
          "2012" = "2012",
          "2016" = "2016"
        ),
        value = 2004,
        className = "mb-4"
      ),
      htmlHr(),
      htmlBr(),
      dccGraph(id = "bar_chart")
    ),
    className = "g-0"
  )
)

app$callback(
  output("bar_chart", "figure"),
  list(
    input("year_id", "value"),
    input("dropdown", "value")
  ),
  function(selected_year, country) {
    p <- ggplot(df_new %>%
                  filter(Year == selected_year & Team == country)) +
      aes(x = Medal,
          fill = Sex,
      ) +
      geom_bar(position = 'dodge', stat='count') +
      ggthemes::scale_color_tableau()
    ggplotly(p)
  }
)


app$run_server(host='0.0.0.0')

