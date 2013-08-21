function [stable stableFeat newLocation] = stabilize(dir_path,conn,dataid)
warning('off','all');
clusters = {};
err = 0;
err_count = 0;

filenames = dir(dir_path);
files = {};

%conn = database('sample','postgres','ananth','org.postgresql.Driver','jdbc:postgresql:sample');


%%%%change initial Landmarks here
try
    s = load(strcat('stable/cluster'));
    stable = s.stable;
    stableFeat = s.stableFeat;
catch
    mkdir('stable');
    stable = {};
    stableFeat = {};
end

x = load(strcat(dir_path,'/cluster.mat'));
loc = load(strcat(dir_path,'/location'));
location = [loc.xpos loc.ypos];
timeSlots = loc.timeSlots;

if(~isempty(x.cluster))
    featcluster = x.cluster;
    clusters{end+1} = featcluster;
end

[stable stableFeat newLocation] = getStableClusters(featcluster,location,timeSlots,stable,stableFeat,conn,dataid,dir_path);                         %calculate stable clusters
save(strcat(dir_path,'/newLocation'),'newLocation','timeSlots');
save('stable/cluster','stable','stableFeat');

end
