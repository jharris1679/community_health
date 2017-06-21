select 
  'transaction' as edge_type,
  p.cid,
  name,
  nodes, 
  nodes*(nodes-1)/2 as possible_edges, 
  actual_edges,
  if(nodes*(nodes-1)/2=0, 0, actual_edges/(nodes*(nodes-1)/2))*100 as network_denstiy_X_100,
  2*actual_edges/nodes as avg_degree,
  avg_weight
from
  (select m_community_id cid, name, count(distinct(memb_id)) nodes
  from `vs_reporting.user_memberships` u
  join `vs_reporting.communities` c on u.m_community_id = c.id
  group by cid, name) p
join 
  (select m_community_id cid, count(distinct(2^buyer_id*2^seller_id)) actual_edges
  from vs_reporting.user_memberships u
  join 
    (select cast(buyer_id as int64) as buyer_id, seller_id
    from `vs_reporting.transactions`
    where buyer_id != 'NULL') t on u.user_id = t.buyer_id
  group by cid) a on p.cid = a.cid
join 
  (select cid, avg(weight) avg_weight
  from
    (select m_community_id cid, 2^buyer_id*2^seller_id actual_edges, count(distinct(item_id)) weight
    from vs_reporting.user_memberships u
    join 
      (select cast(buyer_id as int64) as buyer_id, seller_id, item_id
      from `vs_reporting.transactions`
      where buyer_id != 'NULL') t on u.user_id = t.buyer_id
    group by cid, actual_edges)
  group by cid) w on w.cid = p.cid
where nodes > 100
order by cid