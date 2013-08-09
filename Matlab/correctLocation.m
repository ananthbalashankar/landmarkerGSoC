function newPath  = correctLocation(oldPath, diff, lastLandmark, firstTime, timeSlots,centroid)
lastTime = lastLandmark{2};
lastCentroid = lastLandmark{1};
currentCluster = centroid + diff;
m1 = (currentCluster(2) - lastCentroid(2))/(currentCluster(1) - lastCentroid(1));
m2 = (centroid(2) - lastCentroid(2))/(centroid(1) - lastCentroid(1));
angle = atan((m1-m2)/(1+(m1*m2)));


xold = oldPath(:,1);
yold = oldPath(:,2);
prev(:,1) = xold(timeSlots < firstTime);
prev(:,2) = yold(timeSlots < firstTime);
a = timeSlots > lastTime;
b = timeSlots < firstTime;
c = a .* b;
currTime = timeSlots(c==1)';
if(firstTime ~= lastTime)
    next(:,1) = xold(timeSlots >= firstTime);
    next(:,2) = yold(timeSlots >= firstTime);
    %             nextPath(:,1) = next(:,1) + diff(1);
    %             nextPath(:,2) = next(:,2) + diff(2);
    %Rotate by angle
    nextPath(:,1) = next(:,1)*cos(angle) - next(:,2)*sin(angle);
    nextPath(:,2) = next(:,1)*sin(angle) + next(:,2)*cos(angle);
    
    currPath = interp1([lastTime;firstTime] , [lastCentroid;centroid], currTime);
    newPath = [prev;nextPath];
else
    next(:,1) = xold(timeSlots >= firstTime);
    next(:,2) = yold(timeSlots >= firstTime);
    %             nextPath(:,1) = next(:,1) + diff(1);
    %             nextPath(:,2) = next(:,2) + diff(2);
    %Rotate by angle
    nextPath(:,1) = next(:,1)*cos(angle) - next(:,2)*sin(angle);
    nextPath(:,2) = next(:,1)*sin(angle) + next(:,2)*cos(angle);
    newPath = [prev;nextPath];
end

end