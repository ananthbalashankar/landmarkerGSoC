function activity = detectCorner(ori,threshold)
    der = diff(ori(:,3));
    der = abs(der);
    if(max(der) >= threshold)    %corner detected, sudden change in orientation
        activity = 1;
    else
        activity = 0;
    end
end