function enterSeed(foldername)
try
    prevSeeds = load('stable/seeds');
    prevN = prevSeeds.N;
    prevSeeds = prevSeeds.seeds;
catch ex
    prevSeeds = [];
    prevN = 0;
end

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

seedFile = strcat(foldername,'Seeds.txt');
currSeeds = importdata(seedFile,' ',0);

xseeds = interp1(timeSlots,xpos,currSeeds(:,1),'linear','extrap');
yseeds = interp1(timeSlots,ypos,currSeeds(:,1),'linear','extrap');

seeds =[];
if(~isempty(prevSeeds))
    for i=1:size(prevSeeds,1)
        xavg = (xseeds(i) + prevN*prevSeeds(i,1))/(prevN + 1);
        yavg = (yseeds(i) + prevN*prevSeeds(i,2))/(prevN + 1);
        seeds = [seeds; xavg yavg currSeeds(i,2)];
    end
    N = prevN + 1;
else
    for i=1:size(currSeeds,1)
        seeds = [seeds; xseeds(i) yseeds(i) currSeeds(i,2)];
    end
    N = 1;
end
save('stable/seeds','seeds','N');
end