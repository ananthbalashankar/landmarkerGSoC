function [results goodness areas] = getLocationClusters(data,xpos,ypos,features,foldername,timeSlots,dataid,conn)
    maxk = 5;
    
     results ={};
     areas = {};
     areas_1 = [];
     areas_2 = [];
     areas_3 = [];
     goodness = [];
     results_1 = {};
     results_2 = {};
     results_3 = {};
     
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
           for threshold = [0.1 0.3 0.7]
           index = index +1;
           
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
                         if(index ==1)
                                areas_1(end+1) = distance;
                         else if(index ==2)
                                    areas_2(end+1) = distance;
                              else
                                    areas_3(end+1) = distance;
                              end
                         end
                        if(distance < 1)        %%%within 1 m from the centroid for each cluster
                            if(clusterNum==1)
                                plot(ax,xpos,ypos,'-');
                            end
                            fid = fopen(strcat(foldername,'/clusters_',num2str(threshold*10),'.csv'),'a');
                            %clusters, location cluster number ,feature cluster num, num of points in the location cluster,x,y of the centroid, intra-cluster avg distance. 
                            fprintf(fid,'%s,%d,%d,%d,%d,%f,%f,%f\n',num2str(features),clusterNum,j,n,numOfPoints,Lcentroid(n,1),Lcentroid(n,2),Lsumd(n)/numOfPoints);
		           
			   %write to file the cluster points
			   filename = strcat(foldername,'/',num2str(features),'_',clusterNum,'.txt');
			   	
			   xposition = Lcentroid(n,1);
			   yposition = Lcentroid(n,2);
				%store in database 
			   query = sprintf('insert into landmark(dataid,feat,centroidx,centroidy,numofpoints,confidence,file) values(''%d'',''%s'',%f,%f,''%d'',''%d'',''%s'');',dataid,num2str(features),xposition,yposition,numOfPoints,1,filename);
                           curs = exec(conn,query);
                           a = fetch(curs);


                            fclose(fid);
                            xaxis = cluster_data(:,1);
                            yaxis = cluster_data(:,2);
                            timeaxis = timeSlots(idx==j);
                           timeaxis = timeaxis(Lidx ==n);
                            featCluster = data(idx==j);
                            featCluster = featCluster(Lidx == n);
			    fid = fopen(filename,'w');
			    Time = timeaxis';
			    X = xaxis(Lidx==n);
			    Y = yaxis(Lidx==n);
			    for h=1:size(X,1)
				fprintf(fid,'%d %f %f',Time(h),X(h),Y(h));
				for b=1:size(featCluster,2)
					fprintf(fid,'%f ',featCluster(h,b));
				end
				fprintf(fid,'\n');
			    end
                            if(index ==1)
                                results_1{end+1} = { num2str(features), [Lcentroid(n,1),Lcentroid(n,2)] , numOfPoints, [xaxis(Lidx==n),yaxis(Lidx==n)], timeaxis, timeSlots(1), featCluster };
                            else if(index ==2)
                                    results_2{end+1} = { num2str(features), [Lcentroid(n,1),Lcentroid(n,2)] , numOfPoints, [xaxis(Lidx==n),yaxis(Lidx==n)], timeaxis, timeSlots(1), featCluster };
                                else
                                    results_3{end+1} = { num2str(features), [Lcentroid(n,1),Lcentroid(n,2)] , numOfPoints, [xaxis(Lidx==n),yaxis(Lidx==n)], timeaxis, timeSlots(1), featCluster };
				end
			    end
                            plot(ax,xaxis(Lidx==n),yaxis(Lidx==n),strcat(cstring(mod(clusterNum,7)+1),'+'));
                            saveas ( ax, strcat(foldername,'\',num2str(features),'_',num2str(threshold*10)), 'png' );
                            clusterNum = clusterNum + 1;
                        end
                   end
                end
           end 
           end
       end
   end
   %close(h);
   areas = { areas_1 areas_2 areas_3};
   results = { results_1 results_2 results_3};
end

