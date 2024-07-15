WITH forecasts AS (
  SELECT
    *
  FROM
    ML.FORECAST(MODEL `retail-pipeline-beamlytics.Retail_Store.sales_forecast_model_3months`,
                STRUCT(90 AS horizon))
),
categorical_decoding AS (
  SELECT DISTINCT
    store_id,
    department_id,
    ROW_NUMBER() OVER (ORDER BY store_id) AS store_encoded,
    ROW_NUMBER() OVER (ORDER BY department_id) AS department_encoded
  FROM
    `retail-pipeline-beamlytics.Retail_Store.cleaned_transaction_data`
)
SELECT
  f.forecast_timestamp,
  cd.store_id,
  cd.department_id,
  ROUND(f.forecast_value, 2) AS predicted_daily_sales,
  ROUND(f.prediction_interval_lower_bound, 2) AS lower_bound,
  ROUND(f.prediction_interval_upper_bound, 2) AS upper_bound,
  f.confidence_level
FROM
  forecasts f
JOIN
  categorical_decoding cd
ON
  f.store_encoded = cd.store_encoded AND f.department_encoded = cd.department_encoded
ORDER BY
  cd.store_id, cd.department_id, f.forecast_timestamp;