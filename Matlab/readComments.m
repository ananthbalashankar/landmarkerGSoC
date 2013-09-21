function commentInfo = readComments()
home = '/home/swadhin/Landmark/landmarkerGSoC/Matlab/';
d = load(strcat(home,'stable/cluster'));
stable = d.stable;
stableFeat = d.stableFeat;

c = load(strcat(home,'stable/comments'));
comments = c.comments;
ids =[];
xrange =[];
yrange = [];
for i=1:size(stableFeat,2)
    stableClusters = stable{i};
    for j=1:size(stableClusters,2)
        cluster = stableClusters{j};
        centroid = cluster{2};
        landmarkid = cluster{9};
        ids = [ids; landmarkid];
        xrange = [xrange; centroid(1)];
        yrange = [yrange; centroid(2)];
    end
end


h=figure( 'visible', 'off');
set(gcf,'Visible','off');
hold on;

%scalex =(xrange - min(xrange))./(max(xrange) - min(xrange));
%y = range(yrange);
%annotate with the latest location of the landmark it is ascribed to
landmarks = {}; ratings = [];
for m=1:length(comments)
    comment = comments{m};
    landmarkid = comment{5};
    index = find(ids==landmarkid);
    comment{6} = [xrange(index) yrange(index)];
    comments{m} = comment;
    try
        landmarks{index} = [ landmarks{index} ; {comment{2}}];
    catch ex
        landmarks{index} = [{comment{2}}];
    end
    ratings(index) = comment{1};
    plot(comment{6}(1),comment{6}(2),'o');
    %annotation('textbox',[comment{6}(1)/x comment{6}(2)/y .1 .1], 'String' , comment{2});
end

x1 = [min(xrange):(max(xrange)-min(xrange))/100:max(xrange)];
x2 = [min(yrange):(max(yrange)-min(yrange))/100:max(yrange)];
sum = zeros(length(x2),length(x1));

for k=1:length(landmarks)
    if(~isempty(landmarks{k}))
        text(xrange(k)+0.5,yrange(k)+0.5,landmarks{k})
        
        mu = [xrange(k) yrange(k)];
        Sigma = [1 0; 0 1];
        [X1,X2] = meshgrid(x1,x2);
        F = mvnpdf([X1(:) X2(:)],mu,Sigma);
        F = reshape(F,length(x2),length(x1));
        F = F.*(ratings(k)-2.5);
        sum = sum + F;
    end
end

figure('visible','off');
set(gcf,'Visible','off');
set(gcf,'color','w');
surf(x1,x2,sum);
view(2);
im = getframe(gcf);
im = imresize(im.cdata, [600 600]);

fid = fopen('img-id.txt','r+');
imgid = fscanf(fid,'%d');
imgid = imgid+2;
fseek(fid,0,-1);
fprintf(fid,'%d',imgid);
fclose(fid);
rFile = sprintf('stable/%d.png',imgid-1);
imwrite (im, rFile, 'png');

cFile = sprintf('stable/%d.png',imgid);
%imwrite (im, 'stable/ratings.png', 'png');
saveas(h,cFile,'png');

commentInfo = {comments cFile rFile};

close all;
end