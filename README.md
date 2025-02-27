# SQL_Google_Merchandise_Store_Analysis

## 1. Introduction and Motivation

E-commerce businesses rely on data analytics to optimize user experience, improve conversion rates, and maximize revenue. This analysis leverages Google Analytics data from the Google Merchandise Store in Google BigQuery's public dataset to extract valuable insights into user behavior, traffic sources, and purchasing patterns.

By analyzing session data, transaction details, and product interactions, we aim to understand key performance indicators (KPIs) such as visit trends, bounce rates, revenue generation, and customer purchasing behavior over specific time periods.

## **2. The Goal of the Project**

By leveraging session-level and product-level data, we aim to extract meaningful insights that can help optimize business strategies, improve user engagement, and enhance conversion rates.

Specifically, this project focuses on:

- Understanding User Engagement and Traffic Trends
- Revenue and Conversion Performance
- Customer Purchase Behavior and Product Analysis
- Business Impact and Optimization Opportunities

## **3. Import Raw Data**

To access the eCommerce dataset in Google BigQuery's public datasets, follow these steps:

1. Sign in to your Google Cloud Platform (GCP) account and create a new project.
2. Open the BigQuery console and select the project you just created.
3. In the navigation panel, click "Add Data", then select "Search a project".
4. Enter the project ID "bigquery-public-data.google_analytics_sample.ga_sessions" and press Enter.
5. Locate and click on the "ga_sessions_" table to explore the dataset.
