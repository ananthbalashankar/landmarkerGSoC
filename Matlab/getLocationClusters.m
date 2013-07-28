function [results goodness areas ] = getLocationClusters(data,xpos,ypos,features,foldername,timeSlots,dataid,thresholds,areaThresholds)
    maxk = 5;
    
     results =[];
     areas = areaThresholds;



     goodness = thresholds;



     
    [initialseeds,optk] = kMeansInitAndStart(data,10,min(size(data,1),maxk));
    if(optk==-1)
        return;
    end
   [idx,centroids,sumd] = kmeansMod(data,optk,initialseeds); 

   g_sum = sum(sumd);
   clusterNum = 1;
   h=dialog ( 'visible', 'off', 'windowstyle', 'normal' );
   ax=axes('parent', h, 'nextplot', 'add' );
   cstring = 'rgbymck';
   %if(optk > 1 && optk < 6)       %%%%% filtering out reasonable features for location clustering
   if(optk>1)
       for j=1:size(centroids,1)
           index = 0;
           metric = (sumd(j)/( (size(find(idx==j),1)) * sqrt(length(features)) ));
           goodness(end+1) = metric;
          % for threshold = [0.1 0.3 0.7]
           
           threshold = prctile(thresholds,80);    
           if(metric < threshold)           %%%%goodness measure of the cluster
             cluster_data = [xpos(idx==j)', ypos(idx==j)'];
                maxk = 5;
                [initialseeds,optk]=kMeansInitAndStart(cluster_data,10,min(maxk,size(cluster_data,1)));
                if(optk==-1)
                    continue;
                else
                    [Lidx,Lcentroid,Lsumd] = kmeansMod(cluster_data,optk,initialseeds);

                   for n=1:optk
                        numOfPoints = sum(Lidx==n);
                        distance = Lsumd(n)/numOfPoints;
                        areas(end+1) = distance;      
                        areaThreshold = prctile(areaThresholds,80);
			
                        if(distance < areaThreshold)        %%%within 1 m from the centroid for each cluster
                            if(clusterNum==1)
                                plot(ax,xpos,ypos,'-');
                            end
                            fid = fopen(strcat(foldername,'/clusters.csv'),'a');
                            %clusters, location cluster number ,feature cluster num, num of points in the location cluster,x,y of the centroid, intra-cluster avg distance. 
			    xaxis = cluster_data(:,1);
                            yaxis = cluster_data(:,2);
			   timeaxis = timeSlots(idx==j);
			   timeaxis = timeaxis(Lidx==n);
			   featCluster = data(idx==j);
			   featCluster = featCluster(Lidx==n);   

                            fprintf(fid,'%s,%d,%d,%d,%d,%f,%f,%f\n',num2str(features),clusterNum,j,n,numOfPoints,Lcentroid(n,1),Lcentroid(n,2),Lsumd(n)/numOfPoints);
		            fclose(fid); 
			   results{end+1} = { num2str(features), [Lcentroid(n,1),Lcentroid(n,2)] , numOfPoints, [xaxis(Lidx==n),yaxis(Lidx==n)], timeaxis, timeSlots(1), featCluster };
                            plot(ax,xaxis(Lidx==n),yaxis(Lidx==n),strcat(cstring(mod(clusterNum,7)+1),'+'));
                            saveas(ax, strcat(foldername,'\',num2str(features)), 'png' );
                            clusterNum = clusterNum + 1;
                        end
                   end
                end
           end 
           end
      % end
   end

end

