function const = detectVariance(acc,threshold)
    macc = [];
    for i=1:size(acc,1)
        macc(i) = (acc(i,1)^2 + acc(i,2)^2 + acc(i,3)^2)^0.5;
    end
    v = var(macc);
    if(v < threshold)
        const = 0;
    else
        const = 1;
    end
end