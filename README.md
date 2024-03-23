# DATA-332-Sentiment-analysis  
# By: Ruth Girma  

# Introduction
This project studied how people felt in complaints about banks and related services.  

# Dictionary
The main variables that were used in this sentiment analysis were:

    1. Company: the names of the bank or banks involved.
    2. Consumer complaint narrative: the complaints made by customers to the company.

# Data cleaning
## Renaming some of the columns so that it is easier to use 
'''
colnames(complaints_table)[1]<-"Date_recieved"
colnames(complaints_table)[6]<-"Consumer_complaint"
colnames(complaints_table)[15]<-"Company_response"
'''
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

