with traffic_count as (
select 
  case when lead(type) over(order by datetime) ='black bmw' and 
       (lag(type) over(order by datetime) <> 'black bmw' 
       or lag(type) over(order by datetime) is null
       ) then type
       when lag(type) over(order by datetime) ='black bmw' and 
       (lead(type) over(order by datetime) <> 'black bmw' 
       or lead(type) over(order by datetime) is null)
       then type
       when lag(type) over(order by datetime) ='black bmw' 
       and lead(type) over(order by datetime) ='black bmw' then type end type_neighbour,
       case 
       when lead(type) over(order by datetime) ='black bmw' and 
       (lag(type) over(order by datetime) <> 'black bmw'
       or lag(type) over(order by datetime) is null
       ) then 1
       when lag(type) over(order by datetime) ='black bmw' and 
       (lead(type) over(order by datetime) <> 'black bmw' 
       or lead(type) over(order by datetime) is null 
       ) then 1
       when lag(type) over(order by datetime) ='black bmw' 
       and lead(type) over(order by datetime) ='black bmw' then 2 end as count
from traffic_observations
where traffic_light_id = 1)
select type_neighbour, sum(count) from traffic_count
where type_neighbour is not null
group by type_neighbour