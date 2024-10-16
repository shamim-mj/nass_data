##########--------------------------------------------------------------------
##########
########## Weekly Tabular data
##########
##########--------------------------------------------------------------------
week_table <-  function(df, var, county){
  df |> 
    filter(str_detect(short_desc, var) &
             year %in% c(year(Sys.Date())-1, year(Sys.Date()))) |>
    mutate(
      unit_desc = str_replace(unit_desc, "PCT", "%"),
      week = round(parse_number(reference_period_desc)),
      years = case_when(
        !str_detect(short_desc, "PREVIOUS YEAR") &
          !str_detect(short_desc, "5 YEAR") &
          year==year(Sys.Date()) ~ "This Year",
        
        str_detect(short_desc, "PREVIOUS YEAR") &
          year == (year(Sys.Date())-1) ~ "Last Year",
        
        str_detect(short_desc, "5 YEAR") & year == (year(Sys.Date())-1) ~ "5-Yr(Avg)")) |>
    mutate(Month= month(week_ending, label = T, abbr = T), 
           Parameter = var) |> 
    select(years, unit_desc, Parameter, Month, week, Value)|> 
    filter(!is.na(years) ) |>
    group_by(years, Month, Parameter, unit_desc) |> 
    #filter(week == max(week, na.rm = T)) |>
    select(Year = years, Parameter, Unit = unit_desc, Value, Month, Week = week) |> 
    mutate( Value = as.numeric(Value)) |> 
    pivot_wider(id_cols = c(Parameter, Unit, Month, Week),
                values_from = Value, names_from = Year) |> 
    arrange(Month, Week)
}


##########--------------------------------------------------------------------
##########
########## Weekly graphs
##########
##########--------------------------------------------------------------------

week_graph <- function(df, var, crop){
  if(var %in% c("CONDITION", "PROGRESS", "HEIGHT")){
    years <- c(year(Sys.Date())-1, year(Sys.Date()))
  }
  df |> 
    filter(str_detect(short_desc,var) &
             year %in% years) |>
    mutate(week = round(parse_number(reference_period_desc)),
           month = as.Date(week_ending, format = "%Y-%m-%d"),
           status = str_replace(unit_desc, "PCT", "%"),
           Value = as.numeric(Value),
           years = case_when(
             !str_detect(short_desc, "PREVIOUS YEAR") &
               !str_detect(short_desc, "5 YEAR") &
               year == 2024 ~ "This Year",
             str_detect(short_desc, "PREVIOUS YEAR") &
               year == 2023 ~ "Last Year",
             str_detect(short_desc, "5 YEAR") & year == 2023 ~ "5-Yr(Avg)")
    ) %>%
    filter(!is.na(years)) %>%
    mutate(month = month(week_ending, label = T, abbr  = T)) |> 
    select(year, years, month, week, status, Value, `CV (%)`) |> 
    ggplot() +
    geom_line(aes(x = week, y = Value, color = years), size = 1.1) +
    scale_color_manual(values = c("This Year" = "black",
                                  "Last Year" = "cornflowerblue",
                                  "5-Yr(Avg)" = "gold1")) +
    theme(
      legend.position = "top",
      legend.direction = 'horizontal',
      legend.background = element_blank(),
      legend.box = 'vertical', 
      legend.key.width = unit(1, 'cm'), 
      legend.text = element_text(size = 18), 
      strip.text.x = element_text(size = 16, colour = 'black'),
    ) +
    scale_x_continuous(limits = c(min(week(df[df$commodity_desc ==crop, "week_ending"]), na.rm = T),
                                  max(week(df[df$commodity_desc ==crop, "week_ending"]), na.rm = T)),
                       breaks = seq(min(week(df[df$commodity_desc ==crop, "week_ending"]), na.rm = T),
                                    max(week(df[df$commodity_desc ==crop, "week_ending"]), na.rm = T), 5))+
    guides(color = guide_legend(nrow = 1)) +
    labs(
      x = "Week of year",
      y = "Value",
      title = paste(crop, var),
      color = ""
    ) +
    facet_wrap(.~ status, ncol = 3, scales = 'free_x') +
    theme(
      plot.title = element_text(size = 20, face = 'bold'),
      text = element_text(size = 14,
                          family = 'serif',
                          color = 'black',
                          face = 'bold'),
      axis.title = element_text(size = 16,
                                family = 'serif',
                                color = 'black',
                                face = 'bold'),
      axis.text = element_text(color = 'black', size = 15), 
      axis.title.y = element_blank()
    )
}


##########--------------------------------------------------------------------
##########
########## Monthly data and graphs
##########
##########--------------------------------------------------------------------











##########--------------------------------------------------------------------
##########
########## Annual data and graphs
##########
##########--------------------------------------------------------------------



# this function return data in annual form for the stat-------------------------
annual_table_state <- function(df, start_year, stop_year) {
  df %>%
    filter(reference_period_desc == "YEAR" & year %in% c(start_year:stop_year)) %>% # it considers year only not time point
    mutate(full_season = ifelse(str_detect(short_desc, "DOUBLE"),
                                "Double Crop", "Full Season"),
           y_var = paste0(statisticcat_desc, " (", unit_desc, ")"),
           y_var = ifelse(commodity_desc =="SOYBEANS" & y_var == "AREA PLANTED (PCT)",
                          "ACRES PLANTED (%; DOUBLE CROP)", y_var),
           Value = as.numeric(str_replace_all(Value, ",", ""))) |> # round the number
    select(YEAR = year, STATE = state_alpha, y_var, full_season, Value) |>
    # group_by(Year, y_var, state_alpha, full_season) |> 
    #   reframe(Value = mean(Value, na.rm = T)) |> 
    pivot_wider(id_cols = c(YEAR, STATE), names_from = y_var,
                values_fn = mean, values_from = Value) |> 
    arrange(YEAR)|> 
    mutate( across(where(is.numeric), round)) |> 
    # select(YEAR, STATE, "AREA PLANTED (ACRES)",
    #       # "AREA HARVESTED (ACRES)" ,
    #        "YIELD (BU / ACRE)", "PRODUCTION (BU)",
    #        "ACRES PLANTED (%; DOUBLE CROP)",
    #        "PRODUCTION ($)" )
    select(where(~!all(is.na(.))))
}


plot_annual <- function(data, voi, state, crop) {
  data |>
    select(YEAR, value = voi) |> 
    #ggpubr::ggline(x = "YEAR", y = "value")+
    ggplot()+
    geom_line(aes(x = YEAR, y = value))+
    geom_point(aes(x=YEAR, y =value))+
    scale_x_continuous(limits = c(min(data$YEAR, na.rm = T), max(data$YEAR, na.rm = T)),
                       breaks = seq(min(data$YEAR, na.rm = T), max(data$YEAR, na.rm = T)))+
    scale_y_continuous(labels = scales::comma, n.breaks = 5)+
    labs(y = "", x = "", title = paste(crop, voi, "IN", state))+
    theme_bw()+
    theme(text = element_text(size = 12, colour = 'black', face = 'bold'), 
          axis.text = element_text(size = 12, colour = 'black', face = 'bold'),
          axis.title = element_text(size = 14, colour = 'black', face = 'bold'),
          axis.text.x = element_text(angle = 45, size = 12, color = 'black', face = 'bold', hjust = 1),
          plot.title = element_text(size = 18, colour = 'black', face = 'bold'))
}



# annual_table_county <- function(df, start_year, stop_year) {
#       
#   df %>%
#         filter(reference_period_desc == "YEAR" & year %in% c(start_year:stop_year)) %>% # it considers year only not time point
#         mutate(full_season = ifelse(str_detect(short_desc, "DOUBLE"),
#                                     "Double Crop", "Full Season"),
#                y_var = paste0(statisticcat_desc, " (", unit_desc, ")"),
#                y_var = ifelse(commodity_desc =="SOYBEANS" & y_var == "AREA PLANTED (PCT)",
#                               "ACRES PLANTED (%; DOUBLE CROP)", y_var),
#                Value = as.numeric(str_replace_all(Value, ",", ""))) |> # round the number
#         select(YEAR = year, STATE = state_alpha, COUNTY = county_name, y_var, full_season, Value) |>
#         pivot_wider(id_cols = c(YEAR, STATE, COUNTY), values_fn = mean, names_from = y_var,values_from = Value) |> 
#         arrange(YEAR, COUNTY)|> 
#         mutate( across(where(is.numeric), round)) |> 
#     select(YEAR, STATE, "AREA PLANTED (ACRES)",
#            #"AREA HARVESTED (ACRES)" ,
#            "YIELD (BU / ACRE)", "PRODUCTION (BU)",
#            "ACRES PLANTED (%; DOUBLE CROP)",
#            "PRODUCTION ($)" )
# }

# annual_table_county(data$data) |> View()
# annual_table_state(data$data) |> view()
# it plots spatial data---------------------------------------------------------

sf_plot <- function(data, state, voi, year){
    
    # Load spatial data for counties
    counties <- urbnmapr::get_urbn_map(map = 'counties', sf = TRUE) %>%
      mutate(county_name = str_replace(county_name, " County", ""), 
             county_code = str_sub(county_fips, -3)) %>%
      filter(state_abbv == state)
      
      #----------------join another dataset
    df <- data %>%
        mutate(Value = as.numeric(str_replace_all(Value, ",", "")), 
               status = paste0(statisticcat_desc, " (", unit_desc, ")")) %>% 
        rename(state_abbv = state_alpha) |> 
        filter(year== year & state_abbv == state & status == voi) |> 
        select(state_abbv, county_name, county_code, Value, status, commodity_desc, year) |> 
        as_tibble()
      #---------join statement
    join_df <- left_join(counties, df,
      by = c("county_code")
    )
    
    join_df |> 
      #select(where(~!all(is.na(.)))) |> 
      # Plot the data
      ggplot() +
      geom_sf(aes(fill =Value)) +
      scale_fill_gradient2(low = "green", mid = "yellow", high = "red",
                           midpoint = median(join_df$Value, na.rm = TRUE),
                           na.value = "grey50", 
                           labels = scales::label_comma()) +
      labs(fill = "", title =voi,
           x = "Latitude", y = "Longitude",
           caption = "\nGray color indicates the data has not been reported yet!") +
      theme_bw() +
      theme(legend.position = "right",
            text = element_text(size = 14, colour = 'black', face = 'bold',
                                family = 'serif'),
            axis.title = element_text(size = 16, colour = 'black', face = 'bold'),
            #axis.text = element_text(size = 16, colour = 'black', face = 'bold'),
            plot.title.position = "panel") +
      coord_sf(crs = st_crs(4326), lims_method = "geometry_bbox")
    
}



#sf_plot(data$data, "KY", "AREA PLANTED (ACRES)", 2022)



