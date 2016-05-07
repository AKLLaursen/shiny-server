dashboardPage(

  dashboardHeader(
    title = "MYCROFT",
    titleWidth = 200
  ),

  dashboardSidebar(
    width = 200,
    sidebarMenu(
      menuItem("Markets", tabName = "markets", icon = icon("line-chart"),
               collapsible =
                 menuSubItem("Stocks", tabName = "stocks"),
                 menuSubItem("Futures", tabName = "futures"),
                 menuSubItem("Bonds", tabName = "bonds"),
                 menuSubItem("Currencies", tabName = "currencies"),
                 menuSubItem("Commodities", tabName = "commodities")),

      menuItem("Economic Measures", tabName = "economic-measures", icon = icon("bank"),
               collapsible =
                 menuSubItem("GDP", tabName = "gdp"),
                 menuSubItem("Unemployment", tabName = "unemployment"),
                 menuSubItem("Inflation", tabName = "inflation"),
                 menuSubItem("Interest Rate", tabName = "interest-rate"),
                 menuSubItem("Current Account Balance", tabName = "current-account-balance"),
                 menuSubItem("International Trade", tabName = "international-trade"),
                 menuSubItem("Private Consumption", tabName = "private-consumption"),
                 menuSubItem("Investment", tabName = "investment")),

      menuItem("National Accounts", tabName = "national-accounts", icon = icon("th")),

      menuItem("Environment", tabName = "environment", icon = icon("th")),

      menuItem("Living Conditions", tabName = "living-conditions", icon = icon("th")),

      menuItem("Capital Markets", tabName = "capital-markets", icon = icon("th")),

      menuItem("Elections", tabName = "elections", icon = icon("th"))
  )),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = "stocks",
              fluidRow(
                column(
                  12,
                  h1("Stocks", align = "center")
                ),
                uiOutput("returns"),
                column(
                  4,
                  selectInput("stock_type",
                              "Select chart type",
                              c("Line Plot", "Candlestick"),
                              "Candlestick",
                              width = "100%")
                ),
                column(
                  4,
                  selectInput("stock_geography",
                              "Select area",
                              names(get_stock_list()),
                              width = "100%")
                ),
                column(
                  4,
                  actionButton("get_data",
                               "Updata Data",
                               width = "100%")
                ),
                column(
                  12,
                  uiOutput("plots")
                ),
                loading_indicator())),
      tabItem(tabName = "futures",
              h1("Futures")),
      tabItem(tabName = "bonds",
              h1("Bonds")),
      tabItem(tabName = "currencies",
              h1("Currencies")),
      tabItem(tabName = "commodities",
              h1("Commodities")),
      tabItem(tabName = "gdp",
              h1("GDP")),
      tabItem(tabName = "unemployment",
              h1("Unemployment")),
      tabItem(tabName = "interest-rate",
              h1("Interest Rate")),
      tabItem(tabName = "current-account-balance",
              h1("Current Account Balance")),
      tabItem(tabName = "international-trade",
              h1("International Trade")),
      tabItem(tabName = "private-consumption",
              h1("Private Consumption")),
      tabItem(tabName = "investment",
              h1("Investment"))
    )
  )
)
