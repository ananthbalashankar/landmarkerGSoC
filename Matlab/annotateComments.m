function annotateComments(cluster,file,location,dataid)
  commentFile = strcat(file,'/Comments.txt');
  comments = importdata(commentFile,' ',0);
  xpos = location(:,1);
  ypos = location(:,2);
  timeSlots = location(:,3);
  conn = database('test_db','root','ananth','Vendor','PostGreSQL');
  for i=1:size(comments,1)
      %get location from timestamp
      timestamp = comments(i,1);
      rating = comments(i,2);
      comment = comments(i,3);
      x = interp1(timestamp,xpos,timeSlots,'linear','extrap');
      y = interp1(timestamp,ypos,timeSlots,'linear','extrap');
      
      %make database query in landmarks table
      curs = database.exec(conn, ['Select landmarksid from landmarks where (landmarks.centroidX - ' '''' x '''' ')^2 +(landmarks.centroidY - ' '''' y '''' ')^2 = (Select min((landmarks.centroidX - ' '''' x '''' ')^2 +(landmarks.centroidY - ' '''' y '''' ')^2) from landmarks)']);
      curs = fetch(curs);
      landmarkid = curs(1,1);
      
      %make entry in comments table
      database.exec(conn, ['Insert into comments(rating,comment,timestamp,dataid,landmarkid) VALUES (' '''' rating '''' ',' '''' comment '''' ',' '''' timestamp '''' ',' '''' dataid '''' ',' '''' landmarkid '''' ')']);
  end
end
