select
  n.cid,
  name,
  nodes,
  if(items_sold_may_2017 is null, 0, items_sold_may_2017) items_sold_may_2017,
  if(items_sold_jan_2017 is null, 0, items_sold_jan_2017) items_sold_jan_2017,
  if(inventory is null, 0, inventory) inventory,
  if(
    if(items_sold_jan_2017=0, items_sold_may_2017, (if(items_sold_may_2017 is null, 0, items_sold_may_2017) - items_sold_jan_2017) / items_sold_jan_2017) is null,
    0, 
    if(items_sold_jan_2017=0, items_sold_may_2017, (if(items_sold_may_2017 is null, 0, items_sold_may_2017) - items_sold_jan_2017) / items_sold_jan_2017)
  ) as items_sold_change_2017
from
  (select m_community_id cid, name, count(distinct(memb_id)) nodes
  from `solid-ridge-104914.vs_reporting.user_memberships` u
  join `solid-ridge-104914.vs_reporting.communities` c on u.m_community_id = c.id
  group by cid, name) n
left join 
  (select
    cid,
    max(if(year = '2017-05', items_sold, 0)) items_sold_may_2017,
    max(if(year = '2017-01', items_sold, 0)) items_sold_jan_2017
  from
    (select 
      community.id cid, 
      format_date('%Y-%m', date(timestamp)) year, 
      count(distinct(item.id)) items_sold
    from `solid-ridge-104914.hipyard_analytics_production.item_events_partitioned` 
    where event = 'item_sold'
    and format_date('%Y', date(timestamp)) = '2017'
    and format_date('%m', date(timestamp)) in('01','05')
    group by cid, year)
  group by cid) s on s.cid = n.cid
left join 
  (select 
    community_id cid, 
    count(distinct(item_id)) inventory
  from `solid-ridge-104914.vs_reporting.community_items`  
  group by cid) inv on inv.cid = n.cid
order by cid

