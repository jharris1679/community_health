select 
  'transaction' as edge_type,
  p.cid,
  name,
  nodes*(nodes-1)/2 as possible_edges, 
  actual_edges,
  nodes, 
  if(nodes*(nodes-1)/2=0, 0, actual_edges/(nodes*(nodes-1)/2))*100 as network_density_X_100,
  2*actual_edges/nodes as avg_degree,
  avg_weight,
  round(nodes*(2*actual_edges/nodes)*avg_weight, 0) total_transactions
from
  (select m_community_id cid, name, count(distinct(memb_id)) nodes
  from `vs_reporting.user_memberships` u
  join `vs_reporting.communities` c on u.m_community_id = c.id
  group by cid, name) p
join 
  (select m_community_id cid, count(distinct(conversation.id)) actual_edges
  from vs_reporting.user_memberships u
  join `hipyard_analytics_production.message_events_partitioned` m on u.user_id = m.sender.id
  group by cid) a on p.cid = a.cid
join 
  (select cid, avg(edge_weight) avg_weight
  from
    (select m_community_id cid, conversation.id edge, count(distinct(timestamp)) edge_weight
    from vs_reporting.user_memberships u
    join `hipyard_analytics_production.message_events_partitioned` m on u.user_id = m.sender.id
    group by cid, edge)
  group by cid) w on w.cid = p.cid
where nodes > 100
order by cid
