function  parsedata(dir_path)
warning('off','all');

userid = 10;
foldername = dir_path;
conn = database('sample','postgres','ananth','org.postgresql.Driver','jdbc:postgresql:sample');
cols = {'folder','start_time','userid'};
vals = {foldername,datestr(now),userid};
fastinsert(conn,'sample',cols,vals);
query = sprintf('select dataid from sample where folder=''%s''',foldername);
curs = exec(conn,query)
a = fetch(curs);

%insert seed landmarks
seeds = importdata(strcat(dir_path,'/Seeds.txt'),' ',0);
try
stable = load('stable/seeds');
catch
stable = [];
end
stable = [stable;seeds];
save('stable/seeds',stable);


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

stabilize(file,conn,dataid);			    

% location = load(strcat(file,'/location'));
%annotate comments with landmarks
annotateComments(file,conn,dataid);
end
