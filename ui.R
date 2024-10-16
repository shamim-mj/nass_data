library(urbnmapr)
# Get the counties data with sf format
counties <- urbnmapr::get_urbn_map(map = "counties", sf = TRUE) |>
  mutate(county_name = str_replace(county_name, " County", ""))

# Get unique state abbreviations
states <- sort(unique(counties$state_abbv))


ui <- navbarPage(title = "NASS",
                 id = 'main',
                 # #h3("NATIONAL AGRICULTURAL STATISTICAL SERVICES (NASS)"),
                 # tabPanel("HOME", icon = "🏠", value = 'home',
                 #          div(includeMarkdown("about.md"),
                 #              align="justify")),
                 navbarMenu(title = "WEEKLY",
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
                            ),
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
                 
                 navbarMenu(title = "ANNUAL",
                            menuName = 'annual_menu',
                            tabPanel(title = "STATE DATA",
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
                                         # selectInput(inputId = 'start_year_t',
                                         #             label = "From:",
                                         #             choices = seq(2000, year(Sys.Date())), 
                                         #             selected = 2020),
                                         # selectInput(inputId = 'stop_year_t',
                                         #              label = "To [must be bigger than above]:",
                                         #              choices = seq(2000, year(Sys.Date())),
                                         #              selected = year(Sys.Date())),
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
                            ))
)




