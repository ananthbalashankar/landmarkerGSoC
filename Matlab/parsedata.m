function  parsedata(dir_path)
    warning('off','all');
    parseFiles = {};
   % for device = {  'Galaxy_S3'}
    %    for place = {'TechMarket','CS_dep'}
     %       for person = {'Ananth','Suman','Sourav','Swadhin'}
      %           for time = {'Day', 'Night'}
                    %device = 'Galaxy_S2'; place = 'TechMarket'; person = 'Sourav'; time = 'Night';
                    %dir_path = strcat('../data/Landmarker_Data/',device{1},'/',place{1},'/',person{1},'/',time{1},'/');
                    %dir_path = strcat('/home/swadhin/Landmark/data/Landmarker_Data/',device,'/',place,'/',person,'/',time,'/');
                    filenames = dir(dir_path);
                    files = {};
                    for i=1:length(filenames)
                        match=regexpi(filenames(i).name,'SensoSaur_.');
                        if(isempty(match) == false)
                            files{end+1} = strcat(dir_path,filenames(i).name);
                            %disp(files{end});
                        end
                    end
                    
      %              for file= files
       %                    load(strcat(file{1},'/wifi_gsm'));
        %                    parseFiles{end+1} = file{1};
         %               catch
          %             end
           %         end
       %          end
        %    end
       % end
     %end
    
%     for device = { 'Galaxy_S3'}
%         for place = {'TechMarket','CS_dep'}
%             for person = {'Ananth','Suman','Sourav','Swadhin'}
%                  for time = { 'Day','Night'}
%                     %device = 'Galaxy_S3'; place = 'TechMarket'; person = 'Sourav'; time = 'Night';
%                     dir_path = strcat('../data/Landmarker_Data/',device{1},'/',place{1},'/',person{1},'/',time{1},'/');
%                     %dir_path = strcat('../data/Landmarker_Data/',device,'/',place,'/',person,'/',time,'/');
%                     filenames = dir(dir_path);
%                     files = {};
%                     for i=1:length(filenames)
%                         match=regexpi(filenames(i).name,'SensoSaur_.');
%                         if(isempty(match) == false)
%                             files{end+1} = strcat(dir_path,filenames(i).name);
%                             disp(files{end});
%                         end
%                     end
                    
%                     index = 0;
%                     for file = parseFiles
%                         index = index +1;
%                         
                            file = dir_path;
                            command = strcat('perl wifi_ap_info_reader.pl "',file,'"');
                            status = dos(command,'-echo');
                            for goodness=[0.1 0.3 0.7]
                                string = strcat(file,'/clusters_',num2str(goodness*10),'.csv')
                                fid = fopen(string ,'w');
                                fclose(fid);
                            end
                            [cluster goodness areas] = getClusters(file,10);
                            save(strcat(file,'/cluster'),'cluster');
                            save(strcat(file,'/area'),'areas');
                            
			    %stabilize the landmarks
			    
			
                            %annotate comments with landmarks
                            annotateComments(cluster,file);
                            %save(strcat(file,'/clusters_new'),'cluster');
                            %save(strcat(file,'/goodness'),'goodness');
                            %save(strcat(file,'/areas'),'areas');
%                     end                    
%                     
%                  end
%             end
%         end
%     end
end
