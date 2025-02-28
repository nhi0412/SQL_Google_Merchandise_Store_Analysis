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

## **4. Read and Explain Dataset**

[Google Analytics BigQuery Guide For Dataset](https://support.google.com/analytics/answer/3437719?hl=en)

| **Field Name** | **Data Type** | **Description** |
| --- | --- | --- |
| fullVisitorId | STRING | The unique visitor ID. |
| date | STRING | The date of the session in YYYYMMDD format. |
| totals | RECORD | This section contains aggregate values across the session. |
| totals.bounces | INTEGER | Total bounces (for convenience). For a bounced session, the value is 1, otherwise it is null. |
| totals.hits | INTEGER | Total number of hits within the session. |
| totals.pageviews | INTEGER | Total number of pageviews within the session. |
| totals.visits | INTEGER | The number of sessions (for convenience). This value is 1 for sessions with interaction events. The value is null if there are no interaction events in the session. |
| totals.transactions | INTEGER | Total number of ecommerce transactions within the session. |
| trafficSource.source | STRING | The source of the traffic source. Could be the name of the search engine, the referring hostname, or a value of the utm_source URL parameter. |
| hits | RECORD | This row and nested fields are populated for any and all types of hits. |
| hits.eCommerceAction | RECORD | This section contains all of the ecommerce hits that occurred during the session. This is a repeated field and has an entry for each hit that was collected. |
| hits.eCommerceAction.action_type | STRING | The action type. Click through of product lists = 1, Product detail views = 2, Add product(s) to cart = 3, Remove product(s) from cart = 4, Check out = 5, Completed purchase = 6, Refund of purchase = 7, Checkout options = 8, Unknown = 0.|
| hits.product | RECORD | This row and nested fields will be populated for each hit that contains Enhanced Ecommerce PRODUCT data. |
| hits.product.productQuantity | INTEGER | The quantity of the product purchased. |
| hits.product.productRevenue | INTEGER | The revenue of the product, expressed as the value passed to Analytics multiplied by 10^6 (e.g., 2.40 would be given as 2400000). |
| hits.product.productSKU | STRING | Product SKU. |
| hits.product.v2ProductName | STRING | Product Name. |

## 5. Exploring the Dataset

1. **How do total visits, page views, and transactions vary across January, February, and March 2017?**

```sql
SELECT FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
      ,SUM(totals.visits) AS visits
      ,SUM(totals.pageviews) AS pageviews
      ,SUM(totals.transactions) AS transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix BETWEEN '0101' AND '0331'
GROUP BY month
ORDER BY month ASC;
```

| **month** | **visits** | **pageviews** | **transactions** |
| --- | --- | --- | --- |
| 201701 | 64694 | 257708 | 713 |
| 201702 | 62192 | 233373 | 733 |
| 201703 | 69931 | 259522 | 993 |

The analysis of user engagement and transactions across January, February, and March 2017 shows notable trends. January (64,694) and February (62,192) had similar visit numbers, while March (69,931) saw a significant increase in visits. Pageviews followed a similar pattern, with January (257,708) and March (259,522) being higher than February (233,373). Interestingly, February (733) had slightly more transactions than January (713), despite fewer visits, while March experienced a large increase in both visits (69,931) and transactions (993).

This pattern suggests that seasonal factors like post-holiday slowdowns and marketing efforts may have influenced the fluctuations. Opportunities for improvement include boosting engagement in February through targeted campaigns and optimizing the user journey to increase conversions. In the future, the focus should be on capitalizing on seasonal peaks, enhancing retargeting strategies, and improving user experience to drive sustained growth in traffic and transactions.

2. **What is the bounce rate per traffic source in July 2017, and how does it vary by total visits?**

```sql
SELECT trafficSource.source AS source
      ,SUM(totals.visits) AS total_visits
      ,SUM(totals.bounces) AS total_no_of_bounces
      ,ROUND(SUM(totals.bounces)/SUM(totals.visits)*100, 2) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY source
ORDER BY total_visits DESC;
```

| **source** | **total_visits** | **total_no_of_bounces** | **bounce_rate** |
| --- | --- | --- | --- |
| google | 38400 | 19798 | 51,56 |
| (direct) | 19891 | 8606 | 43,27 |
| youtube.com | 6351 | 4238 | 66,73 |
| analytics.google.com | 1972 | 1064 | 53,96 |
| Partners | 1788 | 936 | 52,35 |
| m.facebook.com | 669 | 430 | 64,28 |
| google.com | 368 | 183 | 49,73 |
| dfa | 302 | 124 | 41,06 |
| sites.google.com | 230 | 97 | 42,17 |
| facebook.com | 191 | 102 | 53,4 |
| reddit.com | 189 | 54 | 28,57 |
| qiita.com | 146 | 72 | 49,32 |
| quora.com | 140 | 70 | 50 |
| baidu | 140 | 84 | 60 |
| bing | 111 | 54 | 48,65 |
| mail.google.com | 101 | 25 | 24,75 |
| yahoo | 100 | 41 | 41 |
| blog.golang.org | 65 | 19 | 29,23 |
| l.facebook.com | 51 | 45 | 88,24 |
| groups.google.com | 50 | 22 | 44 |
| t.co | 38 | 27 | 71,05 |
| google.co.jp | 36 | 25 | 69,44 |
| m.youtube.com | 34 | 22 | 64,71 |
| dealspotr.com | 26 | 12 | 46,15 |
| productforums.google.com | 25 | 21 | 84 |
| support.google.com | 24 | 16 | 66,67 |
| ask | 24 | 16 | 66,67 |
| int.search.tb.ask.com | 23 | 17 | 73,91 |
| optimize.google.com | 21 | 10 | 47,62 |
| docs.google.com | 20 | 8 | 40 |
| lm.facebook.com | 18 | 9 | 50 |
| l.messenger.com | 17 | 6 | 35,29 |
| adwords.google.com | 16 | 7 | 43,75 |
| duckduckgo.com | 16 | 14 | 87,5 |
| google.co.uk | 15 | 7 | 46,67 |
| sashihara.jp | 14 | 8 | 57,14 |
| lunametrics.com | 13 | 8 | 61,54 |
| search.mysearch.com | 12 | 11 | 91,67 |
| tw.search.yahoo.com | 10 | 8 | 80 |
| outlook.live.com | 10 | 7 | 70 |
| phandroid.com | 9 | 7 | 77,78 |
| plus.google.com | 8 | 2 | 25 |
| connect.googleforwork.com | 8 | 5 | 62,5 |
| m.yz.sm.cn | 7 | 5 | 71,43 |
| search.xfinity.com | 6 | 6 | 100 |
| google.co.in | 6 | 3 | 50 |
| online-metrics.com | 5 | 2 | 40 |
| s0.2mdn.net | 5 | 3 | 60 |
| google.ru | 5 | 1 | 20 |
| hangouts.google.com | 5 | 1 | 20 |
| away.vk.com | 4 | 3 | 75 |
| googleads.g.doubleclick.net | 4 | 1 | 25 |
| in.search.yahoo.com | 4 | 2 | 50 |
| m.sogou.com | 4 | 3 | 75 |
| siliconvalley.about.com | 3 | 2 | 66,67 |
| m.baidu.com | 3 | 2 | 66,67 |
| getpocket.com | 3 |  |  |
| au.search.yahoo.com | 2 | 2 | 100 |
| search.1and1.com | 2 | 2 | 100 |
| google.cl | 2 | 1 | 50 |
| m.sp.sm.cn | 2 | 2 | 100 |
| moodle.aurora.edu | 2 | 2 | 100 |
| uk.search.yahoo.com | 2 | 1 | 50 |
| amp.reddit.com | 2 | 1 | 50 |
| msn.com | 2 | 1 | 50 |
| wap.sogou.com | 2 | 2 | 100 |
| calendar.google.com | 2 | 1 | 50 |
| myactivity.google.com | 2 | 1 | 50 |
| google.co.th | 2 | 1 | 50 |
| github.com | 2 | 2 | 100 |
| centrum.cz | 2 | 2 | 100 |
| plus.url.google.com | 2 |  |  |
| google.it | 2 | 1 | 50 |
| kik.com | 1 | 1 | 100 |
| suche.t-online.de | 1 | 1 | 100 |
| google.com.br | 1 |  |  |
| google.ca | 1 |  |  |
| newclasses.nyu.edu | 1 |  |  |
| malaysia.search.yahoo.com | 1 | 1 | 100 |
| earth.google.com | 1 |  |  |
| google.nl | 1 |  |  |
| arstechnica.com | 1 |  |  |
| images.google.com.au | 1 | 1 | 100 |
| gophergala.com | 1 | 1 | 100 |
| google.es | 1 | 1 | 100 |
| it.pinterest.com | 1 | 1 | 100 |
| mx.search.yahoo.com | 1 | 1 | 100 |
| es.search.yahoo.com | 1 | 1 | 100 |
| search.tb.ask.com | 1 |  |  |
| online.fullsail.edu | 1 | 1 | 100 |
| google.bg | 1 | 1 | 100 |
| news.ycombinator.com | 1 | 1 | 100 |
| web.facebook.com | 1 | 1 | 100 |
| ph.search.yahoo.com | 1 |  |  |
| web.mail.comcast.net | 1 | 1 | 100 |
| aol | 1 |  |  |
| kidrex.org | 1 | 1 | 100 |

The table presents key traffic sources along with their total visits, number of bounces, and bounce rates, offering insights into user engagement and website performance. Bounce rate measures the percentage of users who leave a site after viewing only one page, with lower rates typically indicating stronger engagement.

Among high-traffic sources, Google (51.56%), direct visits (43.27%), and YouTube (66.73%) exhibit varying bounce rates, suggesting differences in user intent and content engagement. Some sources, like l.facebook.com (88.24%) and productforums.google.com (84%), show particularly high bounce rates, indicating potential issues with user retention or content relevance. Additionally, numerous sites with minimal traffic have near 100% bounce rates, likely due to their low visitor count.

Understanding these patterns is crucial for optimizing content, refining marketing strategies, and improving user experience to enhance engagement and reduce unnecessary drop-offs.

3. **What is the total revenue by traffic source, grouped by week and by month, for June 2017?**

```sql
SELECT 'Month' AS time_type
      ,FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
      ,trafficSource.source
      ,ROUND(SUM(product.productRevenue)/1000000, 2) AS revenue			
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
      UNNEST (hits) hits,			
      UNNEST (hits.product) product
WHERE product.productRevenue IS NOT NULL
GROUP BY time, trafficSource.source

UNION ALL

SELECT 'Week' AS time_type
      ,FORMAT_DATE('%Y%V', PARSE_DATE('%Y%m%d', date)) AS time
      ,trafficSource.source
      ,ROUND(SUM(product.productRevenue)/1000000, 2) AS revenue			
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
      UNNEST (hits) hits,			
      UNNEST (hits.product) product
WHERE product.productRevenue IS NOT NULL
GROUP BY time, trafficSource.source
ORDER BY revenue DESC;
```

| **time_type** | **time** | **source** | **revenue** |
| --- | --- | --- | --- |
| Month | 201706 | (direct) | 97333,62 |
| Week | 201724 | (direct) | 30908,91 |
| Week | 201725 | (direct) | 27295,32 |
| Month | 201706 | google | 18757,18 |
| Week | 201723 | (direct) | 17325,68 |
| Week | 201726 | (direct) | 14914,81 |
| Week | 201724 | google | 9217,17 |
| Month | 201706 | dfa | 8862,23 |
| Week | 201722 | (direct) | 6888,9 |
| Week | 201726 | google | 5330,57 |
| Week | 201726 | dfa | 3704,74 |
| Month | 201706 | mail.google.com | 2563,13 |
| Week | 201724 | mail.google.com | 2486,86 |
| Week | 201724 | dfa | 2341,56 |
| Week | 201722 | google | 2119,39 |
| Week | 201722 | dfa | 1670,65 |
| Week | 201723 | dfa | 1145,28 |
| Week | 201723 | google | 1083,95 |
| Week | 201725 | google | 1006,1 |
| Week | 201723 | search.myway.com | 105,94 |
| Month | 201706 | search.myway.com | 105,94 |
| Month | 201706 | groups.google.com | 101,96 |
| Week | 201725 | mail.google.com | 76,27 |
| Month | 201706 | chat.google.com | 74,03 |
| Week | 201723 | chat.google.com | 74,03 |
| Week | 201724 | dealspotr.com | 72,95 |
| Month | 201706 | dealspotr.com | 72,95 |
| Week | 201725 | mail.aol.com | 64,85 |
| Month | 201706 | mail.aol.com | 64,85 |
| Week | 201726 | groups.google.com | 63,37 |
| Week | 201725 | phandroid.com | 52,95 |
| Month | 201706 | phandroid.com | 52,95 |
| Month | 201706 | sites.google.com | 39,17 |
| Week | 201725 | groups.google.com | 38,59 |
| Week | 201725 | sites.google.com | 25,19 |
| Month | 201706 | google.com | 23,99 |
| Week | 201725 | google.com | 23,99 |
| Month | 201706 | yahoo | 20,39 |
| Week | 201726 | yahoo | 20,39 |
| Month | 201706 | youtube.com | 16,99 |
| Week | 201723 | youtube.com | 16,99 |
| Month | 201706 | bing | 13,98 |
| Week | 201722 | sites.google.com | 13,98 |
| Week | 201724 | bing | 13,98 |
| Week | 201724 | l.facebook.com | 12,48 |
| Month | 201706 | l.facebook.com | 12,48 |

This dataset captures revenue data segmented by time type (weekly and monthly), time period, traffic source, and revenue amount. Each record represents revenue generated from a specific source during a defined time frame. The table provides a breakdown of revenue contributions from different traffic channels, offering insights into revenue trends and source performance over time.

Revenue is attributed to multiple sources, including direct visits, organic search (Google), paid advertising (DFA), email referrals (mail.google.com), and other referring domains like search.myway.com. The data highlights how users arrive at the site—whether through direct navigation, search engines, paid campaigns, or external websites.

The dataset presents revenue on both a weekly and monthly scale, enabling trend analysis over time. The time periods, such as "201706" for June 2017, indicate how revenue fluctuates across different weeks within the month. By examining these trends, it is possible to observe patterns in user behavior, marketing effectiveness, and seasonal impacts on revenue generation.

4. **What is the average number of pageviews for purchasers versus non-purchasers in June and July 2017?**

```sql
WITH purchasers 
  AS (
    SELECT FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
          ,ROUND(SUM(totals.pageviews)/COUNT(DISTINCT fullVisitorId), 4) AS avg_pageviews_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
      UNNEST (hits) hits,			
      UNNEST (hits.product) product
    WHERE _table_suffix BETWEEN '0601' AND '0731'
      AND totals.transactions >=1 
      AND product.productRevenue IS NOT NULL  
    GROUP BY time
    ORDER BY time),

non_purchasers 
  AS (
    SELECT FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
          ,ROUND(SUM(totals.pageviews)/COUNT(DISTINCT fullVisitorId), 4) AS avg_pageviews_non_purchase
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
      UNNEST (hits) hits,			
      UNNEST (hits.product) product
    WHERE _table_suffix BETWEEN '0601' AND '0731'
      AND totals.transactions IS NULL
      AND product.productRevenue IS NULL
    GROUP BY time
    ORDER BY time)
  
SELECT p.time
      ,p.avg_pageviews_purchase
      ,n.avg_pageviews_non_purchase
FROM purchasers AS p
FULL JOIN non_purchasers AS n
ON p.time=n.time
ORDER BY time;
```

| **time** | **avg_pageviews_purchase** | **avg_pageviews_non_purchase** |
| --- | --- | --- |
| 201706 | 94.0205 | 316.8656 |
| 201707 | 124.2376 | 334.0566 |

The dataset reveals a significant difference in the average number of pageviews between purchasers and non-purchasers in June and July 2017. Non-purchasers consistently viewed more pages, with an average of 316.87 pageviews in June and 334.06 in July, compared to 94.02 and 124.24 for purchasers in the respective months. This suggests that non-purchasers tend to explore more content but do not complete a transaction, possibly due to indecision, price sensitivity, or usability barriers. 

Meanwhile, the increase in pageviews for purchasers from June to July indicates a trend where buyers are engaging more before making a purchase, potentially comparing products or revisiting pages before conversion. The gap in pageviews between the two groups highlights a potential opportunity to optimize the user experience, simplify the purchase process, or enhance product recommendations to convert more non-purchasers into buyers.

5. **What is the average number of transactions per user who made a purchase in July 2017?**

```sql
SELECT FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
      ,ROUND(SUM(totals.transactions)/COUNT(DISTINCT fullVisitorId), 4) AS Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
  UNNEST (hits) hits,			
  UNNEST (hits.product) product
WHERE totals.transactions >=1
  AND product.productRevenue IS NOT NULL
GROUP BY time;
```

| **time** | **Avg_total_transactions_per_user** |
| --- | --- |
| 201707 | 4.1639 |

The dataset indicates that in July 2017, users who made a purchase had an average of 4.16 transactions per user. This suggests that a significant portion of purchasing users returned to make multiple transactions rather than completing a single purchase. A high average transaction count per user could indicate strong customer engagement, repeat purchases, or an effective sales strategy encouraging multiple purchases. It may also reflect a loyal customer base or promotional activities that incentivize users to make additional transactions. Understanding the factors driving repeat purchases can help businesses optimize retention strategies and further enhance customer lifetime value.

6. **What is the average amount of money spent per session for purchasers in July 2017?**

```sql
SELECT FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
      ,ROUND((SUM(product.productRevenue)/SUM(totals.visits))/1000000, 2) AS avg_revenue_by_user_per_visit
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
  UNNEST (hits) hits,			
  UNNEST (hits.product) product
WHERE totals.transactions IS NOT NULL
  AND product.productRevenue IS NOT NULL
GROUP BY time;
```

| **time** | **avg_revenue_by_user_per_visit** |
| --- | --- |
| 201707 | 43.86 |

In July 2017, the average revenue generated per session by purchasing users was $43.86. This metric indicates that, on average, each session where a user made a purchase resulted in a transaction value of approximately $43.86. A higher average revenue per session suggests strong purchase intent among buyers and potentially effective product pricing or promotional strategies. This value can also reflect user behavior, such as purchasing multiple items per session or high-value transactions. Businesses can leverage this insight to optimize pricing strategies, improve user experience, and explore ways to increase the average order value, such as through upselling or bundling products.

7. **What other products were purchased by customers who bought 'YouTube Men's Vintage Henley' in July 2017?**

```sql
SELECT product.v2ProductName AS other_purchased_products
      ,SUM(product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
  UNNEST (hits) hits,
  UNNEST (hits.product) product
WHERE fullVisitorId IN (SELECT DISTINCT fullVisitorId
                        FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
                          UNNEST (hits) hits,
                          UNNEST (hits.product) product
                        WHERE totals.transactions >=1
                              AND product.productRevenue IS NOT NULL
                              AND product.v2ProductName="YouTube Men's Vintage Henley")
      AND product.productRevenue IS NOT NULL
      AND product.v2ProductName!="YouTube Men's Vintage Henley"
GROUP BY product.v2ProductName
ORDER BY quantity DESC;
```

| **other_purchased_products** | **quantity** |
| --- | --- |
| Google Sunglasses | 20 |
| Google Women's Vintage Hero Tee Black | 7 |
| SPF-15 Slim & Slender Lip Balm | 6 |
| Google Women's Short Sleeve Hero Tee Red Heather | 4 |
| YouTube Men's Fleece Hoodie Black | 3 |
| Google Men's Short Sleeve Badge Tee Charcoal | 3 |
| Crunch Noise Dog Toy | 2 |
| Google Men's Short Sleeve Hero Tee Charcoal | 2 |
| Google Doodle Decal | 2 |
| YouTube Twill Cap | 2 |
| Android Wool Heather Cap Heather/Black | 2 |
| Android Men's Vintage Henley | 2 |
| Android Women's Fleece Hoodie | 2 |
| Red Shine 15 oz Mug | 2 |
| 22 oz YouTube Bottle Infuser | 2 |
| Recycled Mouse Pad | 2 |
| YouTube Men's Short Sleeve Hero Tee White | 1 |
| Google Men's Performance Full Zip Jacket Black | 1 |
| 26 oz Double Wall Insulated Bottle | 1 |
| Google Men's  Zip Hoodie | 1 |
| YouTube Hard Cover Journal | 1 |
| Google 5-Panel Cap | 1 |
| Google Twill Cap | 1 |
| Google Men's Long Sleeve Raglan Ocean Blue | 1 |
| Google Men's Long & Lean Tee Charcoal | 1 |
| Google Men's Bike Short Sleeve Tee Charcoal | 1 |
| Google Men's Airflow 1/4 Zip Pullover Black | 1 |
| Android Men's Short Sleeve Hero Tee Heather | 1 |
| Google Slim Utility Travel Bag | 1 |
| YouTube Women's Short Sleeve Hero Tee Charcoal | 1 |
| YouTube Men's Long & Lean Tee Charcoal | 1 |
| Android BTTF Moonshot Graphic Tee | 1 |
| Android Men's Vintage Tank | 1 |
| Google Women's Long Sleeve Tee Lavender | 1 |
| 8 pc Android Sticker Sheet | 1 |
| YouTube Men's Short Sleeve Hero Tee Black | 1 |
| YouTube Custom Decals | 1 |
| Four Color Retractable Pen | 1 |
| Google Laptop and Cell Phone Stickers | 1 |
| Android Men's Pep Rally Short Sleeve Tee Navy | 1 |
| YouTube Women's Short Sleeve Tri-blend Badge Tee Charcoal | 1 |
| Google Men's Performance 1/4 Zip Pullover Heather/Black | 1 |
| Google Men's Long & Lean Tee Grey | 1 |
| Google Toddler Short Sleeve T-shirt Grey | 1 |
| Android Sticker Sheet Ultra Removable | 1 |
| Google Men's Vintage Badge Tee Black | 1 |
| Google Men's Pullover Hoodie Grey | 1 |
| Android Men's Short Sleeve Hero Tee White | 1 |
| Google Men's Vintage Badge Tee White | 1 |
| Google Men's 100% Cotton Short Sleeve Hero Tee Red | 1 |

The dataset provides insights into other products purchased by customers who bought the "YouTube Men's Vintage Henley" in July 2017. The most frequently purchased additional items include Google Sunglasses (20 units), Google Women's Vintage Hero Tee Black (7 units), and SPF-15 Slim & Slender Lip Balm (6 units). Several other apparel items, such as hoodies, short sleeve tees, and caps, were also commonly bought, indicating a preference for branded clothing among these customers. Additionally, accessories like bottles, journals, stickers, and a recycled mouse pad were included in purchases, suggesting that customers often bundled lifestyle or functional products with their main purchase. This data highlights potential cross-selling opportunities, where businesses can recommend similar or complementary products to users based on their purchasing behavior, ultimately increasing average order value and enhancing the shopping experience.

8. **What is the cohort map from product view to add to cart to purchase in Jan, Feb, and March 2017?**

```sql
WITH cte 
  AS (
    SELECT FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
          ,SUM(CASE WHEN hits.eCommerceAction.action_type = '2' THEN 1 END) AS num_product_view
          ,SUM(CASE WHEN hits.eCommerceAction.action_type = '3' THEN 1 END) AS num_addtocart
          ,SUM(CASE WHEN hits.eCommerceAction.action_type = '6' AND product.productRevenue IS NOT NULL THEN 1 END) AS num_purchase    
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`,
      UNNEST (hits) hits,			
      UNNEST (hits.product) product
    WHERE _table_suffix BETWEEN '0101' AND '0331'
    GROUP BY month
    ORDER BY month)

SELECT cte.month
      ,num_product_view
      ,num_addtocart
      ,num_purchase
      ,ROUND(num_addtocart/num_product_view*100, 2) AS add_to_cart_rate
      ,ROUND(num_purchase/num_product_view*100, 2) AS purchase_rate
FROM cte;
```

| **month** | **num_product_view** | **num_addtocart** | **num_purchase** | **add_to_cart_rate** | **purchase_rate** |
| --- | --- | --- | --- | --- | --- |
| 201701 | 25787 | 7342 | 2143 | 28.47 | 8.31 |
| 201702 | 21489 | 7360 | 2060 | 34.25 | 9.59 |
| 201703 | 23549 | 8782 | 2977 | 37.29 | 12.64 |

The dataset presents a cohort analysis of user behavior from product view to add-to-cart to purchase for the first three months of 2017. In January 2017, 28.47% of viewed products were added to the cart, and 8.31% of views resulted in a purchase. The add-to-cart rate improved in February 2017 to 34.25%, while the purchase rate also increased to 9.59%, indicating a higher engagement and conversion efficiency. In March 2017, both metrics saw further growth, with the add-to-cart rate reaching 37.29% and the purchase rate rising to 12.64%, suggesting an upward trend in user purchasing behavior. This improvement over the three months could be due to factors such as better product recommendations, seasonal demand, promotional strategies, or enhanced user experience. Understanding these conversion rates allows businesses to identify opportunities for optimizing product listings, refining marketing strategies, and improving the checkout process to drive higher conversions.

## **6. Conclusion**

- This project allowed me to explore the marketing industry and gain insights into the customer journey through e-commerce data analysis using SQL tools in BigQuery.
- By leveraging SQL queries, I analyzed key metrics such as bounce rates, transactions, revenue, visits, and purchases to understand customer behavior patterns.
- Using SQL to examine traffic sources and their impact on sales helped identify the most effective marketing channels for driving engagement and conversions.
- With optimized SQL queries, businesses can efficiently allocate resources to high-performing channels and improve underperforming ones, leading to better marketing efficiency.
- SQL tools in BigQuery enabled the extraction of valuable insights that support strategic decision-making, allowing businesses to refine operations, enhance customer experiences, and maximize revenue growth through data-driven optimization.
