# DATA-332-Sentiment-analysis  
# By: Ruth Girma  

# Introduction
This project studied how people felt in complaints about companies and services. 

# Dictionary
The main variables that were used in this sentiment analysis were:

    1. Company: the names of the bank or banks involved.
    2. Consumer complaint narrative: the complaints made by customers to the company.

# Data cleaning
1. Renaming some of the columns so that it is easier to use 
Some column names contained spaces, periods, and commas, which made it challenging to use them accurately. Therefore, I adjusted some of the names to improve usability  
```
colnames(complaints_table)[1]<-"Date_recieved"
colnames(complaints_table)[6]<-"Consumer_complaint"
colnames(complaints_table)[15]<-"Company_response"
```
2. Selecting the company and the consumer complaints
In this section, I selected the company and consumer complaints to make a further analysis. I wanted to use these variables to do the sentiment analysis of the companies.
```
company_consumer_complaints <-complaints_table%>%
  dplyr::select(Company, Consumer_complaint)
```
3. Dividing the sentence into individual words, one row at a time
In this part, the sentences of the customer complaints were broken down into their constituent words, and each word was placed on a separate row for further analysis or processing.
```
Word_by_row <- company_consumer_complaints%>%
  group_by(Company) %>%
  mutate(linenumber = row_number())%>%
  ungroup() %>%
  unnest_tokens(word, Consumer_complaint)
```
4. Eliminating unnecessary words.
In this section, I removed unnecessary words that weren't used to describe the emotions of the customers and weren't relevant to the sentiment analysis
```
Word_by_row <- Word_by_row %>%
  anti_join(stop_words)
Word_by_row<-filter(Word_by_row, word != "xxxx" )
Word_by_row<-filter(Word_by_row, word != "xx" )
```
# Data analysis
# Top 10 companies with positive sentiment  
## This graph shows the top ten companies that are perceived positively based on some sentiment analysis
<img src = "Images/Top 10 companies with positive sentiment score.png" height = 300, width = 500>  

# Top 10 companies with negative sentiment   
## This graph identifies and ranks the top ten companies based on the prevalence of negative sentiment in customer complaints   
<img src = "Images/Top 10 companies with negative sentiment score.png" height = 300, width = 500>  

# Sentiment Contribution Analysis  
## This graph examines and shows the individual contributions of various factors or entities to the overall sentiment expressed in a dataset
<img src = "Images/Contribution to sentiment graph.png" height = 300, width = 500>  

# Wordclouds   
## This image shows the words that occur most frequently in the complaints data, allowing for a quick understanding of the prevalent topics or issues raised by customers
<img src = "Images/Wordcloud.png" height = 300, width = 500>  

