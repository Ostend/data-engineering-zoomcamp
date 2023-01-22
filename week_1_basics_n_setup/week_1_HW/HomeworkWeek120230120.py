#!/usr/bin/env python
# coding: utf-8

# In[19]:


import pandas as pd
from sqlalchemy import create_engine
from time import time


# In[2]:


engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')


# In[12]:


df_iter = pd.read_csv('green_tripdata_2019-01.csv', iterator=True, chunksize=100000)


# In[13]:


df = next(df_iter)


# In[14]:


df.head()


# In[15]:


df.lpep_pickup_datetime=pd.to_datetime(df.lpep_pickup_datetime)
df.lpep_dropoff_datetime=pd.to_datetime(df.lpep_dropoff_datetime)


# In[16]:


print(df.head(n=0).to_sql(name='green_taxi_data', con=engine, if_exists='replace'))


# In[17]:


df.to_sql(name='green_taxi_data', con=engine, if_exists='append')


# In[20]:


while True:
    try: 
        t_start = time()
        df = next(df_iter)

        df.lpep_pickup_datetime=pd.to_datetime(df.lpep_pickup_datetime)
        df.lpep_dropoff_datetime=pd.to_datetime(df.lpep_dropoff_datetime)

        df.to_sql(name='green_taxi_data', con=engine, if_exists='append')

        t_end = time()


        print("batch loaded, took: %.3f seconds" % (t_end - t_start))
        
    except StopIteration:
        print("Finished ingesting data into the postgres database")
        break


# In[22]:


df_iter2=pd.read_csv('taxi+_zone_lookup.csv', iterator=True, chunksize=100000)


# In[23]:


df2 = next(df_iter2)


# In[24]:


df2.head()


# In[25]:


df2.head(n=0).to_sql(name='taxi_zone', con=engine, if_exists='replace')


# In[26]:


df2.to_sql(name='taxi_zone', con=engine, if_exists='append')


# In[28]:


while True:
    try: 
        t_start = time()

        df2 = next(df_iter2)

        df2.to_sql(name='taxi_zone', con=engine, if_exists='append')

        t_end = time()

        print("batch loaded. Took: %.3f" % (t_end - t_start))
    except StopIteration:
        print("finished ingesting data")
        break

    


# In[ ]:




