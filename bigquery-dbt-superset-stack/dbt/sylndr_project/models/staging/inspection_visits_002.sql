
{{ 
	config(        
		database = 'scenic-style-421412',
        schema = 'staging',
		materialized='table'
		)
}}


with number_of_reschedules as  (
SELECT Account__c, Basic_Car_Info__c , count(*) as number_of_reschedules 
FROM
  {{source('input_src', 'Inspection_Visit__c') }} --`scenic-style-421412.sylndr_task.Inspection_Visit__c`  
 group by 1, 2 
--  order by count(*) desc 
)

SELECT 
    *,
    CURRENT_DATE()  AS Calender_Date,
	CURRENT_TIMESTAMP() AS Run_Timestamp 
from number_of_reschedules

