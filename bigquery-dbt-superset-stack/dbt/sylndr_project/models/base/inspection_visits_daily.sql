
{{ 
	config(        
		database = 'scenic-style-421412',
        schema = 'base',
		materialized='view'
		)
}}



with daily_data AS (
  SELECT
    DATE(inspection_visit_booking_datetime) AS booking_date,
    COUNT(*) AS total_inspections_booked,
    SUM(CASE WHEN is_success = TRUE THEN 1 ELSE 0 END) AS total_inspections_completed,
    SUM(CASE WHEN is_failure = TRUE THEN 1 ELSE 0 END) AS total_inspections_canceled,
    SUM(CASE WHEN visit_scheduled_within_24_hrs_from_booking = TRUE THEN 1 ELSE 0 END) AS inspections_within_24_hrs,
    SUM(CASE WHEN visit_scheduled_within_48_hrs_from_booking = TRUE THEN 1 ELSE 0 END) AS inspections_within_48_hrs,
    SUM(CASE WHEN visit_scheduled_within_72_hrs_from_booking = TRUE THEN 1 ELSE 0 END) AS inspections_within_72_hrs,
    AVG(minutes_from_booking_to_scheduled_visit_time) AS avg_minutes_from_booking_to_scheduled_visit,
    COUNT(CASE WHEN lead_source_group = 'Social Media' THEN 1 ELSE NULL END) AS social_media_inspections,
    COUNT(CASE WHEN lead_source_group = 'Website' THEN 1 ELSE NULL END) AS website_inspections,
    COUNT(CASE WHEN lead_source_group = '3rd Party' THEN 1 ELSE NULL END) AS third_party_inspections,
    AVG(inspection_visit_duration_in_minutes) AS avg_inspection_duration,
    AVG(inspection_report_duration_in_minutes) AS avg_report_duration,
    SUM(CASE WHEN inspection_report_completed_within_scheduled_slot = TRUE THEN 1 ELSE 0 END) AS inspections_completed_within_slot,
    COUNT(CASE WHEN reschedule_requested = TRUE THEN 1 ELSE NULL END) AS total_rescheduled_visits,
    SAFE_DIVIDE(SUM(CASE WHEN reschedule_requested = TRUE THEN 1 ELSE 0 END), COUNT(*)) * 100 AS pct_rescheduled_visits,
    COUNT(DISTINCT engineer_id) AS total_engineers_working,
    MAX(engineer_id) AS busiest_engineer, -- Placeholder for identifying the most active engineer
    COUNT(CASE WHEN cancelation_reason IS NOT NULL THEN 1 ELSE NULL END) AS total_cancellations_with_reason
  FROM
     {{ ref('inspection_visits') }} --denormalized_inspection_visits_vw 
  GROUP BY
    booking_date
)
SELECT
  booking_date,
  total_inspections_booked,
  total_inspections_completed,
  SAFE_DIVIDE(total_inspections_completed, total_inspections_booked) * 100 AS pct_inspections_completed,
  total_inspections_canceled,
  SAFE_DIVIDE(total_inspections_canceled, total_inspections_booked) * 100 AS pct_inspections_canceled,
  inspections_within_24_hrs,
  SAFE_DIVIDE(inspections_within_24_hrs, total_inspections_booked) * 100 AS pct_inspections_within_24_hrs,
  inspections_within_48_hrs,
  SAFE_DIVIDE(inspections_within_48_hrs, total_inspections_booked) * 100 AS pct_inspections_within_48_hrs,
  inspections_within_72_hrs,
  SAFE_DIVIDE(inspections_within_72_hrs, total_inspections_booked) * 100 AS pct_inspections_within_72_hrs,
  avg_minutes_from_booking_to_scheduled_visit,
  avg_inspection_duration,
  avg_report_duration,
  SAFE_DIVIDE(inspections_completed_within_slot, total_inspections_completed) * 100 AS pct_completed_within_slot,
  total_rescheduled_visits,
  pct_rescheduled_visits,
  social_media_inspections,
  SAFE_DIVIDE(social_media_inspections, total_inspections_booked) * 100 AS pct_social_media_inspections,
  website_inspections,
  SAFE_DIVIDE(website_inspections, total_inspections_booked) * 100 AS pct_website_inspections,
  third_party_inspections,
  SAFE_DIVIDE(third_party_inspections, total_inspections_booked) * 100 AS pct_third_party_inspections,
  total_engineers_working,
  busiest_engineer,
  total_cancellations_with_reason,
  SAFE_DIVIDE(total_cancellations_with_reason, total_inspections_canceled) * 100 AS pct_cancellations_with_reason,
  CURRENT_DATE()  AS Calender_Date,
  CURRENT_TIMESTAMP() AS Run_Timestamp
FROM
  daily_data
