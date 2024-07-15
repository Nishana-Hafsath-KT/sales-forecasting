CREATE OR REPLACE VIEW `retail-pipeline-beamlytics.Retail_Store.prepared_sales_data` AS
SELECT
  DATE(cleaned_timestamp) AS date,
  store_encoded,
  department_encoded,
  SUM(sale_amount) AS daily_sales,
  COUNT(*) AS transaction_count,
  AVG(sale_amount) AS avg_transaction_value
FROM
  `retail-pipeline-beamlytics.Retail_Store.cleaned_encoded_sales_data`
GROUP BY
  date, store_encoded, department_encoded;