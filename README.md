# Cyclistic Bike Share Analysis

This project focuses on analyzing data from Cyclistic, a bike-sharing company. The goal of the project is to extract insights from bike usage data, identify trends in user behavior, and provide recommendations to the business based on data-driven conclusions.

## Table of Contents

- [Project Overview](#project-overview)
- [Technologies Used](#technologies-used)
- [Data Source](#data-source)
- [Key Insights](#key-insights)
- [Example Analysis](#example-analysis)

---

## Project Overview

- **Description**: The Cyclistic bike-share analysis project investigates how different customer segments (casual users vs. annual members) use Cyclistic's bike service. The analysis involves identifying patterns in the data, visualizing these patterns, and ultimately making recommendations to the business.
  
- **Objective**: 
  - Compare the behavior of **casual riders** and **annual members**.
  - Analyze ride duration, ride frequency, and time-of-day patterns.
  - Provide actionable insights to increase membership.

---

## Technologies Used

- **Python**: For data cleaning, analysis, and visualization.
- **Pandas**: For data manipulation and transformation.
- **Matplotlib/Seaborn**: For creating visualizations to support data insights.
- **Jupyter Notebook**: For interactive data analysis and sharing findings.

---

## Data Source

- The dataset used in this project comes from Cyclistic's public trip data, which includes information on **ride start time**, **end time**, **ride duration**, **starting station**, **ending station**, and **user type (casual or member)**.

- **Dataset Access**: The data can be downloaded from [Divvy Bike Data](https://divvy-tripdata.s3.amazonaws.com/index.html), which provides historical data on bike trips for analysis.

---

## Key Insights

- **Ride Duration**: Casual riders tend to take longer rides than annual members.
- **Peak Usage Times**: Annual members primarily use the service during weekday commutes (morning and evening rush hours), while casual riders tend to ride on weekends.
- **Conversion Opportunity**: There is a potential opportunity to convert casual riders to annual members by targeting them with marketing campaigns that focus on the benefits of membership (such as reduced cost for frequent riders).

---

## Example Analysis

### 1. Comparing Ride Duration Between Casual Riders and Members
```python
import pandas as pd
import matplotlib.pyplot as plt

# Load dataset
df = pd.read_csv('cyclistic_trip_data.csv')

# Separate data for casual riders and members
casual_riders = df[df['user_type'] == 'casual']
members = df[df['user_type'] == 'member']

# Plot ride duration comparison
plt.figure(figsize=(10, 6))
plt.hist(casual_riders['ride_duration'], bins=50, alpha=0.5, label='Casual Riders')
plt.hist(members['ride_duration'], bins=50, alpha=0.5, label='Members')
plt.xlabel('Ride Duration (minutes)')
plt.ylabel('Frequency')
plt.title('Comparison of Ride Duration Between Casual Riders and Members')
plt.legend()
plt.show()

```
### 2. Peak Ride Hours for Members and Casual Riders

```python
import seaborn as sns
# Convert start time to datetime and extract hour
df['start_time'] = pd.to_datetime(df['start_time'])
df['start_hour'] = df['start_time'].dt.hour

# Plot ride frequency by hour for casual riders and members
plt.figure(figsize=(12, 6))
sns.countplot(x='start_hour', hue='user_type', data=df)
plt.title('Ride Frequency by Hour (Casual vs Members)')
plt.xlabel('Hour of the Day')
plt.ylabel('Ride Count')
plt.show()
