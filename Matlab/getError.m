function getError(foldername)
	landmarks = importdata(strcat(foldername,'/landMarks.txt'));
	seeds = load('stable/seeds');
	seeds = seeds.seeds;
	location = load(strcat(foldername,'/location'));
	location = [location.xpos location.ypos location.timeSlots'];
	err = [];
	for i=1:size(landmarks,1)
		x = interp1(location(:,3),location(:,1),landmarks(i));
		y = interp1(location(:,3),location(:,2),landmarks(i));
		err(i) = sqrt((seeds(i,2) -x)^2 + (seeds(i,3) - y)^2);
	end
	disp(err);
	disp(mean(err));
end
