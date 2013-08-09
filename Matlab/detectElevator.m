function [found] = detectElevator(accz)
    [pks loc] = findpeaks(accz);
    naccz = -1.*accz;
    [dips dloc] = findpeaks(naccz);
    j=1;
    found = 0;
    for i=1:length(loc)
        pk = loc(i);
        while (j <= length(dloc) && dloc(j) < pk) 
            j = j + 1;
        end
	if(j> length(dloc))
		break;
	end
        if(dloc(j) - pk >= 200 && loc(i+1) > dloc(j))
            found = 1;
        end
    end
end
