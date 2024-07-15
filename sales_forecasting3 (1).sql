CREATE OR REPLACE VIEW `retail-pipeline-beamlytics.Retail_Store.features_sales_data` AS
SELECT
  date,
  store_encoded,
  department_encoded,
  daily_sales
FROM
  `retail-pipeline-beamlytics.Retail_Store.prepared_sales_data`;