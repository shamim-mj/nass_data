navbarMenu(title = "WHEATHER DATA",
           menuName = 'weather',
           tabPanel(title = "TABLE", 
                    value = 'single',
                    sidebarLayout(
                      sidebarPanel(
                        h3("PARAMETERS"),
                        h3(" "),
                        h3(" "),
                        textInput(inputId = 'lat',
                                  label = 'Latitude', placeholder = 38.0364354),
                        textInput(inputId = 'lon',
                                  label = 'Longitude', placeholder =   -84.5000352),
                        dateInput('start_date',
                                  label = "Start date"), 
                        dateInput('stop_date', 
                                  label = "Stop date"),
                        submitButton("Submit")),
                      mainPanel(
                        DTOutput('wheather_data'),
                        br(),
                        downloadButton(outputId = "downloadDataweather",
                                       label = "Download Dataset")))
           ),
           tabPanel(title = "CHART", 
                    value = 'single_chart',
                    sidebarLayout(
                      sidebarPanel(
                        h3("PARAMETERS"),
                        textInput(inputId = 'lat_c',
                                  label = 'Latitude', placeholder = 38.0364354),
                        textInput(inputId = 'lon_c',
                                  label = 'Longitude', placeholder =   -84.5000352),
                        selectInput('freq',
                                    label = "Frequency", 
                                    choices = c("DAILY", 
                                                "MONTHLY",
                                                "ANNUAL")),
                        selectInput('param_c',
                                    label = "Variable", 
                                    choices = c("Tmin", 
                                                "Tmean",
                                                "Tmax",
                                                "Precipitation", 
                                                "Relative_Humidity",
                                                "Radiation_All_Sky", 
                                                "Radiation_Clear_Sky")),
                        selectInput('col_c',
                                    label = "Chart color", 
                                    choices = c("blue", 
                                                "black",
                                                "darkblue",
                                                "cornflowerblue", 
                                                "red",
                                                'darkred',
                                                'green', 
                                                "forestgreen",
                                                'cyan', 
                                                'orange', 
                                                'yellow', 
                                                'purple', 
                                                'brown',
                                                'gold',
                                                'gray',
                                                'pink')),
                        dateInput('start_date_c',
                                  label = "Start date"), 
                        dateInput('stop_date_c', 
                                  label = "Stop date"), 
                        submitButton("Submit")),
                      mainPanel(
                        plotOutput("weather_plot", 
                                   height = "500px", 
                                   width = "100%")))
           ), 
           
           tabPanel(title = "KY Weather", 
                    value = 'ky_weather',
                    HTML("
                                           <h3>Welcome to the Kentucky Weather Information Page</h3>
                                           <p>This tab provides links to weather information for Kentucky. For detailed weather forecasts and data, you can visit:</p>
                                           <ul>
                                             <li><a href='https://www.kymesonet.org/' target='_blank'>KENTUCKY MESONET | WKU</a></li>
                                             <li><a href='http://weather.uky.edu/' target='_blank'>UK Ag WEATHER CENTER</a></li>
                                           </ul>
                                           <p>Stay updated with the latest weather conditions!</p>
                                   "))
           
)




#### Insersion removed from the server and ui
#### server

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

# "tabular_annual_county" = list(
#   key = api_key,
#   commodity_desc = input$crop_at_county,
#   year__GE = input$annual_county_slide[1],
#   year__LE = input$annual_county_slide[2],
#   freq_desc = "ANNUAL",
#   agg_level_desc = "COUNTY",
#   state_alpha = input$annual_county
# ),
# 
# 
#---------weekly spatial--------------
# 
### note that we do not have weekly data reported for each county. 
# output$weekly_sp_plot <- renderPlot({
#   if(input$main == "spatial_weekly"){
#     sf_plot(input$spatial_weekly_state, input$spatial_weekly_county)
#   }
# }) 
# 
# #county level data
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
#### ui
# tabPanel(title = "SPATIAL",
#          value = "spatial_weekly",
#          sidebarLayout(
#            sidebarPanel(
#              h4("WEEKLY SPATIAL"), br(),
#              selectInput("spatial_weekly_state", "Select State:",
#                          choices = states,
#                          selected = "KY"),
#              #selectInput("spatial_weekly_county", "Select County:", choices = NULL),
#              selectInput(inputId = 'crop_ws',
#                          label = 'Select Crop:',
#                          choices = list("SOYBEANS",
#                                         "CORN",
#                                         "WHEAT")),
#              selectInput(inputId="voi_ws",
#                          label = "Select Variable:", 
#                          choices = list("CONDITION", 
#                                         "PROGRESS",
#                                         "HEIGHT"))
#            ),
#            mainPanel(
#              plotOutput("weekly_sp_plot"))
#          )
# )
),

# navbarMenu(title = "MONTHLY",
#            menuName = 'monthly_menu',
#            tabPanel(title = "TABULAR",
#                     value = 'tabular_monthly',
#                     sidebarLayout(
#                       sidebarPanel(
#                         h4("MONTHLY DATA"), br(),
#                         selectInput("monthly_state", "Select State:",
#                                     choices = states,
#                                     selected = "KY"),
#                         selectInput("monthly_county", "Select County:", choices = NULL),
#                         selectInput(inputId = 'crop_mt',
#                                     label = 'Select Crop:',
#                                     choices = list("SOYBEANS",
#                                                    "CORN",
#                                                    "WHEAT",
#                                                    "TOBACCO"))
#                       ),
#                       mainPanel(
#                         DTOutput("monthly_reports"),
#                         br(),
#                         downloadButton(outputId = "downloadDataMonthly",
#                                        label = "Download Dataset")),
#                     ),
#                     
#            ),
#            tabPanel(title = "CHARTS",
#                     value = "chart_monthly",
#                     sidebarLayout(
#                       sidebarPanel(
#                         h4("MONTHLY GRAPHS"), br(),
#                         selectInput("chart_monthly_state", "Select State:",
#                                     choices = states, 
#                                     selected = "KY"),
#                         selectInput("chart_monthly_county", "Select County:", choices = NULL),
#                         selectInput(inputId = 'crop_mc',
#                                     label = 'Select Crop:',
#                                     choices = list("SOYBEANS",
#                                                    "CORN",
#                                                    "WHEAT", 
#                                                    "TOBACCO"))
#                       ),
#                       mainPanel(
#                         plotOutput("monthly_plot"))
#                     ),
#            ),
#            tabPanel(title = "SPATIAL",
#                     value = "spatial_monthly",
#                     sidebarLayout(
#                       sidebarPanel(
#                         h4("MONTHLY SPATIAL"), br(),
#                         selectInput("spatial_monthly_state", "Select State:",
#                                     choices = states, 
#                                     selected = "KY"),
#                         selectInput("spatial_monthly_county", "Select County:", choices = NULL),
#                         selectInput(inputId = 'crop_ms',
#                                     label = 'Select Crop:',
#                                     choices = list("SOYBEANS",
#                                                    "CORN",
#                                                    "WHEAT",
#                                                    "TOBACCO"))
#                       ), 
#                       mainPanel(
#                         plotOutput("monthly_plot_sf"))
#                     ),
#            )),


# tabPanel(title = "TABULAR COUNTY DATA",
#          value = 'tabular_annual_county',
#          sidebarLayout(
#            sidebarPanel(
#              h4("ANNUAL COUNTY LEVEL DATA"), br(),
#              selectInput("annual_county", "Select State:",
#                          choices = states, 
#                          selected = "KY"),
#              selectInput(inputId = 'crop_at_county',
#                          label = 'Select Crop:',
#                          choices = list("SOYBEANS",
#                                         "CORN",
#                                         "WHEAT",
#                                         "TOBACCO")),
#              sliderInput('annual_county_slide', "YEARS",
#                          min = 1980, max = year(Sys.Date()), sep = "",
#                          value = c(2020, year(Sys.Date()))
#              )
#            ),
#            mainPanel(
#              DTOutput('annual_report_county'),
#              br(),
#              downloadButton(outputId = "downloadDataAnnualCounty",
#                             label = "Download Dataset"))
#          
# )),



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
                   ), 
                   
                   
  )
  
  # Debugging: Print the params to verify
  
  
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








navbarMenu(title = "WHEATHER DATA",
           menuName = 'weather',
           tabPanel(title = "TABLE", 
                    value = 'single',
                    sidebarLayout(
                      sidebarPanel(
                        h3("PARAMETERS"),
                        h3(" "),
                        h3(" "),
                        textInput(inputId = 'lat',
                                  label = 'Latitude', placeholder = 38.0364354),
                        textInput(inputId = 'lon',
                                  label = 'Longitude', placeholder =   -84.5000352),
                        dateInput('start_date',
                                  label = "Start date"), 
                        dateInput('stop_date', 
                                  label = "Stop date"),
                        submitButton("Submit")),
                      mainPanel(
                        DTOutput('wheather_data'),
                        br(),
                        downloadButton(outputId = "downloadDataweather",
                                       label = "Download Dataset")))
           ),
           tabPanel(title = "CHART", 
                    value = 'single_chart',
                    sidebarLayout(
                      sidebarPanel(
                        h3("PARAMETERS"),
                        textInput(inputId = 'lat_c',
                                  label = 'Latitude', placeholder = 38.0364354),
                        textInput(inputId = 'lon_c',
                                  label = 'Longitude', placeholder =   -84.5000352),
                        selectInput('freq',
                                    label = "Frequency", 
                                    choices = c("DAILY", 
                                                "MONTHLY",
                                                "ANNUAL")),
                        selectInput('param_c',
                                    label = "Variable", 
                                    choices = c("Tmin", 
                                                "Tmean",
                                                "Tmax",
                                                "Precipitation", 
                                                "Relative_Humidity",
                                                "Radiation_All_Sky", 
                                                "Radiation_Clear_Sky")),
                        selectInput('col_c',
                                    label = "Chart color", 
                                    choices = c("blue", 
                                                "black",
                                                "darkblue",
                                                "cornflowerblue", 
                                                "red",
                                                'darkred',
                                                'green', 
                                                "forestgreen",
                                                'cyan', 
                                                'orange', 
                                                'yellow', 
                                                'purple', 
                                                'brown',
                                                'gold',
                                                'gray',
                                                'pink')),
                        dateInput('start_date_c',
                                  label = "Start date"), 
                        dateInput('stop_date_c', 
                                  label = "Stop date"), 
                        submitButton("Submit")),
                      mainPanel(
                        plotOutput("weather_plot", 
                                   height = "500px", 
                                   width = "100%")))
           ), 
           
           tabPanel(title = "KY Weather", 
                    value = 'ky_weather',
                    HTML("
                                           <h3>Welcome to the Kentucky Weather Information Page</h3>
                                           <p>This tab provides links to weather information for Kentucky. For detailed weather forecasts and data, you can visit:</p>
                                           <ul>
                                             <li><a href='https://www.kymesonet.org/' target='_blank'>KENTUCKY MESONET | WKU</a></li>
                                             <li><a href='http://weather.uky.edu/' target='_blank'>UK Ag WEATHER CENTER</a></li>
                                           </ul>
                                           <p>Stay updated with the latest weather conditions!</p>
                                   "))
           
)