shinyServer(function(input, output, session) {

  autoRefresh <- reactiveTimer(intervalMs = 3600000, session)

  data_stock <- reactive({

    autoRefresh()
    input$get_data

    # Get data from Quandl based on security type and geographic
    lapply(get_stock_list(), function(x) {
      lapply(x, function(y) {
        cat(paste("Getting", y, "data\n", sep = " "))
        Quandl(y, type = "xts")
      })
    })

  })

  output$plots <- renderUI({

    # Generate list of Highcharts outputs - kind of hacky, as the plots have to
    # have the exact same name here and in the observer, where the plot is
    # being rendered.
    plot_output_list <- lapply(1:(data_stock() %>%
                                    `[[`(input$stock_geography) %>%
                                    length()),
                               function(x) {

      plotname <- paste("plot", x, sep = "_")
      highchartOutput(plotname, height = 500)

    })

    # Convert the list to a tagList - this is necessary for the list of items
    # to display properly.
    do.call(tagList, plot_output_list)
  })

  output$returns <- renderUI({

    return_output_list <- lapply(1:(data_stock() %>%
                                      `[[`(input$stock_geography) %>%
                                      length()), function(x) {

      return_name <- paste("return", x, sep = "_")
      valueBoxOutput(return_name, width = floor(12 / (data_stock() %>%
                                                        `[[`(input$stock_geography) %>%
                                                        length())))

    })

    do.call(tagList, return_output_list)
  })

  # Call renderPlot for each plot. Plots are only actually generated when they
  # are visible on the web page.
  observe({

    for (x in 1:(data_stock() %>%
                 `[[`(input$stock_geography) %>%
                 length())) {

      # Need local so that each item gets its own number. Without it, the value
      # of i in the renderPlot() will be the same across all instances, because
      # of when the expression is evaluated.
      local({
        x_local <- x

        plotname <- paste("plot", x_local, sep = "_")
        return_name <- paste("return", x_local, sep = "_")

        output[[plotname]] <- renderHighchart({

          if (input$stock_type == "Candlestick") {

            plot_candlestick(data_stock() %>%
                               `[[`(input$stock_geography) %>%
                               `[`(x_local))

          } else if (input$stock_type == "Line Plot") {

            plot_line(data_stock() %>%
                        `[[`(input$stock_geography) %>%
                        `[`(x_local))

          }

        })

        output[[return_name]] <- renderValueBox({

          ret_t <- data_stock() %>%
            `[[`(input$stock_geography) %>%
            `[[`(x_local) %>%
            last() %>%
            `$`("Close")
          ret_t1 <- data_stock() %>%
            `[[`(input$stock_geography) %>%
            `[[`(x_local) %>%
            lag.xts() %>%
            last() %>%
            `$`("Close")

          out_return <- paste0(round((ret_t - ret_t1) / ret_t1 * 100, 2), "%")

          text <- paste(data_stock() %>%
                          `[[`(input$stock_geography) %>%
                          `[`(x_local) %>%
                          names(),
                        data_stock() %>%
                          `[[`(input$stock_geography) %>%
                          `[[`(x_local) %>%
                          index() %>%
                          max(),
                        sep = " - ")

          valueBox(out_return, text, width = floor(12 / (data_stock() %>%
                                                           `[[`(input$stock_geography) %>%
                                                           length())))
        })


      })
    }
  })

})
