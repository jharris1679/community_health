select 
  m_community_id cid,
  two_level_name category,
  count(distinct(item_id)) items_posted
from 
  (select user.id user_id, item.id item_id, item.category_id
  from `hipyard_analytics_production.item_events_partitioned`
  where event = 'item_posted'
  and format_date('%Y-%m', date(timestamp))='2017-06') i
join `vs_reporting.user_memberships` u on i.user_id = u.user_id
join `vs_reporting.category_levels` c on c.category_id = i.category_id
group by cid, category
order by cid, items_posted desc
