source("helpers.R")

# readRenviron("C:\\Users\\msh404\\Documents\\.Renviron")

server <- function(input, output, session) {
  
  
  
  ##########--------------------------------------------------------------------
  ##########
  ########## Retrieving data 
  ##########
  ##########--------------------------------------------------------------------
  

   #weekly table -------------------------------------------------------
  # weekly table -------------------------------------------------------
  nass_data <- reactive({
    # Read the API key from the environment variable
    # api_key <-Sys.getenv("NASS_API_KEY") # "39B010C2-1084-369B-A35B-187D918F1EB3"
    api_key <-"39B010C2-1084-369B-A35B-187D918F1EB3"
    
    # Check if the API key was read correctly
    if (api_key == "") {
      stop("API key not found. Please set the NASS_API_KEY environment variable.")
    }
    
    # Base URL for the API request
    base_url <- "https://quickstats.nass.usda.gov/api/api_GET/"
    
    # Debugging: Print the active tab
    # print(paste("Active Tab:", input$main))
    
    # Define the parameters based on the selected tab
    params <- switch(input$main,
                     "tabular_weekly" = list(
                       key = api_key,
                       commodity_desc = input$crop_wt,
                       year__GE = 2020,
                       year__LE = year(Sys.Date()),
                       freq_desc = "WEEKLY",
                       agg_level_desc = "STATE",
                       state_alpha = input$weekly_state
                     ),
                     "chart_weekly" = list(
                       key = api_key,
                       commodity_desc = input$crop_wc,
                       year__GE = 2020,
                       year__LE = year(Sys.Date()),
                       freq_desc = "WEEKLY",
                       agg_level_desc = "STATE",
                       state_alpha = input$chart_weekly_state
                     ),
                     "tabular_annual_state" = list(
                       key = api_key,
                       commodity_desc = input$crop_at_state,
                       year__GE = input$annual_state_slide[1],
                       year__LE = input$annual_state_slide[2],
                       freq_desc = "ANNUAL",
                       agg_level_desc = "STATE",
                       state_alpha = input$annual_state
                     ),
                     # "tabular_annual_county" = list(
                     #   key = api_key,
                     #   commodity_desc = input$crop_at_county,
                     #   year__GE = input$annual_county_slide[1],
                     #   year__LE = input$annual_county_slide[2],
                     #   freq_desc = "ANNUAL",
                     #   agg_level_desc = "COUNTY",
                     #   state_alpha = input$annual_county
                     # ),
                     "chart_annual" = list(
                       source_desc = "SURVEY",
                       key = api_key,
                       sector_desc = "CROPS",
                       group_desc = "FIELD CROPS",
                       commodity_desc = input$crop_ac,
                       year__GE = input$annual_state_chart_slide[1],
                       year__LE = input$annual_state_chart_slide[2],
                       freq_desc = "ANNUAL",
                       agg_level_desc = "STATE",
                       state_alpha = input$chart_annual_state
                     ),
                     "spatial_annual" = list(
                       source_desc = "SURVEY",
                       key = api_key,
                       sector_desc = "CROPS",
                       group_desc = "FIELD CROPS",
                       commodity_desc = input$crop_as,
                       year__GE = input$start_year_s,
                       year__LE = year(Sys.Date()),
                       freq_desc = "ANNUAL",
                       agg_level_desc = "COUNTY",
                       state_alpha = input$spatial_annual_state
                     )
    )
    
    # Debugging: Print the params to verify
    # print(params)
    
    # Send the request to the API
    response <- GET(base_url, query = params)
    
    # Check if the request was successful
    if (http_status(response)$category == "Success") {
      # Parse the JSON content
      data <- fromJSON(content(response, as = "text", encoding = "UTF-8"), flatten = TRUE)

      # Extract the data frame
      soybean_data <- data$data
      return(soybean_data)
    } else {
      print("Failed to fetch data")
      return(NULL) # Return NULL if the request fails
    }
  })
  
  

    
    

  
  
  
  
  
  
  ##########--------------------------------------------------------------------
  ##########
  ########## Functions
  ##########
  ##########--------------------------------------------------------------------
  
  
  

  
  #########################---------------------##################################
  ######################### weekly settings----##################################
  
  
  #---------weekly report table-------
  #
  output$weekly_reports <- renderDT({
    week_table(nass_data(), input$voi_wt)
  })
  
  #---------weekly graph--------------
  # 

  output$weekly_plot <- renderPlot({
        week_graph(nass_data(), input$voi_wc, input$crop_wc)
  })
  
  #---------weekly graph--------------
  # 
  output$downloadDataWeekly <- downloadHandler(
    filename = function () {
      paste(input$crop_wt, "Weekly_Report_", now(tzone = "EDT"),
            ".csv", sep = "")}, 
    content = function(file){
      write.csv(week_table(nass_data(), input$voi_wt), file, row.names = F, na = "")
    }
  )
  
  #---------weekly spatial--------------
  # 
  ### note that we do not have weekly data reported for each county. 
  # output$weekly_sp_plot <- renderPlot({
  #   if(input$main == "spatial_weekly"){
  #     sf_plot(input$spatial_weekly_state, input$spatial_weekly_county)
  #   }
  # })
  
#########################---------------------##################################
######################### Monthly settings----##################################
  
  
  
#########################---------------------##################################
######################### Annual settings----##################################
  
  #---------annual table--------------
  
  output$annual_report_state <- renderDT({
    annual_table_state(nass_data(), input$annual_state_slide[1], input$annual_state_slide[2])
  })
  
  # download the data
  output$downloadDataAnnualState <- downloadHandler(
      filename = function(){
        paste("Annual-State-Level-Date", now(), ".csv", sep = "")},
      content = function(file) {
        write.csv(annual_table_state(nass_data(),input$annual_state_slide[1], input$annual_state_slide[2]), file, row.names = F, na ="")
      })
  
  #county level data
  # output$annual_report_county <- renderDT({
  #   annual_table_county(nass_data(), input$annual_county_slide[1], input$annual_county_slide[2])
  # })
  # 
  # # download the data
  # output$downloadDataAnnualCounty <- downloadHandler(
  #   filename = function(){
  #     paste("Annual-County-Level-Date", now(), ".csv", sep = "")},
  #   content = function(file) {
  #     write.csv(annual_table_county(nass_data()), file, row.names = F, na ="")
  #   })
  # 
  
  
  #---------Annual charts---------------
  output$annual_plot <- renderPlot({
    
    tryCatch(
      {
    plot_annual(annual_table_state(nass_data(), input$annual_state_chart_slide[1], input$annual_state_chart_slide[2]),
                input$voi_ac, input$chart_annual_state, input$crop_ac)
      },
      error = function(e) {
        showNotification("Apologize for the inconvenience, please check the parameters and try again!", type = "error")
      }
    )
    

  })
  
  
  #---------annaul spatial--------------
  
  output$annual_plot_sf <- renderPlot({
    tryCatch(
      {
        sf_plot(nass_data(), input$spatial_annual_state, input$spatial_annual_voi, input$start_year_s)
      },
      error = function(e) {
        showNotification("Apologize for the inconvenience, the data is not reported and cannot be plotted!", type = "error")
      }
    )
  })
  
  
  
  ##################------------------------------------#######################
  ##################
  ##################
  ################## the following functions are used to supplement UI county
  ##################
  ##################
  ##################-----------------------------------#########################
  ##################
  ##################
  ##################
  
  
  #### weekly data for condition and progress is not reported
  #### 
  #### 
  
  
  
  
  # observeEvent(input$weekly_state, {
  #   selected_state <- input$weekly_state
  #   counties_in_state <- counties |>
  #     filter(state_abbv == selected_state) |>
  #     pull(county_name)
  #   
  #   updateSelectInput(session, "weekly_county", choices = c("All",counties_in_state))
  # })
  # 
  
  # 
  # observeEvent(input$chart_weekly_state, {
  #   selected_state <- input$chart_weekly_state
  #   counties_in_state <- counties |>
  #     filter(state_abbv == selected_state) |>
  #     pull(county_name)
  #   
  #   updateSelectInput(session, "chart_weekly_county", choices = c("All",counties_in_state))
  # })
  # 
  

  # observeEvent(input$spatial_weekly_state, {
  #   selected_state <- input$spatial_weekly_state
  #   counties_in_state <- counties |>
  #     filter(state_abbv == selected_state) |>
  #     pull(county_name)
  #   
  #   updateSelectInput(session, "spatial_weekly_county", choices = c("All",counties_in_state))
  # })
  # 
  observeEvent(input$monthly_state, {
    selected_state <- input$monthly_state
    counties_in_state <- counties |>
      filter(state_abbv == selected_state) |>
      pull(county_name)
    
    updateSelectInput(session, "monthly_county", choices = c("All",counties_in_state))
  })
  
  observeEvent(input$chart_monthly_state, {
    selected_state <- input$chart_monthly_state
    counties_in_state <- counties |>
      filter(state_abbv == selected_state) |>
      pull(county_name)
    
    updateSelectInput(session, "chart_monthly_county", choices = c("All",counties_in_state))
  })
  
  observeEvent(input$spatial_monthly_state, {
    selected_state <- input$spatial_monthly_state
    counties_in_state <- counties |>
      filter(state_abbv == selected_state) |>
      pull(county_name)
    
    updateSelectInput(session, "spatial_monthly_county", choices = c("All",counties_in_state))
  })
  
  # observeEvent(input$annual_state, {
  #   selected_state <- input$annual_state
  #   counties_in_state <- counties |>
  #     filter(state_abbv == selected_state) |>
  #     pull(county_name)
  #   
  #   updateSelectInput(session, "annual_county", choices = c("All",counties_in_state))
  # })
  
# 
#   observeEvent(input$spatial_annual_state, {
#     vois <- data$data |>
#       mutate(status = paste0(statisticcat_desc, " (", unit_desc, ")")) |>
#       distinct(status) |>
#       pull(status)
# 
#     updateSelectInput(session, "spatial_annual_voi", choices = vois)
#   })


  
  # observeEvent(input$spatial_annual_state, {
  #   selected_state <- input$spatial_annual_state
  #   counties_in_state <- counties |>
  #     filter(state_abbv == selected_state) |>
  #     pull(county_name)
  #   
  #   updateSelectInput(session, "spatial_annual_county", choices = c("All",counties_in_state))
  # })
  

  
  
  
  
  
  
} # closing server function 


