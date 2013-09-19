function heatMap(files)
    stable = {};
    stableFeat = {};
    for i=1:size(files,1)
        [stable stableFeat] = stabilize(files{i},1,1,0,stable,stableFeat);
    end
    h=dialog ( 'visible', 'off', 'windowstyle', 'normal' );
    ax=axes('parent', h, 'nextplot', 'add' );
    hold on;
    set(gcf,'Visible','off');
    
    for i=1:size(stableFeat,2)
        stableClusters = stable{i};
        for j=1:size(stableClusters,2)
            cluster = stableClusters{j};
            centroid = cluster{2};
            scatter3(ax,centroid(1),centroid(2),cluster{8},'.');
            saveas(ax,'stable/heatMap','png');
        end
    end
    
end