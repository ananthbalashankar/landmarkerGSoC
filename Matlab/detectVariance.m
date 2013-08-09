function const = detectVariance(acc,threshold)
    v = var(acc);
    if(v < threshold)
        const = 0;
    else
        const = 1;
    end
end