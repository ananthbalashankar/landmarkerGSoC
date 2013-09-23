function updateLocation(foldername,userid)
filenames = dir(foldername);
files = {};
for j=[8 10 2 1]
    for i=1:length(filenames)
        match=regexpi(filenames(i).name,strcat('._',num2str(j),'\.txt'));
        if(isempty(match) == false)
            files{end+1} = strcat(foldername,'/',filenames(i).name);
        end
    end
end

linacc = importdata(files{1},' ',1);
ori = importdata(files{2},' ',1);
gyro = importdata(files{3},' ',1);
mag = importdata(files{4},' ',1);
[xpos ypos LocTime]= getLocation(linacc.data,ori.data,gyro.data,mag.data,foldername);

startTime = Inf;
startTime = min(startTime,min(linacc.data(:,1)));
startTime = min(startTime,min(ori.data(:,1)));
startTime = min(startTime,min(gyro.data(:,1)));
startTime = min(startTime,min(mag.data(:,1)));

stopTime = -Inf;
stopTime = max(stopTime,max(linacc.data(:,1)));
stopTime = max(stopTime,max(ori.data(:,1)));
stopTime = max(stopTime,max(gyro.data(:,1)));
stopTime = max(stopTime,max(mag.data(:,1)));

timeSteps = ceil((stopTime - startTime)/(2*10^7)); 

timeSlots = [startTime:2*10^7:startTime+(timeSteps*2*10^7)];
LocTime = [0;LocTime];
xpos = interp1(LocTime,xpos',timeSlots,'linear','extrap');
ypos = interp1(LocTime,ypos',timeSlots,'linear','extrap');

Mag = interp1(mag.data(:,1),mag.data(:,[3 4 5]), timeSlots,'linear','extrap');
Ori = interp1(linacc.data(:,1),linacc.data(:,[3 4 5]), timeSlots,'linear','extrap');
Acc = interp1(ori.data(:,1),ori.data(:,[3 4 5]), timeSlots,'linear','extrap');

location = correctSeed([xpos' ypos'],timeSlots,Mag,Acc,Ori,foldername);

landmarks = load('stable/cluster');
landmarks = landmarks.stable;
stable = {};
for i=1:length(landmarks)
feat = landmarks(i);
feat = feat{1};
for j=1:length(feat)
    stable{end+1} = feat{j};
end
end

minid = -1; dist = Inf;
x = location(end,1);
y = location(end,2);    %Current location

 for j=1:length(stable)
    landmark = stable{j};
    centroid = landmark(2);
    centroid = centroid{1};
     if(dist > ((centroid(1) -x)^2 + (centroid(2)-y)^2))
         minid = landmark(9);
         dist = (centroid(1) -x)^2 + (centroid(2)-y)^2;
     end
 end
landmarkid = minid;
landmarkid = landmarkid{1};

%comments = load('stable/comments');
%comments = comments.comments;
%selected = {};
%for i=1:length(comments)
%    if(comments{i}{5} == landmarkid)
%        selected{end+1} = comments{i};
%    end
%end

conn = database('landmark','root','ananth','com.mysql.jdbc.Driver','jdbc:mysql://localhost/landmark');

query = sprintf('select rating, comment, username, time from comments JOIN (select * from sample JOIN users where userid=uid) as names where comments.dataid=names.dataid and comments.landmarkid=%d',landmarkid);
an = exec(conn,query);
data = fetch(an);
selected = data.Data;
try
if(strcmp(selected,'No Data'))
     selected = {};
end
catch
end
query = sprintf('select landmarkid, updated_at from users where uid = %d',userid);
ans= exec(conn,query);
data = fetch(ans);
prevLandmark = data.Data(1)
prevTime = data.Data(2)
landmarkid
if(strcmp(prevTime,'null')~=0 && ~isnan(prevLandmark{1}))
    prevTime = prevTime{1};
    a = sscanf(prevTime,'%d-%d-%d %d:%d:%f');
    prevTime = datenum(a(1),a(2),a(3),a(4),a(5),a(6));
    change = 0;sent ={};
    if(prevLandmark ~= landmarkid)
        change = 2;
        sent = selected;
    else
        for i=1:size(selected,1)
            Time = selected{i,4};
            %Time = Time{1};
            a = sscanf(Time,'%d-%d-%d %d:%d:%f');
            Time = datenum(a(1),a(2),a(3),a(4),a(5),a(6));
            if(Time > prevTime)
                sent{end+1} = {selected{i,1} selected{i,2} selected{i,3} selected{i,4}};
            end
        end
        if(size(sent,1) > 0)
            change = 1;
        end
    end   
else
    change = 2;
    sent = selected;
end

if(change == 1|| change==2)
    file = sprintf('stable/notifications_%d.txt',userid);
    fid = fopen(file,'w');
    if(change==1)
        for i=1:length(sent)
                fprintf(fid,'%f:%s:%s;',sent{i}{1},sent{i}{2},sent{i}{3});
        end
    else
        for i=1:size(sent,1)
            fprintf(fid,'%f:%s:%s;',sent{i,1},sent{i,2},sent{i,3});
        end	    
    end
    fclose(fid);
    
    query = sprintf('update users set updated_at=NOW(), landmarkid=%d where uid=%d',landmarkid,userid);
    exec(conn,query);
end
disp('update ended');
end
