#!/usr/bin/env python
# coding: utf-8

# In[52]:

# https://thingspeak.com/channels/511581/feed.csv?api_key=QQ7HDZJTJ86BRRNF&offset=0&average=&round=2&start=2019-02-01%2000:00:00&end=2019-02-02%2000:00:00
# https://thingspeak.com/channels/511581/feed.csv?api_key=QQ7HDZJTJ86BRRNF&round=2&start=2019-02-05%2000:00:00&end=2019-02-08%2000:00:00

import requests
import os.path
from bs4 import BeautifulSoup
from cgi import parse_header
import pandas as pd


# In[44]:


# File save path.
# save_path = '/Users/Alex/Desktop/Value Names/' # no need for a path
# advance files are written to the current working directory


# In[29]:


# Get website session with requests.
result = requests.get('https://www.purpleair.com/sensorlist')
t = result.text


# In[32]:


# Soupify.
soup = BeautifulSoup(t, 'lxml')


# In[118]:


input_vals = soup.find_all('input',{'name':'p_sensor'})
value_list = [x.get('value') for x in input_vals]
split_vals = [x.split('|') for x in value_list]

all_anchors = soup.find_all('a')
hrefs = [x.get('href') for x in all_anchors]
# filter out anchors that are not 'map'
# parse remaning anchors, grab query parameters, grab lat, lng, inc
# find the inc in split_values to find other sensor


# In[140]:


new_name = 'value_df'
ext = '.csv'
file_name = new_name + ext
complete_name = file_name #os.path.join(save_path, file_name)
'''
n = open(complete_name, 'w+')

n.write(inputs)

n.close()
'''


# In[141]:


value_df = pd.DataFrame(split_vals, columns = {'val1','val2'})
sorted_df = value_df.sort_values(by = ['val1'])
sorted_df.reset_index(drop = True, inplace = True)
value_df.to_csv(complete_name)


# In[63]:





# In[70]:


# input_df = pd.DataFrame.from_records(input_raw)


# In[71]:


# print(input_df.head(3))


# In[ ]:




