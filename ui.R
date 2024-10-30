library(urbnmapr)
# Get the counties data with sf format
counties <- urbnmapr::get_urbn_map(map = "counties", sf = TRUE) |>
  mutate(county_name = str_replace(county_name, " County", ""))

# Get unique state abbreviations
states <- sort(unique(counties$state_abbv))


ui <-  fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")  # Link to your custom CSS
  ),
  
  
  
  
                  div(
                    img(src = "uk-extension-logo.png", style = "display: block; margin: auto; width: auto; max-width: 100%; height: auto; max-height:100px; padding-bottom: 10px"),
                    style = "text-align: center; background-color: #0033A0; display: block; margin: auto; width: auto; max-width: 100%; padding-bottom: 10px",
                    style = "padding-bottom: 10px;"
                  ),
        navbarPage(title = "",
                 id = 'main',
                 
                 tabPanel("HOME",
                          div(
                            h2("Welcome to the NASS Data Viewer"),
                            p("Developed by Dr. Mohammad Shamim, Extension Associate, University of Kentucky"),
                            p("Modified with suggestions from Dr. Chad Lee."),
                            p("This web application provides data on soybean, corn, and wheat progress, conditions, yield, and more."),
                            p("The data presented here is sourced from the United States Dpartment of Agriculture National Agricultural Statistics Service (USDA-NASS)."),
                            h3("How to Use the App"),
                            p("The NASS Data Viewer is an interactive web application designed to help users explore agricultural data for various crops such as soybeans, corn, wheat, and tobacco.
                            To begin, navigate to the 'PROGRESS & CONDITION' tab, where you can choose between viewing data in 'TABLE' or 'CHARTS' format.
                              In the 'TABLE' view, select the state and crop of interest from the dropdown menus to retrieve weekly reports on crop conditions, progress, and height.
                              You can download the dataset by clicking the 'Download Dataset' button. In the 'CHARTS' view, generate graphical representations of crop conditions and progress by selecting the desired options.
                              Navigate to the 'YIELD & YIELD ATTRRIBUTES' where you can choose between viewing data in the in the state-levele ('TABLE', 'CHARTS') and county-level 'SPATIAL' format", style = "text-align: justify; padding: 0px;"),
                            p("Please note: We do not accept any liability for the accuracy, completeness, or usefulness of the data provided. Users should verify all information with other reliable sources.
                              For more information, please vist ", a("USDA-NASS", href = "https://www.nass.usda.gov", target = "_blank"), "!"),
                            p("For questions or inquiries, feel free to contact us at mshamim11@uky.edu."),
                            br(),
                            p("If you are interested in this kind of intereactive tools, you can check our", a("NASA POWER DATA Viewer!", href = "https://uk-extension.shinyapps.io/weather/", target = "_blank"))
            
                          )
                 ),

                 
                 navbarMenu(title = "PROGRESS & CONDITION",
                            menuName = 'weekly_menu',
                            tabPanel(title = "TABLE",
                                     value = 'tabular_weekly',
                                     sidebarLayout(
                                       sidebarPanel(
                                         h4("WEEKLY DATA"), br(),
                                         selectInput("weekly_state", "Select State:",
                                                     choices = states, 
                                                     selected = "KY"),
                                         #selectInput("weekly_county", "Select County:", choices = NULL),
                                         selectInput(inputId = 'crop_wt',
                                                     label = 'Select Crop:',
                                                     choices = list("SOYBEANS",
                                                                    "CORN",
                                                                    "WHEAT",
                                                                    "TOBACCO")),
                                         selectInput(inputId="voi_wt",
                                                     label = "Select Variable:", 
                                                     choices = list("CONDITION", 
                                                                    "PROGRESS",
                                                                    "HEIGHT"))
                                       ),
                                       mainPanel(
                                         DTOutput('weekly_reports'),
                                         br(),
                                         downloadButton(outputId = "downloadDataWeekly",
                                                        label = "Download Dataset"))
                                     )
                                     
                            ),
                            tabPanel(title = "CHARTS",
                                     value = "chart_weekly",
                                     sidebarLayout(
                                       sidebarPanel(
                                         h4("WEEKLY GRAPHS"), br(),
                                         selectInput("chart_weekly_state", "Select State:",
                                                     choices = states,
                                                     selected = "KY"),
                                         #selectInput("chart_weekly_county", "Select County:", choices = NULL),
                                         selectInput(inputId = 'crop_wc',
                                                     label = 'Select Crop:',
                                                     choices = list("SOYBEANS",
                                                                    "CORN",
                                                                    "WHEAT", 
                                                                    "TOBACCO")),
                                         selectInput(inputId="voi_wc",
                                                     label = "Select Variable:", 
                                                     choices = list("CONDITION", 
                                                                    "PROGRESS"))
                                       ),
                                       mainPanel(
                                         plotOutput("weekly_plot",
                                                    width = "800px",
                                                    height =  "600px"))
                                     )
                            )),

                 navbarMenu(title = "YIELD & YIELD ATTRIBUTES",
                            menuName = 'annual_menu',
                            tabPanel(title = "TABLE",
                                     value = 'tabular_annual_state',
                                     sidebarLayout(
                                       sidebarPanel(
                                         h4("ANNUAL STATE LEVEL DATA"), br(),
                                         selectInput("annual_state", "Select State:",
                                                     choices = states, 
                                                     selected = "KY"),
                                         selectInput(inputId = 'crop_at_state',
                                                     label = 'Select Crop:',
                                                     choices = list("SOYBEANS",
                                                                    "CORN",
                                                                    "WHEAT",
                                                                    "TOBACCO")),
                                         sliderInput('annual_state_slide', "YEARS",
                                                     min = 1980, max = year(Sys.Date()),sep = "",
                                                     value = c(2020, year(Sys.Date()))
                                                    )
                                       ),
                                       mainPanel(
                                         DTOutput('annual_report_state'),
                                         br(),
                                         downloadButton(outputId = "downloadDataAnnualState",
                                                        label = "Download Dataset"))
                                     )),
                            

                            tabPanel(title = "CHARTS",
                                     value = "chart_annual",
                                     sidebarLayout(
                                       sidebarPanel(
                                         h4("ANNUAL GRAPHS"), br(),
                                         selectInput("chart_annual_state", "Select State:",
                                                     choices = states,
                                                     selected = "KY"),
                                         # selectInput("chart_annual_county", "Select County:", choices = NULL),
                                         selectInput(inputId = 'crop_ac',
                                                     label = 'Select Crop:',
                                                     choices = list("SOYBEANS",
                                                                    "CORN",
                                                                    "WHEAT")),
                                         selectInput(inputId = "voi_ac", label = "Variable", 
                                                     choices = c("AREA PLANTED (ACRES)",
                                                                 "YIELD (BU / ACRE)", "PRODUCTION (BU)",
                                                                 #"ACRES PLANTED (%; DOUBLE CROP)",
                                                                 "PRODUCTION ($)" ), 
                                                     selected = "YIELD (BU / ACRE)"),
                                         sliderInput('annual_state_chart_slide', "YEARS",
                                                     min = 1980, max = year(Sys.Date()),sep = "",
                                                     value = c(2020, year(Sys.Date()))
                                         )
                                       ),
                                       mainPanel(
                                         plotOutput("annual_plot"))
                                     ),
                            ),
                            tabPanel(title = "SPATIAL",
                                     value = 'spatial_annual',
                                     sidebarLayout(
                                       sidebarPanel(
                                         h4("ANNUAL SPATIAL"), br(),
                                         selectInput("spatial_annual_state", "Select State:",
                                                     choices = states,
                                                     selected = "KY"),
                                         #selectInput("spatial_annual_county", "Select County:", choices = NULL),
                                         selectInput(inputId = 'crop_as',
                                                     label = 'Select Crop:',
                                                     choices = list("SOYBEANS",
                                                                    "CORN",
                                                                    "WHEAT")),
                                         selectInput("spatial_annual_voi", "Select Variable:",
                                                     choices = c("AREA PLANTED (ACRES)",
                                                                 "AREA HARVESTED (ACRES)",
                                                                 "PRODUCTION (BU)",
                                                                 "YIELD (BU / ACRE)",
                                                                 "SALES ($)",
                                                                 "SALES (OPERATIONS)")),
                                         
                                         selectInput(inputId = 'start_year_s',
                                                     label = "Year:",
                                                     choices = seq(2000, year(Sys.Date())), 
                                                     selected = 2020),
                                         # numericInput(inputId = 'stop_year',
                                         #              label = "To:",
                                         #              value = year(Sys.Date()))
                                       ),
                                       mainPanel(
                                         plotOutput("annual_plot_sf"))
                                     ),
                            )),
   
        )

)



