function activity = getSeedLandmarks(acc, mag)
% 1: Elevator
% 2: Stationary
% 3: Escalator
% 4: Stairs
% 5: Walking
if(detectElevator(acc))
    activity = 1;
else
    if(detectVariance(acc,1.5))
        R = corrcoef([acc(:,2)';acc(:,3)']);
        threshold = 0.5;
        if(R(1,2) > threshold)
            activity = 5;
        else
            activity = 4;
        end
    else
        if(detectVariance(mag,5))
            activity = 3;
        else
            activity = 2;
        end
    end
end
end