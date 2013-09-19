function comments = readComments()
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
for m=1:length(comments)
    comment = comments{m};
    landmarkid = comment{5};
    index = find(ids==landmarkid);
    comment{6} = [xrange(index) yrange(index)];
    comments{m} = comment;
    plot(comment{6}(1),comment{6}(2),'.');
    %annotation('textbox',[comment{6}(1)/x comment{6}(2)/y .1 .1], 'String' , comment{2});
end

for k=1:length(comments)
    text(comments{k}{6}(1)+0.1,comments{k}{6}(2)+0.1,num2str(k))
end

saveas(h,'stable/comments','png');

end