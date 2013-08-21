function comments = readComments()

l = load('stable/cluster');
c = load('stable/comments');
comments = c.comments;
stable = l.stable;
stableFeat = l.stableFeat;
location = {};
for i=1:size(stableFeat,2)
    stableClusters = stable{i};
    for j=1:size(stableClusters,2)
        cluster = stableClusters{j};
        centroid = cluster{2};
        landmarkid = cluster{9};
        location{landmarkid} = centroid;
    end
end

h=figure( 'visible', 'off');
hold on;

%annotate with the latest location of the landmark it is ascribed to
for m=1:length(comments)
    comment = comments{m};
    landmarkid = comment{5};
    comment{6} = location{landmarkid{1}};
    comments{m} = comment;
    plot(comment{6}(1),comment{6}(2),'.');
    
end

for k=1:length(comments)
    text(comments{k}{6}(1)+0.1,comments{k}{6}(2)+0.1,num2str(k))
end

saveas(h,'stable/comments','png');

end