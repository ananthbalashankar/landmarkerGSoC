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
startTime = min(startTime,linacc(:,1));
startTime = min(startTime,ori(:,1));
startTime = min(startTime,gyro(:,1));
startTime = min(startTime,mag(:,1));

stopTime = -Inf;
stopTime = max(stopTime,linacc(:,1));
stopTime = max(stopTime,ori(:,1));
stopTime = max(stopTime,gyro(:,1));
stopTime = max(stopTime,mag(:,1));

timeSlots = [startTime:2*10^7:startTime+(timeSteps*2*10^7)];
LocTime = [0;LocTime];
xpos = interp1(LocTime,xpos',timeSlots,'linear','extrap');
ypos = interp1(LocTime,ypos',timeSlots,'linear','extrap');

location = correctSeed([xpos' ypos'],timeSlots,mag(:,[3 4 5]),linacc(:,[3 4 5]),foldername);

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

comments = load('stable/comments');
comments = comments.comments;
selected = {};
for i=1:size(comments,1)
    if(comments(i,5) == landmarkid)
        selected = vertcat(selected,comments(i,:));
    end
end

conn = database('landmark','root','swadhin','com.mysql.jdbc.Driver','jdbc:mysql://localhost/landmark');
query = sprintf('select landmarkid, updated_at from users where uid = %d',userid);
ans= exec(conn,query);
data = fetch(ans);
prevLandmark = data.Data(1);
prevTime = data.Data(2);
prevTime = prevTime{1};
a = sscanf(prevTime,'%d-%d-%d %d:%d:%f');
prevTime = datenum(a(1),a(2),a(3),a(4),a(5),a(6));

change = 0;
sent =[];
if(prevLandmark ~= landmarkid)
    change = 1;
    sent = selected;
else
    for i=1:size(selected,1)
        Time = selected(i,3);
        Time = Time{1};
        a = sscanf(Time,'%d-%d-%d %d:%d:%f');
        Time = datenum(a(1),a(2),a(3),a(4),a(5),a(6));
        if(Time > prevTime)
            sent = vertcat(sent,selected(i,:));
        end
    end
    if(size(sent,1) > 0)
        change = 1;
    end
end

if(change == 1)
    file = sprintf('stable/notifications_%d.txt',userid);
    fid = fopen(file,'w');
    for i=1:size(selected,1)
        fprintf(fid,'%f %s\n',sent(i,1),sent(i,2));
    end
    fclose(fid);
    
    query = sprintf('update users set updated_at=NOW() where uid=%d',userid);
    exec(conn,query);
end

end