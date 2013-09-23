function annotateComments(file,conn,dataid)
  commentFile = strcat(file,'/Comments.txt')
  fid = fopen(commentFile,'r');
  comments = {};
  i=1;
  line = fgetl(fid);
  while ischar(line)
	[x] = strfind(line,';');
	a=x(1);b=x(2);
	t = line(1:a-1);
	r = line(a+1:b-1);
	com = line(b+1:end);
	comments{i,1} = str2num(t);
        comments{i,2} = str2num(r);
        comments{i,3} = com;
	line = fgetl(fid);
  	i = i + 1;
  end
  fclose(fid);
  %comments = textscan(fid,'%d64;%f;%s');
  %comments = importdata(commentFile,';',0);
  location = load(strcat(file,'/location'));
  xpos = location.xpos;
  ypos = location.ypos;
  timeSlots = location.timeSlots;
  %conn = database('test_db','root','ananth','Vendor','PostGreSQL');
  %conn = database('sample','postgres','ananth','org.postgresql.Driver','jdbc:postgresql:sample');
  comments 
  landmarks = load('stable/cluster');
  landmarks = landmarks.stable;
  stable = {};
  for i=1:length(landmarks)
    feat = landmarks(i);
    feat = feat{1};
    for j=1:length(feat)
        stable{end+1} = feat{j};
    end
  end
  vals = {};
  for i=1:size(comments,1)
      %get location from timestamp
      timestamp = comments{i,1};
      rating = comments{i,2};
      comment = comments{i,3};
      x = interp1(timeSlots,xpos,timestamp,'linear','extrap');
      y = interp1(timeSlots,ypos,timestamp,'linear','extrap');
      
      %make database query in landmarks table
	query1 = sprintf('Select id,min(POWER(centroidx+%f,2)+POWER(centroidy + %f,2)) as dist from landmark group by id order by dist asc',-1*x,-1*y);
	curs1 = exec(conn,query1);
 	curs1 = fetch(curs1);
	query1
	curs1.Data;
	d = curs1.Data(1,1);
	dist = curs1.Data(1,2);
    landmarkid = d{1};
%      minid = -1; dist = Inf;
%      for j=1:length(stable)
%         landmark = stable{j};
%         centroid = landmark(2);
%         centroid = centroid{1};
%          if(dist > ((centroid(1) -x)^2 + (centroid(2)-y)^2))
%              minid = landmark(9);
%              dist = (centroid(1) -x)^2 + (centroid(2)-y)^2;
%          end
%      end
%     landmarkid = minid;
     
     %make entry in comments table
     c = clock;
     vals{i} = {rating,comment,c,dataid,landmarkid};
%       cols = {'rating','comment','time','dataid','landmarkid'};
     %vals = {rating,comment,c,dataid,landmarkid};
%       fastinsert(conn,'comments',cols,vals);
     query = sprintf('Insert into comments(rating,comment,time,dataid,landmarkid) Values (%f,''%s'',NOW(),%d,%d)',rating,comment,dataid,landmarkid);
     exec(conn, query);
  end
  try
  comments = load('stable/comments');
  comments = comments.comments;
  comments = horzcat(comments,vals);
  catch
    comments = vals;
  end
  save('stable/comments','comments');
end
