library(dash)
library(dashBootstrapComponents)
library(ggplot2)
library(plotly)
library(purrr)
library(ggthemes)



df <- read.csv("data/athlete_events.csv")
df_new <- df %>%
  select(Year, Team, Sport, Medal, Sex) %>%
  filter(Sport=='Gymnastics')
countries<- c(unique(df_new$Team))
years <- c(unique(df_new$Year))


app <- Dash$new(external_stylesheets = dbcThemes$BOOTSTRAP)
app$layout(
  div(
    list(
      dbcRow(list(
               h1("Olympics Data Analysis")
              )
      ),
      dbcRow(
        list(
          dbcCol(
                 list(
                   dccGraph(id = "bar_chart"),
                   dccSlider(
                     id = "slider",
                     min = 2004,
                     max = 2016,
                     step = 4,
                     marks = list(2004, 2008, 2012, 2016),
                     value = 2004
                    ),
                   dccDropdown(
                     id = "dropdown",
                     options = countries,
                     value = c("United States")
                  )
                )
          )
          ),
        )
      )
  )
)


app$callback(
  output("bar_chart", "figure"),
  list(
    input("slider", "value"),
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


app$run_server(host="0.0.0.0")

