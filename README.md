# Community Health

### What exactly is unique about healthy communities?
 
The people are hooked into the right loops with each other. By arranging members into networks, we can look at these loops. 
 
Be aware of newer, small communities very close to healthy ones, where new communities are started with members exhibiting behaviour learned in older communities. How much of that health belongs to that community?
 
### Some definitions:
 
**Community**: A unique set of members, identified by an equal level of access to each other, earned by having passed satisfiably consistent scrutiny.

**Network**: a collection of points called nodes, connected by lines called edges. We will be considering networks where the nodes are all the members of one community, and the edges are a certain type of interaction that can occur between them.

**Active Network**: the set of active users in a given period connected by the edges created in that period

**Network Density**: The proportion of possible edges that are actual edges

**Degree**: The number of edges connected to a node

**Weight**: A property of an edge, for us weight represents repeated interaction between a pair of members.

**Correlation**: A relationship between two variables, often indicating the presence some third factor that keeps the two in step with each other. It may also be true that variable A causes variable B or vice versa. There's even a chance it's a complete coincidence. When we find an unexpectedly strong correlation, we should meet it with skepticism and look for logical reasons why it might not be meaningful.

**Correlation Coefficient**: A value between -1 and 1 that represents the strength of a correlation.
 
### Analysis
 - Calculate network density
	Count of possible edges:
	  n*(n-1)/2
	  where n = nodes = number of memberships in a community
	Actual edges:
	  Number unique node pairs of a given edge type
 - Correlate network densities with corresponding community metrics [sell rate, replacement rate].
 - Cluster communities on a combination of traditional item-based metrics and network densities, as well as population stats    derived from node properties.

**Potential next steps**
 - Select key item-based and network-based stats and compare time series of selected communities.
 - Look for correlations between slopes across the set of communities.
 - Look for leading and lagging indicators in pairs of metrics with correlated slopes.
 
 
 
 
### Network structure
 
 - Nodes are half-members; senders and recipients, identified by their user_id
 - Senders and recipients cannot have infinitely many edges (the degree of the node). We are seeking to maximize this quantity.
 - Edges cannot have infinite weight. We are also seeking to maximize this quantity.
 - Edge types
	 - Message
 	 - comment 
	 - Interest
	 - follow
	 - Transaction
	 - Praise
	 - Approximated notifications? 
 - Direction of an edge is encoded in the order of the user_id pair that represents an edge, a pairing function is used to combine the two user_ids such that the order is preserved, so that distinct buyer-seller and seller-buyer relationships can be counted between the same two members.
 - Edges gain weight with repetition (except follow and praise)
 
 
### Questions

Is improving geo capabilities a feasible option?

Is there a way to distinguish message to buy and message to chat?
 
### What we cannot measure
 
How activity in one network becomes activity in another network.

The geographical significance of anything other than a static scattering of user locations about a community centroid
 
### Sources

Network Statistics: http://www.stats.ox.ac.uk/~reinert/talks/graduatenetworklectures.pdf
 
Calculating network density: http://www.the-vital-edge.com/what-is-network-density/

Comparing networks: http://www.ucl.ac.uk/bigdata-theory/wp-content/uploads/2015/03/Gesine-Reinert.pdf

Pairing function: https://math.stackexchange.com/questions/1980348/pairing-function-for-ordered-pairs 

Average Degree: https://math.stackexchange.com/questions/1383109/average-degree-in-graph

Potential Python package for working with networks: https://github.com/networkx/networkx/

Measures of Centrality: http://statmath.wu.ac.at/research/friday/resources_WS0708_SS08/igraph.pdf

Non-parametric (distribution does not matter) correlation: http://www.statisticssolutions.com/kendalls-tau-and-spearmans-rank-correlation-coefficient/
 
BigQuery Client for Python Code Examples: https://pypi.python.org/pypi/google-cloud-bigquery

Complex Adaptive Systems Primer: http://www.beyondintractability.org/essay/complex_adaptive_systems

Parallel Python for Running multiple queries: https://pymotw.com/2/multiprocessing/basics.html  ,
https://docs.python.org/3/library/multiprocessing.html#multiprocessing.pool.AsyncResult

#### More Reading to do:

http://www.fields.utoronto.ca/activities/16-17/randomgraphs-workshop

http://www.math.ryerson.ca/~abonato/

http://www.ryerson.ca/news/news/Research_News/20100803_math/

http://www.utdallas.edu/~sherry.xin.li/soc_pref_movielens_20081116.pdf ****

https://books.google.ca/books?id=lIvBMYVxWJYC&pg=PA1&lpg=PA1&dq=mathematical+models+of+online+communities&source=bl&ots=zYI0hpqgPE&sig=K3AfpjpgWvn3DgWjbFMrRHqwkXQ&hl=en&sa=X&ved=0ahUKEwjXz5me0drUAhXpx4MKHfTQBxYQ6AEIRDAG#v=onepage&q=mathematical%20models%20of%20online%20communities&f=false
