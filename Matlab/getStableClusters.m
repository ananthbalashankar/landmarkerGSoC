function [stable stableFeat newPath] = getStableClusters(cluster, path, timeSlots, old_stable, old_stableFeat,conn,dataid,foldername,commit)
stable =  old_stable;
stableFeat = old_stableFeat;
newPath = path;

if(isempty(old_stable))
    i=1;
else
    i=0;
end

clusters = {};      %stores the clusters in the order in which they were encountered in the path
numFeatures = size(cluster,2);
for j=1:numFeatures
    featClusters = cluster{j};
    if(~isempty(featClusters))
        for n=1:size(featClusters,2)
            
            featCluster = featClusters{n};
            s = length(clusters);
            temp_clusters = clusters;
            if(s~=0)
                temp = clusters{s};
                while(min(temp{5}) > min(featCluster{5}))
                    s = s-1;
                    if(s>0)
                        temp = clusters{s};
                    else
                        break;
                    end
                end
                
            end
            clusters{s+1} = featCluster;
            for t=s+1:length(temp_clusters)
                clusters{t+1} = temp_clusters{t};
            end
        end
    end
end


correctionVector = [0 0];
lastLandmark = {[0 0],timeSlots(1)};
landmarkid = 1;
for p =1:length(clusters)
    found = 0;
    featCluster = clusters{p};
    feature = featCluster{1};
    centroid = featCluster{2};
    numPoints = featCluster{3};
    location = featCluster{4};
    clusterTime = featCluster{5};
    firstTime = min(clusterTime);
    featData = featCluster{7};
    %6: the first time stamp,
    %7: feature data
    %8: number of clusters combined to get this one
    %9 : time before which last landmark was seen
    %try
    for k=1:size(stableFeat,2)
        if(strcmp(feature,stableFeat{k}))
            stableClusters = stable{k};
            min_val = 2; min_cluster = 0;
            minFeat = 0.5;
            for m =1:size(stableClusters,2)
                if(mean(mean(pdist2(location,stableClusters{m}{4},'euclidean'))) < min_val && mean(mean(pdist2(featData,stableClusters{m}{7},'euclidean')))< minFeat) %TODO:nearness in feature space
                    found = 1;
                    min_val = mean(mean(pdist2(location,stableClusters{m}{4},'euclidean')));
                    min_cluster = m;
                    %Combine
                end
            end
            
            if(found && i~=1)
                diff = (stableClusters{min_cluster}{2} - centroid);                 %Localization
                
                newPath = correctLocation(newPath, diff, lastLandmark,firstTime,timeSlots,centroid);
                lastLandmark =  {stableClusters{min_cluster}{2}, firstTime};
                
                result = combineClusters(featCluster,stableClusters{min_cluster},correctionVector);     %Stabilization
                
                disp(stableFeat{k});
                stable{k}{min_cluster} = result;
                
                
                id = result{9};
                features = result{1};
                xposition = result{2}(1);
                yposition = result{2}(2);
                numOfPoints = result{3};
                confidence = result{8};
                cluster_data = result{4};
                timeaxis = result{5};
                featCluster = result{7};
                %write to file the cluster points
%                 filename = result{10};
%                 
%                 
%                 xaxis = cluster_data(:,1);
%                 yaxis = cluster_data(:,2);
%                 
%                 fid = fopen(filename,'w');
%                 Time = timeaxis';
%                 X = xaxis;
%                 Y = yaxis;
%                 for h=1:size(X,1)
%                     fprintf(fid,'%d %f %f',Time(h),X(h),Y(h));
%                     for b=1:size(featCluster,2)
%                         fprintf(fid,'%f ',featCluster(h,b));
%                     end
%                     fprintf(fid,'\n');
%                 end
%                 fclose(fid);
                
                %database
                if(commit)
                    query = sprintf('update landmark set centroidx=%f ,centroidy=%f,numofpoints=%d,confidence=%d where id=%d',xposition,yposition,numOfPoints,confidence,id);
                    curs = exec(conn,query);
                    query
                end
                %a = fetch(curs);
                
                
                diff = (stable{k}{min_cluster}{2} - centroid);
                correctionVector = correctionVector + diff;
            else
                k_stable = stable{k};
                featCluster{8} = 1;
                %database
                if(commit)
                    query = 'Select max(id) from landmark';
                    curs = exec(conn,query);
                    landmarkid = fetch(curs);
                    landmarkid = landmarkid.Data(1);
                    landmarkid = landmarkid{1};
                    landmarkid = landmarkid + 1;
                    filename = sprintf('%s/landmarks%d.txt',foldername,landmarkid);
                    featCluster{10} = filename;
                    featCluster{9} = landmarkid;
                    cluster_data = featCluster{4};
                    timeaxis = featCluster{5};
                else
                    featCluster{9} = -1;
                    featCluster{10} = 'none';
                end
%                 xaxis = cluster_data(:,1);
%                 yaxis = cluster_data(:,2);
%                 
%                 fid = fopen(filename,'w');
%                 Time = timeaxis';
%                 X = xaxis;
%                 Y = yaxis;
%                 for h=1:size(X,1)
%                     fprintf(fid,'%d %f %f',Time(h),X(h),Y(h));
%                     for b=1:size(featCluster{7},2)
%                         fprintf(fid,'%f ',featCluster{7}(h,b));
%                     end
%                     fprintf(fid,'\n');
%                 end
%                 fclose(fid);
%                 
                k_stable{end+1} = featCluster;
                stable{k} = k_stable;
                found = 1;
                if(commit)
                    cols = {'centroidx','centroidy','numofpoints','confidence','file','feat','dataid'};
                    vals = {featCluster{2}(1),featCluster{2}(2),featCluster{3},featCluster{8},featCluster{10},featCluster{1},dataid};
                    fastinsert(conn,'landmark',cols,vals); 
                end
                msg = sprintf('OLM of %s updated at (%f,%f)\n',featCluster{1},featCluster{2}(1),featCluster{2}(2));
                disp(msg);
            end
            break;
        end
    end
    %catch
    %disp('error');
    %end
    
    if(~found)
        
        featCluster{8} = 1;
        if(commit)
            cols = {'centroidx','centroidy','numofpoints','confidence','file','feat','dataid'};
            vals = {featCluster{2}(1),featCluster{2}(2),featCluster{3},featCluster{8},'none',featCluster{1},dataid};
            fastinsert(conn,'landmark',cols,vals);
        
            query = 'Select max(id) from landmark';
            curs = exec(conn,query);
            landmarkid = fetch(curs);
            landmarkid = landmarkid.Data(1);
            landmarkid = landmarkid{1};
            featCluster{9} = landmarkid;
            featCluster{10} = 'none';
        else
            featCluster{9} = -1;
            featCluster{10} = 'none';
        end
%         filename = sprintf('%s/landmarks%d.txt',foldername,landmarkid);
%         featCluster{10} = filename;
        
%         cluster_data = featCluster{4};
%         timeaxis = featCluster{5};
        
%         xaxis = cluster_data(:,1);
%         yaxis = cluster_data(:,2);
%         
%         fid = fopen(filename,'w');
%         Time = timeaxis';
%         X = xaxis;
%         Y = yaxis;
%         for h=1:size(X,1)
%             fprintf(fid,'%d %f %f',Time(h),X(h),Y(h));
%             for b=1:size(featCluster{7},2)
%                 fprintf(fid,'%f ',featCluster{7}(h,b));
%             end
%             fprintf(fid,'\n');
%         end
%         fclose(fid);
        
        
        stableFeat{end+1} = feature;
        msg = sprintf('OLM of %s added at (%f,%f)\n',featCluster{1},featCluster{2}(1),featCluster{2}(2));
        disp(msg);
        stable{end+1} = {featCluster};
    end
end

end
