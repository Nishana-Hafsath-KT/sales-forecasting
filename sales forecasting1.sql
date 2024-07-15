CREATE OR REPLACE VIEW `retail-pipeline-beamlytics.Retail_Store.cleaned_encoded_sales_data` AS
WITH categorical_encoding AS (
  SELECT DISTINCT
    store_id,
    department_id,
    ROW_NUMBER() OVER (ORDER BY store_id) AS store_encoded,
    ROW_NUMBER() OVER (ORDER BY department_id) AS department_encoded
  FROM
    `retail-pipeline-beamlytics.Retail_Store.cleaned_transaction_data`
)
SELECT
  TIMESTAMP_MILLIS(t.timestamp) AS cleaned_timestamp,
  COALESCE(ce.store_encoded, -1) AS store_encoded,
  COALESCE(ce.department_encoded, -1) AS department_encoded,
  COALESCE(t.price, 0) AS price,
  COALESCE(t.product_count, 0) AS product_count,
  COALESCE(t.price, 0) * COALESCE(t.product_count, 0) AS sale_amount
FROM
  `retail-pipeline-beamlytics.Retail_Store.cleaned_transaction_data` t
LEFT JOIN
  categorical_encoding ce
ON
  t.store_id = ce.store_id AND t.department_id = ce.department_id
WHERE
  t.timestamp IS NOT NULL
  AND t.timestamp > 0
  AND t.timestamp < 253402300800000  -- Maximum valid timestamp in milliseconds
  AND t.store_id IS NOT NULL
  AND t.department_id IS NOT NULL;