function activity = getSeedLandmarks(acc, mag)
% 1: Elevator
% 2: Stationary
% 3: Escalator
% 4: Stairs
% 5: Walking
macc = [];
mmag = [];
for i=1:size(acc,1)
	macc(i) = sqrt(acc(i,1)^2 + acc(i,2)^2 + acc(i,3)^2);
end
for i=1:size(mag,1)
    mmag(i) = sqrt(mag(i,1)^2 + mag(i,2)^2 + mag(i,3)^2);
end
if(detectElevator(acc(:,3)))
    activity = 1;
else
    if(detectVariance(macc,1.5))
        R = corrcoef([acc(:,2)';acc(:,3)']);
        threshold = 0.5;
        if(R(1,2) > threshold)
            activity = 5;
        else
            activity = 4;
        end
    else
        if(detectVariance(mmag,5))
            activity = 3;
        else
            activity = 2;
        end
    end
end
end
