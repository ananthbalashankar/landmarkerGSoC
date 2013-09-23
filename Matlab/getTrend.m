function filename = getTrend(files)
    home = '/home/swadhin/Landmark/landmarkerGSoC/Matlab/';
    seeds = load(strcat(home,'stable/seeds'));
    seeds = seeds.seeds;
    
    areas = [];
    k=0;
    for i=1:size(seeds,1)
        if(seeds(i,3) == 2)
            k = k+1;
            areas(k,:) = seeds(i,:);
        end
    end
    
    Areas ={};
    fid= fopen(strcat(home,'stable/Areas.txt'));
    for i=1:k
        Areas{i} = fgetl(fid);
    end
    
    percent = zeros(size(areas,1),1);
    for i=1:length(files)
        loc = load(strcat(files{i},'/newLocation'));
        class = knnclassify(loc.newLocation, areas(:,[1,2]), [1:k]);
        for j=1:k
            percent(j) = percent(j) + (sum(class==j)/length(class));
        end
    end
    percent = percent./length(files);
    pie(percent);
    colormap jet;
    legend(Areas{:},'Location','NorthEastOutside');
    
    im = getframe(gcf);
    im = imresize(im.cdata, [600 600]);
    
    fid = fopen('img-id.txt','r+');
    imgid = fscanf(fid,'%d');
    imgid = imgid+1;
    fseek(fid,0,-1);
    fprintf(fid,'%d',imgid);
    fclose(fid);
    filename = sprintf('stable/%d.png',imgid);
    imwrite (im, filename, 'png');
    
    %imwrite (im, 'stable/Trend.png', 'png');
    close all;
end