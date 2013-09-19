function  parsedata(dir_path,userid)
warning('off','all');

foldername = dir_path;
conn = database('landmark','root','swadhin','com.mysql.jdbc.Driver','jdbc:mysql://localhost/landmark');
cols = {'folder','start_time','userid'};
vals = {foldername,datestr(now),userid};
%database
fastinsert(conn,'sample',cols,vals);
query = sprintf('select dataid from sample where folder=''%s''',foldername);
curs = exec(conn,query);
a = fetch(curs);

%insert seed landmarks
% seeds = importdata(strcat(dir_path,'/Seeds.txt'),' ',0);
% try
% stable = load('stable/seeds');
% stable = stable.seeds;
% catch
%     mkdir('stable');
%     stable = [];
% end
% seeds = [stable;seeds]
% save('stable/seeds','seeds');

%dataid = 1; 
dataid = a.Data(end);
dataid = dataid{1};                         
file = dir_path;
command = strcat('perl wifi_ap_info_reader.pl "',file,'"');
status = dos(command,'-echo');
[cluster goodness areas dataid] = getClusters(file,userid,dataid);
save(strcat(file,'/cluster'),'cluster');
save(strcat('stable/areas'),'areas');
save(strcat('stable/goodness'),'goodness');

%stabilize the landmarks

stabilize(file,conn,dataid,1);			    

% location = load(strcat(file,'/location'));
%annotate comments with landmarks
annotateComments(file,conn,dataid);
end
