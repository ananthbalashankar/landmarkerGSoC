function fileInfo = heatMap(files)
    stable = {};
    stableFeat = {};
    for i=1:length(files)
        [stable stableFeat] = stabilize(files{i},1,1,0,stable,stableFeat);
    end
    
    figure('visible','off');
    set(gcf,'Visible','off');
    set(gcf,'color','w');
    
    x = [];
    y = [];
    z=  [];
    for i=1:size(stableFeat,2)
        stableClusters = stable{i};
        for j=1:size(stableClusters,2)
            cluster = stableClusters{j};
            centroid = cluster{2};
            x(end+1) = centroid(1);
            y(end+1) = centroid(2);
            z(end+1) = cluster{8};
        end
    end
    x1 = [min(x):(max(x)-min(x))/100:max(x)];
    x2 = [min(y):(max(y)-min(y))/100:max(y)];
    sum = zeros(length(x2),length(x1));
    [X1,X2] = meshgrid(x1,x2);
    for i=1:length(x)
        mu = [x(i) y(i)];
        Sigma = [1 0; 0 1];
        F = mvnpdf([X1(:) X2(:)],mu,Sigma);
        F = reshape(F,length(x2),length(x1));
        F = F.*z(i);
        sum = sum + F;
    end    
    
    surf(x1,x2,sum);
    view(2);
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
    close all;
    
    minx = Inf;miny = Inf;
    maxx = -Inf;maxy = -Inf;
    for i=1:length(files)
        loc = load(strcat(files{i},'/newLocation'));
        minx = min(minx,min(loc.newLocation(:,1)));
        miny = min(miny,min(loc.newLocation(:,2)));
        maxx = max(maxx,max(loc.newLocation(:,1)));
        maxy = max(maxy,max(loc.newLocation(:,2)));
    end
    
     x1 = [minx:(maxx-minx)/100:maxx];
     x2 = [miny:(maxy-miny)/100:maxy];
    [X1,X2] = meshgrid(x1,x2);
    
    mov = zeros(length(x2),length(x1));
    for i=1:length(files)
        loc = load(strcat(files{i},'/newLocation'));
        for j=1:length(loc.newLocation)
            mu = [loc.newLocation(j,1) loc.newLocation(j,2)];
            F=mvnpdf([X1(:) X2(:)],mu);
            F = reshape(F,length(x2),length(x1));
            mov = mov + F;
        end
    end
    
    surf(x1,x2,mov);
    view(2);
    im = getframe(gcf);
    im = imresize(im.cdata, [600 600]);
    
    fid = fopen('img-id.txt','r+');
    imgid = fscanf(fid,'%d');
    imgid = imgid+1;
    fseek(fid,0,-1);
    fprintf(fid,'%d',imgid);
    fclose(fid);
    filename1 = sprintf('stable/%d.png',imgid);
    imwrite (im, filename1, 'png');
    
    fileInfo = {filename filename1};
    close all;
    
    %[X Y] = meshgrid(xq,yq);
    %V = interp2(x,y,z,X,Y,'linear');
    %heatmap(V,'ColorMap','redbluecmap','Symmetric',0.5);
end