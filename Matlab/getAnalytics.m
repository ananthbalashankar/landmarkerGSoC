function getAnalytics(files)
conn = 0;
dataid = 0;

for i=1:length(files)
    stabilize(files,conn,dataid);
end
heatMap();
end