function [found] = detectElevator(accz)
    [pks loc] = findpeaks(accz,'MINPEAKHEIGHT',1.5);
    naccz = -1.*accz;
    [dips dloc] = findpeaks(naccz,'MINPEAKHEIGHT',1.5);
    j=1;
    found = 0;
    for i=1:length(loc)
        pk = loc(i);
        while (j <= length(dloc) && dloc(j) < pk) 
            j = j + 1;
        end
        if(dloc(j) - pk >= 200 && loc(i+1) > dloc(j))
            found = 1;
        end
    end
end