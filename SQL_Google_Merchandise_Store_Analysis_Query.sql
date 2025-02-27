/*Query 01: calculate total visit, pageview, transaction for Jan, Feb and March 2017*/
SELECT FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS month
      ,SUM(totals.visits) AS visits
      ,SUM(totals.pageviews) AS pageviews
      ,SUM(totals.transactions) AS transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix BETWEEN '0101' AND '0331'
GROUP BY month
ORDER BY month ASC;

/*Query 02: Bounce rate per traffic source in July 2017*/
SELECT trafficSource.source AS source
      ,SUM(totals.visits) AS total_visits
      ,SUM(totals.bounces) AS total_no_of_bounces
      ,ROUND(SUM(totals.bounces)/SUM(totals.visits)*100, 3) AS bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY source
ORDER BY total_visits DESC;

/*Query 03: Revenue by traffic source by week, by month in June 2017*/
SELECT 'Month' AS time_type
      ,FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
      ,trafficSource.source
      ,ROUND(SUM(product.productRevenue)/1000000, 4) AS revenue			
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
      UNNEST (hits) hits,			
      UNNEST (hits.product) product
WHERE product.productRevenue IS NOT NULL
GROUP BY time, trafficSource.source

UNION ALL

SELECT 'Week' AS time_type
      ,FORMAT_DATE('%Y%V', PARSE_DATE('%Y%m%d', date)) AS time
      ,trafficSource.source
      ,ROUND(SUM(product.productRevenue)/1000000, 4) AS revenue			
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
      UNNEST (hits) hits,			
      UNNEST (hits.product) product
WHERE product.productRevenue IS NOT NULL
GROUP BY time, trafficSource.source
ORDER BY revenue DESC;

/*Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.*/
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

/*Query 05: Average number of transactions per user that made a purchase in July 2017*/
SELECT FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
      ,ROUND(SUM(totals.transactions)/COUNT(DISTINCT fullVisitorId), 4) AS Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
  UNNEST (hits) hits,			
  UNNEST (hits.product) product
WHERE totals.transactions >=1
  AND product.productRevenue IS NOT NULL
GROUP BY time;

/*Query 06: Average amount of money spent per session. Only include purchaser data in July 2017*/
SELECT FORMAT_DATE('%Y%m', PARSE_DATE('%Y%m%d', date)) AS time
      ,ROUND((SUM(product.productRevenue)/SUM(totals.visits))/1000000, 2) AS avg_revenue_by_user_per_visit
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
  UNNEST (hits) hits,			
  UNNEST (hits.product) product
WHERE totals.transactions IS NOT NULL
  AND product.productRevenue IS NOT NULL
GROUP BY time;

/*Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017.*/
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

/*Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.*/
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