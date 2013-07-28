function newlocation = correctSeed(location,timeSlots,mag,acc)
try
	seeds = load('stable/seeds');
	seeds = seeds.seeds;
catch
	seeds = [];
end
i=1;
newlocation = [];
newseeds = [];
correctx = 0;
correcty = 0;
while(i<size(mag,1))
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
	xpos = location(i,1);
	ypos = location(i,2);
	types = seeds(:,4);
	landmarks = seeds(types == index,:);
	min_dist = 5; min_i = -1;
	for j=1:size(landmarks,1)
		x = landmarks(j,2);
		y = landmarks(j,3);
		if(min_dist > sqrt((xpos-x)^2+(ypos-y)^2))
			min_dist =  sqrt((xpos-x)^2+(ypos-y)^2);
			min_i = j;
		end
	end
	if(min_i ~= -1)
		%correct location
		correctx = correctx + (landmarks(min_i,1)-xpos);
		correcty = correcty + (landmarks(min_i,2)-ypos);
	else
		%insert seed
		newseeds = [newseeds;[timeSlots(i) xpos ypos index]]; 
	end
	if(i+49 <= size(mag,1))
		newlocation = [newlocation; [location(i:i+49,1) + correctx, location(i:i+49,2)+ correcty]];
	else
		newlocation = [newlocation; [location(i:end,1) + correctx, location(i:end,2)+ correcty]];
	end	
	i = i + 50;
end
seeds = [seeds;newseeds];
save('stable/seeds',seeds);

end
