CREATE OR REPLACE MODEL
  `retail-pipeline-beamlytics.Retail_Store.sales_forecast_model_3months`
OPTIONS
  (model_type='ARIMA_PLUS',
   time_series_timestamp_col='date',
   time_series_data_col='daily_sales',
   time_series_id_col=['store_encoded', 'department_encoded'],
   horizon = 90,
   auto_arima = TRUE,
   data_frequency = 'AUTO_FREQUENCY',
   decompose_time_series = TRUE,
   holiday_region = 'US') AS
SELECT
  date,
  store_encoded,
  department_encoded,
  daily_sales
FROM
  `retail-pipeline-beamlytics.Retail_Store.features_sales_data`;