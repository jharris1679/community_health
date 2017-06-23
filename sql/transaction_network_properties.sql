select
  'transaction' as edge_type,
  cf.cid,
  name,
  nodes*(nodes-1)/2 as possible_edges,
  items_sold_may_2017,
  inventory,
  items_sold_change_2017,
  actual_edges,
  avg_weight,
  nodes,
  if(nodes*(nodes-1)/2=0, 0, actual_edges/(nodes*(nodes-1)/2))*100 as network_density_X_100,
  2*actual_edges/nodes as avg_degree,
  avg_indegree,
  avg_outdegree
from `vs_reporting.community_facts` cf 
join
  (select m_community_id cid, count(distinct(2^buyer_id*2^seller_id)) actual_edges
  from vs_reporting.user_memberships u
  join
    (select cast(buyer_id as int64) as buyer_id, seller_id
    from `vs_reporting.transactions`
    where buyer_id != 'NULL') t on u.user_id = t.buyer_id
  group by cid) edges on cf.cid = edges.cid
join
  (select cid, avg(edge_weight) avg_weight
  from
    (select m_community_id cid, 2^buyer_id*2^seller_id edge, count(distinct(id)) edge_weight
    from vs_reporting.user_memberships u
    join
      (select cast(buyer_id as int64) as buyer_id, seller_id, id
      from `vs_reporting.transactions`
      where buyer_id != 'NULL') t on u.user_id = t.buyer_id
    group by cid, edge)
  group by cid) weight on weight.cid = cf.cid
join
  (select cid, avg(indeg) avg_indegree
  from
    (select m_community_id cid, buyer_id, count(distinct(id)) indeg
    from vs_reporting.user_memberships u
    join
      (select cast(buyer_id as int64) as buyer_id, seller_id, id
      from `vs_reporting.transactions`
      where buyer_id != 'NULL') t on u.user_id = t.buyer_id
    group by cid, buyer_id)
  group by cid) indegree on indegree.cid = cf.cid
join
  (select cid, avg(outdeg) avg_outdegree
  from
    (select m_community_id cid, seller_id, count(distinct(id)) outdeg
    from vs_reporting.user_memberships u
    join
      (select cast(buyer_id as int64) as buyer_id, seller_id, id
      from `vs_reporting.transactions`
      where buyer_id != 'NULL') t on u.user_id = t.buyer_id
    group by cid, seller_id)
  group by cid) outdegree on outdegree.cid = cf.cid 
where nodes > 100
order by cid
