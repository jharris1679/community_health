import pandas as pd
import pandas_gbq as pgbq
from multiprocessing import Pool
from scipy import stats
import os
import time
import numpy as np
import re

def build_table(module_type):
    print(module_type)
    if __name__ == '__main__':
        with Pool(processes=len(sql_modules)) as pool:
            result = pool.map(bigquery_worker, (range(len(sql_modules),)))
            pool.close()
            pool.join()
    joined = result[0].set_index('cid', drop=True)
    print('Joining ',module_type,' modules', sep='')
    for i in range(len(result)-1):
        joined = joined.join(result[i+1].set_index('cid'), how='left', lsuffix='_left')
    table = joined.replace([np.inf,-np.inf], np.nan)
    table.fillna(0, inplace=True)
    table.sort_index(inplace=True)
    if re.match('community_facts', module_type) is None:
        table = add_network_stats(table, module_type)
    #pgbq.to_gbq(network_stats, dataset+'.'+sql_module_type+'_stats', google_project_id, if_exists='replace', verbose=False)
    print('Done', sep='')
    return(table)

def open_active_modules(module_type):
    directory = '/Users/joshharris/community_health/sql/module_types/'+module_type
    sql_files = list(map(lambda x: os.path.splitext(x), os.listdir(directory)))
    sql_modules = list()
    for i in range(len(sql_files)):
        if sql_files[i][1] == '.on':
            sql_modules.append(sql_files[i][0])
    return(sql_modules)

def bigquery_worker(i):  
    sql_module = sql_modules[i]
    print('Starting module ',i,': ',sql_modules[i], sep='')
    try:
        result = pgbq.read_gbq('select * from community_networks.'+module_type+'_'+sql_module, google_project_id, dialect='standard', verbose=False)
        print(module_type,'_',sql_module,' table found.', sep='')
    except:
        print(module_type,'_',sql_module,' table does not exist, generating now', sep='')
        with open(directory+'/'+sql_module) as query_file:
            query = query_file.read()
        result = pgbq.read_gbq(query, google_project_id, dialect='standard', verbose=False)
        print('Creating new ',module_type,'_',sql_module,' table', sep='')
        pgbq.to_gbq(result, dataset+'.'+module_type+'_'+sql_module, google_project_id, if_exists='replace', verbose=False)
        print('Module ',i,': ',sql_module,'query complete', sep='')
    return (result)

def add_network_stats(df, sql_module_type):
    edges = df[sql_module_type+'_edges']
    nodes = df[sql_module_type+'_nodes']
    avg_indegree = df[sql_module_type+'_avg_indegree']
    avg_outdegree = df[sql_module_type+'_avg_outdegree']
    df[sql_module_type+'_network_density_X_100'] = (edges/(nodes*(nodes-1)/2))*100
    df[sql_module_type+'_indegree_skew'] = (avg_indegree-avg_outdegree)/avg_outdegree
    df.drop([sql_module_type+'_edges',sql_module_type+'_nodes'], axis=1, inplace=True)
    return(df)    
