function heatMap()
    s = load('stable/cluster');
    stable = s.stable;
    stableFeat = s.stableFeat;
    h=dialog ( 'visible', 'off', 'windowstyle', 'normal' );
    ax=axes('parent', h, 'nextplot', 'add' );
    hold on;
    
    for i=1:size(stableFeat,2)
        stableClusters = stable{i};
        for j=1:size(stableClusters,2)
            cluster = stableClusters{j};
            centroid = cluster{2};
            plot(ax,centroid(1),centroid(2),'.','MarkerSize',10*cluster{8});
            saveas(ax,'stable/heatMap','png');
        end
    end
    
end