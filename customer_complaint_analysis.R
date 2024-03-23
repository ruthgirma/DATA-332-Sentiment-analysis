library(tidyverse)
library(ggplot2)
library(lubridate)
library(readxl)
library(wordcloud)
library(sentimentr)
library(tidytext)
library(textdata) 
library(janeaustenr)
library(dplyr)
library(stringr)
library(reshape2)

rm(list=ls())

# set the working directory
setwd("~/Desktop/DATA332R ")

# Import the file
complaints_table <- read.csv('~/Desktop/Consumer_Complaints.csv')

# Data clean up, renaming some columns

colnames(complaints_table)[1]<-"Date_recieved"
colnames(complaints_table)[6]<-"Consumer_complaint"
colnames(complaints_table)[15]<-"Company_response"

#selecting the company and the consumer complaints
company_consumer_complaints <-complaints_table%>%
  dplyr::select(Company, Consumer_complaint)


get_sentiments("afinn")
get_sentiments("bing")
get_sentiments("nrc") 

"Separating the sentence into word units, row by row."
Word_by_row <- company_consumer_complaints%>%
  group_by(Company) %>%
  mutate(linenumber = row_number())%>%
  ungroup() %>%
  unnest_tokens(word, Consumer_complaint)

# Eliminating unnecessary words.

Word_by_row <- Word_by_row %>%
  anti_join(stop_words)
Word_by_row<-filter(Word_by_row, word != "xxxx" )
Word_by_row<-filter(Word_by_row, word != "xx" )

nrc_joy <- get_sentiments("nrc") %>% 
  filter(sentiment == "joy")

# Inner joining words to determine sentiment values
Word_by_row %>%
  filter(Company == "Bank of America") %>%
  inner_join(nrc_joy) %>%
  count(word, sort = TRUE)

#Values representing positive, negative, and overall sentiment for each company.
new_complaints_data <- Word_by_row %>%
  inner_join(get_sentiments("bing")) %>%
  count(Company, index = linenumber %/% 80, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)

# Generating pivot tables to compare sentiments across top and bottom performing companies.
df_new_table <- new_complaints_data %>% group_by(Company) %>% 
  summarise(sum_sentiment=sum(sentiment),
            .groups = 'drop') %>%
  as.data.frame()

#put the data above in descending order
df_descending_order <-df_new_table[order(df_new_table$sum_sentiment, decreasing = TRUE),]

Top_ten_companies <- df_descending_order[1:10,]

# 1. Graph of top ten performing companies

ggplot(data = Top_ten_companies, aes(Company, sum_sentiment, fill = Company)) +
  geom_histogram(stat = "identity") +
  labs(title = "Top 10 companies with positive sentiment score", x = "Company", y = "Sentiment value") +
  theme(axis.text = element_text(angle = 60, hjust = 1)) + 
  scale_fill_manual(values = c('Blue', 'Violet', 'Red', 'Orange', 'Yellow', 'pink', 'skyblue', 'darkgreen', 'white', 'coral'))


# 2. Graph of top ten companies with negative sentiment

Lowest_ten_companies <- df_descending_order[2687:2696,]
ggplot(data = Top_ten_companies, aes(Company, sum_sentiment, fill = Company)) +
  geom_histogram(stat = "identity") +
  labs(title = "Top ten companies with negative sentiments", x = "Company", y = "Sentiment value") +
  theme(axis.text = element_text(angle = 60, hjust = 1)) + 
  scale_fill_manual(values = c('Blue', 'Violet', 'Red', 'Orange', 'Yellow', 'pink', 'skyblue', 'darkgreen', 'white', 'coral'))


# Counting sentiments in the dataset using both nrc and bing. 
get_sentiments("nrc") %>% 
  filter(sentiment %in% c("positive", "negative")) %>% 
  count(sentiment)

get_sentiments("bing") %>% 
  count(sentiment)


bing_counts <- Word_by_row %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

# 3.Comparison graph of positive and negative sentiments

bing_counts %>%
  group_by(sentiment) %>%
  slice_max(n, n = 12) %>% 
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment",
       y = NULL)
 

# Most common words in the customer complaints
bing_counts %>%
  anti_join(stop_words) %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))








