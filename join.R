# Join worldbank data with the Barro-Lee data
library(tidyverse)
library(here)

# Load WB data
wb_data <- read_csv(here("data/raw/f12f8fa3-51de-4740-ad3c-6974f6dfeba7_Data.csv"))
wb_data <- wb_data %>% 
    drop_na()
# Force to numeric
wb_data <- wb_data %>%
    mutate(`2010 [YR2010]` = as.numeric(`2010 [YR2010]`))

# Load Barro-Lee data
bl_data <- read_csv(here("data/raw/BL2013_MF1599_v2.2.csv"))
bl_data_2010 <- bl_data %>% 
    filter(year == 2010)

# Pivot the WB data
wb_data_wide <- wb_data %>% 
    select(-`Series Code`) %>% 
    pivot_wider(names_from = `Series Name`,
                values_from = `2010 [YR2010]`)

# Label year
wb_data_wide <- wb_data_wide %>% 
    mutate(wb_year = "2010")

# Join with the Barro-Lee data
joined_df <- bl_data_senegal %>% 
    left_join(wb_data_wide,
              by = c("country" = "Country Name"))

# Plot an example scatterplot
joined_df %>% 
    ggplot(aes(x = lu,
               y = `Adjusted net enrollment rate, primary (% of primary school age children)`)) + 
    geom_smooth(method = "lm") +
    geom_point()


