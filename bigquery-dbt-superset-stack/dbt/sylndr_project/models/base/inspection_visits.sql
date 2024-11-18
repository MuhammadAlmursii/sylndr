
{{ 
	config(        
		database = 'scenic-style-421412',
        schema = 'base',
		materialized='view'
		)
}}

with denormalized_inspection_visits_vw as (
select
  iv.*,
  no_res.number_of_reschedules

from  {{ ref('inspection_visits_001') }}  iv  
left join {{ ref('inspection_visits_002') }}  no_res
on iv.Account__c = no_res.Account__c and  iv.Basic_Car_Info__c = no_res.Basic_Car_Info__c
-- where  no_res.number_of_reschedules > 2
-- where  is_failure is true and number_of_reschedules > 2
)

SELECT 
  *
from 
  denormalized_inspection_visits_vw
