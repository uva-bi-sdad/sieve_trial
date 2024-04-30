library(data.table)

adcw_regions <- fread("data/adcw_regions_usa_states_counties.csv")
county_values <- fread("data/usa_summary.csv")
us_values <- fread("data/admin1_summary.csv")

# combine state and county data
state_county_values <- rbind(county_values, us_values)

# add fips to county_values
state_county_values_fips <- merge(state_county_values, adcw_regions, by.x = "region_id", by.y = "adcw_id")

# transform to long format
state_county_values_fips_lng <-
  melt(
    state_county_values_fips[,-1:-3],
    id.vars = c("geoid", "state", "county"),
    variable.name = "measure"
  )

# add year and moe columns
state_county_values_fips_lng[, "year" := "2022"]
state_county_values_fips_lng[, "moe" := NA]

#select final columns
state_county_values_fips_lng_fnl <- state_county_values_fips_lng[, .(geoid, year, measure, value, moe)]

#write to file
fwrite(state_county_values_fips_lng_fnl, "data/us_stct_2022_digital_twin_analyzer_data.csv")
