#!/usr/bin/env python
# coding: utf-8

# In[8]:


from bs4 import BeautifulSoup
import requests
import time
import datetime


import smtplib


# In[34]:


URL = 'https://www.walmart.com/ip/Sony-PlayStation-5-Video-Game-Console/1736740710'

headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"}

page = requests.get(URL, headers=headers)

soup1 = BeautifulSoup(page.content, "html.parser")

soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

title = soup2.find(id='main-title').get_text()

price = soup2.find(itemprop='price').get_text()

print(title)

print(price)







# In[20]:


price = price.strip()[1:]
title = title.strip()

print(title)
print(price)


# In[21]:


import datetime

today = datetime.date.today()

print(today)


# In[22]:


import csv 

header = ['Title', 'Price', 'Date']
data = [title, price, today]


with open('WalmartWebScraperDataset.csv', 'w', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)


# In[27]:


import pandas as pd

df = pd.read_csv(r'C:\Users\white\WalmartWebScraperDataset.csv')

print(df)


# In[26]:


with open('WalmartWebScraperDataset.csv', 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)


# In[31]:


def check_price(): 
    URL = 'https://www.walmart.com/ip/Sony-PlayStation-5-Video-Game-Console/1736740710'

    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"}

    page = requests.get(URL, headers=headers)

    soup1 = BeautifulSoup(page.content, "html.parser")

    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

    title = soup2.find(id='main-title').get_text()

    price = soup2.find(itemprop='price').get_text()

    print(title)

    print(price)
    
    price = price.strip()[1:]
    title = title.strip()
    
    import datetime

    today = datetime.date.today()
    
    import csv 

    header = ['Title', 'Price', 'Date']
    data = [title, price, today]
    
    with open('WalmartWebScraperDataset.csv', 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)



# In[32]:


while(True): 
    check_price()
    time.sleep(5)


# In[ ]:




