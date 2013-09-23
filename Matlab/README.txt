Parsedata()
    filepath = "XXX"
    getCluster(XXX)
    
getCluster(XXX)
    traversedpath <= getLocation()
    read from all files
    constant sampling rate
    noise reduction
    normalization
    feature extraction( SMA + others)
    for each feature according to 1/2/3 combinations
        getLocationCluster()
        
getLocationCluster(feature, x array, y array, ....)
    initialseeds, optk <= kmeansInitAndStart()
    clusters,EuclSum <= kmeansMod(initialseeds,optk)
    if #clusters > 1:
        for each cluster in clusters:
            if(avg(EuclSum of cluster) < thresh*(1 or sqrt(2) or sqrt(3)):
                initialSeeds, optk <= kmeansInitAndStart([x y] belonging to cluster)
                LocClusters, LocDist <= kmeansMod(initialSeeds,optk)
                for each lc in LocClusters:
                    if(avg(LocDist) of points in lc < radiusOfLandmark):    1m  
                        Store/plot the cluster
                        
kmeansInitAndStart( data , S= No of subsets that the data is broken into , max_cluster ):
    Partitioning the data into S subsets
    Calculating centres by doing kmeansmod in each sample subset to get k clusters from each subset 
    Call kmeans, if converge error call kmeansMod with intial seed as "singleton" and get the centroids of the clusters
    for each subset-centroid as initial seeds:
        sum(Sumd) <= Cluster according to the set of all centroids got from the subsets
    Find minimum of Sumd across all subsets
    InitialSeeds <= Centroids of the subset which had minimum DistortSum
    Optk(data, max_cluster, initialSeeds)
    
   
kmeansMod:
    Run kmeans until the data converges with no error
   
Optk:
    Get alpha acc to paper:  as a function of the #columns in the data
    Cluster over different k=1:max_cluster and get sumd for each clustering
    Get Fk as a fn of alpha, sumd for each k
    Find min(Fk) and return that k
    
Stabilize:
    Goes through the 6 traces of each <device, place, person, time> and runs getStableClusters
    
getStableClusters:
    Save the stable landmarks in the corresponding folder "F1"
 
Landmark: <Name of the feature,centroid loc, numOfPoints, Location of those points,timestamps of those points, Initial timestamp, feature data>

plotDevice, plotPerson:
calls ChangeDevice, plotPerson
plots the graphs

ChangeDevice, changePerson, changeTime:
Goes through all F1s by varying Device keeping others constant... 
    It'll run analyzeStability
    
analyzeStability:
Combines Landmarks across different parameter values using combineCluster.m

combineCluster:
CombineCluster and correct location in correctLocation.m

Graph Plotters:
cdf 
averageGoodness : analyses area
countClusters
countFeatures
countStable

clusterWifi:
cluster Wifi feature according to paper
calls MatEx1.5/kmedoidshort which calls MatEx1.5/wifiSimilarity