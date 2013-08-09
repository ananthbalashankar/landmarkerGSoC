function newlocation = correctSeed(location,timeSlots,mag,acc,foldername)
try
    seeds = load('stable/seeds');
    seeds = seeds.seeds;
    
    i=1;
    
    newseeds = [];
    correctx = 0;
    correcty = 0;
    
    landmarks = importdata(strcat(foldername,'/landMarks.txt'),' ',0);
    landmarks = landmarks.data;
    %Correct location with ticks
    types = seeds(:,4);
    ticks = seeds(types == 3,:);
    lastCentroid = [0 0];
    for j=1:size(landmarks,1)
        newLocationx = location(:,1);
        newLocationy = location(:,2);
        pos = find(diff(timeSlots>landmarks(j,1)) == 1);
        m1 = (ticks(j,2) - lastCentroid(2))/(ticks(j,1) - lastCentroid(1));
        m2 = (newLocationy(pos) - lastCentroid(2))/(newLocationx(pos) - lastCentroid(1));
        angle = atan((m1-m2)/(1+(m1*m2)));
        
        location(pos:end,1) = newLocationx(pos:end)*cos(angle) - newLocationy(pos:end)*sin(angle);
        location(pos:end,2) = newLocationx(pos:end)*sin(angle) + newLocationy(pos:end)*cos(angle);
        lastCentroid = [ticks(j,2) ticks(j,3)];
        %     location(pos:end,1) = newLocationx(pos:end) + (ticks(j,2)-newLocationx(pos));
        %     location(pos:end,2) = newLocationy(pos:end) + (ticks(j,3)-newLocationy(pos));
    end
catch
    seeds = [];
end

newlocation = location;
%location = [newLocationx newLocationy];
lastCentroid = [0 0];
%Correct location with seed landmarks
while(i<size(mag,1))
    
    index = -1;
    if(i+250 <= size(mag,1))
        activity = getSeedLandmarks(acc(i:i+250,:),mag(i:i+250,:));
    else
        activity = getSeedLandmarks(acc(i:end,:),mag(i:end,:));
    end
    if(activity == 1)
        index = 0;
    else if(activity == 4)
            index = 1;
        else if(activity == 3)
                index = 2;
            end
        end
    end
    if(index ~= -1)
        xpos = location(i,1);
        ypos = location(i,2);
        min_dist = 5; min_i = -1;
        if(~isempty(seeds))
            types = seeds(:,4);
            landmarks = seeds(types == index,:);
            
            for j=1:size(landmarks,1)
                x = landmarks(j,2);
                y = landmarks(j,3);
                if(min_dist > sqrt((xpos-x)^2+(ypos-y)^2))
                    min_dist =  sqrt((xpos-x)^2+(ypos-y)^2);
                    min_i = j;
                end
            end
        end
        newlocation = location;
        if(min_i ~= -1)
            %correct location
            m1 = (landmarks(min_i,2) - lastCentroid(2))/(landmarks(min_i,1) - lastCentroid(1));
            m2 = (ypos - lastCentroid(2))/(xpos - lastCentroid(1));
            angle = atan((m1-m2)/(1+(m1*m2)));
            location(i:end,1) = newlocation(i:end,1)*cos(angle) - newlocation(i:end,2)*sin(angle);
            location(i:end,2) = newlocation(i:end,1)*sin(angle) + newlocation(i:end,2)*cos(angle);
            newlocation = location;
            %correctx = correctx + (landmarks(min_i,1)-xpos);
            %correcty = correcty + (landmarks(min_i,2)-ypos);
            disp('Seed detected at');
            disp(landmarks(min_i,1));
            disp(landmarks(min_i,2));
            disp(index);
        else
            %insert seed
            %	newseeds = [newseeds;[timeSlots(i) xpos ypos index]];
        end
    end
    %     if(i+49 <= size(mag,1))
    %         newlocation = [newlocation; [location(i:i+49,1) + correctx, location(i:i+49,2)+ correcty]];
    %     else
    %         newlocation = [newlocation; [location(i:end,1) + correctx, location(i:end,2)+ correcty]];
    %     end
    i = i + 50;
end
seeds = [seeds;newseeds];
save('stable/seeds','seeds');

end
