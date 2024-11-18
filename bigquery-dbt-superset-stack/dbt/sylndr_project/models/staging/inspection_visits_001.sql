
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

{{ 
	config(        
		database = 'scenic-style-421412',
        schema = 'staging',
		materialized='table'
		)
}}


with source_data as (
SELECT
  iv.Id AS inspection_visit_id,
  iv.Name AS inspection_visit_name,
  iv.CreatedDate AS inspection_visit_booking_datetime,
  iv.Inspection_Date_Time__c AS inspection_visit_scheduled_start_datetime,
  iv.Visit_End_Date_Time__c AS inspection_visit_scheduled_end_datetime,
  iv.Inspection_Report_Start_Time__c AS inspection_visit_report_start_datetime,
  iv.Inspection_Report_End_Time__c AS inspection_visit_report_end_datetime,
  acc.PersonLeadSource as lead_source,
  case 
    when lower (acc.PersonLeadSource) like '%social media%' then 'Social Media'
    when lower (acc.PersonLeadSource) like '%website%' then 'Website'
    when lower (acc.PersonLeadSource) like '%other%' then 'Other'
    else 
      '3rd Party'
  end as lead_source_group,
  -- datetime_diff (iv.Inspection_Date_Time__c , iv.CreatedDate , HOUR)  as time_from_booking_to_visit
  iv.Inspection_Date_Time__c -  iv.CreatedDate as   time_from_booking_to_visit,
  datetime_diff (iv.Inspection_Date_Time__c , iv.CreatedDate , MINUTE)  as minutes_from_booking_to_scheduled_visit_time,
  coalesce (datetime_diff ( iv.Inspection_Report_Start_Time__c , iv.CreatedDate , MINUTE),-1)   as minutes_from_booking_to_inspection_report_time,
  coalesce (datetime_diff ( iv.Inspection_Report_Start_Time__c , iv.Inspection_Date_Time__c , MINUTE),-1) as  
  minutes_from_visit_scheduled_start_to_inspection_report_start,
  coalesce (datetime_diff ( iv.Inspection_Report_End_Time__c , iv.Visit_End_Date_Time__c , MINUTE),-1) as     minutes_from_visit_scheduled_end_to_inspection_report_end,
  case 
    when datetime_diff (iv.Inspection_Date_Time__c , iv.CreatedDate , Hour) <= 24 then TRUE 
    else FALSE
  end as visit_scheduled_within_24_hrs_from_booking,
  case 
    when datetime_diff (iv.Inspection_Date_Time__c , iv.CreatedDate , Hour) <= 48 then TRUE 
    else FALSE
  end as visit_scheduled_within_48_hrs_from_booking,
  case 
    when datetime_diff (iv.Inspection_Date_Time__c , iv.CreatedDate , Hour) <= 72 then TRUE
    else FALSE
  end as visit_scheduled_within_72_hrs_from_booking,  
  case 
    when datetime_diff (iv.Inspection_Date_Time__c , iv.CreatedDate , Hour) > 72 then TRUE 
    else FALSE
  end as visit_scheduled_after_more_than_72_hrs_from_booking,  
  CASE 
    WHEN DATE(iv.Inspection_Date_Time__c) = DATE(iv.CreatedDate) THEN TRUE
    WHEN iv.Inspection_Date_Time__c IS NULL OR iv.CreatedDate IS NULL THEN NULL
    ELSE FALSE
  END AS visit_scheduled_same_day_from_booking,
  CASE 
    WHEN DATE(iv.Inspection_Date_Time__c) = DATE(iv.CreatedDate)+1 THEN TRUE
    WHEN iv.Inspection_Date_Time__c IS NULL OR iv.CreatedDate IS NULL THEN NULL
    ELSE FALSE
  END AS visit_scheduled_next_day_from_booking,
--  DATE(iv.Inspection_Date_Time__c) as f
-- , DATE(iv.CreatedDate) as ff 
-- , DATE(iv.CreatedDate)+1 as fff,
  CASE 
    WHEN DATE(iv.Inspection_Date_Time__c) >= DATE(iv.CreatedDate)+2 THEN TRUE
    WHEN iv.Inspection_Date_Time__c IS NULL OR iv.CreatedDate IS NULL THEN NULL
    ELSE FALSE
  END AS visit_scheduled_2_days_or_more_from_booking,
  Inspection_Whole_Duration__c as inspection_visit_duration,
  CAST(SUBSTR(Inspection_Whole_Duration__c, 1, 2) AS INT64) * 60 + 
    CAST(SUBSTR(Inspection_Whole_Duration__c, 4, 2) AS INT64) + 
    CAST(SUBSTR(Inspection_Whole_Duration__c, 7, 2) AS FLOAT64) / 60 AS inspection_visit_duration_in_minutes,
  -- Inspection_Report_End_Time__c - Inspection_Report_Start_Time__c as inspection_report_duration_in_minutes
  coalesce (datetime_diff ( iv.Inspection_Report_End_Time__c , iv.Inspection_Report_Start_Time__c , MINUTE),-1) as inspection_report_duration_in_minutes,
  case when lower (iv.Status__c) = 'scheduled' or lower (ivh.OldValue) = 'scheduled' or lower (ivh.NewValue) ='scheduled'then True else False end as inspection_visit_had_scheduled_status,
Status__c, ivh.OldValue , ivh.NewValue, 
  case 
    when lower (iv.Status__c) = 'scheduled'  then iv.LastModifiedDate 
    when lower (ivh.OldValue) = 'scheduled'then iv.CreatedDate
  end as  inspection_visit_scheduled_status_datetime,
  case when lower (iv.Status__c) = 'pending' or lower (ivh.OldValue) = 'pending' or lower (ivh.NewValue) ='pending'then True else False end as inspection_visit_had_pending_status,
  case 
    when lower (iv.Status__c) = 'pending'  then iv.LastModifiedDate 
    when lower (ivh.OldValue) = 'pending'then iv.CreatedDate
  end as  inspection_visit_pending_status_datetime,
  case when lower (iv.Status__c) = 'closed failure' or lower (ivh.OldValue) = 'closed failure' or lower (ivh.NewValue) ='closed failure'then True else False end as inspection_visit_had_closed_failure_status,
  case 
    when lower (iv.Status__c) = 'closed failure'  then iv.LastModifiedDate 
    when lower (ivh.OldValue) = 'closed failure'then iv.LastModifiedDate 
  end as  inspection_visit_closed_failure_status_datetime,
  case when lower (iv.Status__c) = 'closed success' or lower (ivh.OldValue) = 'closed success' or lower (ivh.NewValue) ='closed success'then True else False end as inspection_visit_had_closed_success_status, 
  case 
    when lower (iv.Status__c) = 'closed success'  then iv.LastModifiedDate 
    when lower (ivh.OldValue) = 'closed success'then iv.LastModifiedDate 
  end as  inspection_visit_closed_success_status_datetime,
  iv.Zone__c as zone,
  iv.Inspection_Unit_Name__c as inspection_unit_name,
  iv.Inspector_User__c as engineer_id,
  ins.name as engineer_name,
  iv.Cancelation_Reason__c as cancelation_reason,
  iv.Validation_of_Cancelation__c as validation_of_cancelation,
  iv.Car_Name__c as car_id,
  -- Inspection_Report_End_Time__c is null
  coalesce (datetime_diff ( iv.Inspection_Report_End_Time__c , iv.Visit_End_Date_Time__c , MINUTE),0)<0 as inspection_report_completed_within_scheduled_slot,
  iv.Status__c as inspection_current_status,
  case 
    when lower (iv.Status__c) = 'pending' then true 
    else false
  end as is_pending,
  Account__c , Basic_Car_Info__c,
  case 
    when lower (iv.Cancelation_Reason__c) like '%rescheduling%' then True 
    Else False
  end as reschedule_requested,
  case 
    when lower (iv.Status__c) = 'closed success'  then True 
    Else False
  end as is_success,
  case 
    when lower (iv.Status__c) = 'closed failure'  then True 
    Else False
  end as is_failure  

FROM
  {{source('input_src', 'Inspection_Visit__c') }} iv --`scenic-style-421412.sylndr_task.Inspection_Visit__c`  iv
left join {{source('input_src', 'Account') }} acc --`scenic-style-421412.sylndr_task.Account`  acc 
on   acc.Id = iv.Account__c
left join {{source('input_src', 'Inspection_Visit__History') }} ivh --`scenic-style-421412.sylndr_task.Inspection_Visit__History` ivh 
on iv.Id = ivh.ParentId and ivh.Field = 'Status__c' --and(ivh.OldValue = 'Scheduled' or ivh.NewValue = 'Scheduled')
left join  {{source('input_src', 'Inspector__c') }} ins --`scenic-style-421412.sylndr_task.Inspector__c` ins 
on iv.Inspector_User__c = ins.id

-- where ivh.OldValue = 'Scheduled' or ivh.NewValue = 'Scheduled' or iv.Status__c = 'Scheduled'

)

select 
    *,
    CURRENT_DATE()  AS Calender_Date,
	CURRENT_TIMESTAMP() AS Run_Timestamp 
from source_data








-- with source_data as (


-- SELECT *
-- FROM {{source('input_src', 'Account') }}
-- LIMIT 1000


-- )

-- select *
-- from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
