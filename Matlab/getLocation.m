function [xarr,yarr,timeaz,brng,dist] = getLocation(linacc,ori,gyro,mag,foldername)
height = 1.75;
time = linacc(:,1);
event = linacc(:,2);
accx = linacc(:,3);
accy = linacc(:,4);
accz = linacc(:,5);
hold all;

% figure(1);
% plot(time,accx, '-g',time,accy, '-b',time,accz, '-r

az = smooth(accz,20);
[pks loc] = findpeaks(az);

% figure(2);
% hold on
% plot(time,az);
% plot(time(loc),pks,'r');
%[cross,avgz,pos] = lcr(az,avgz);

timeaz = time(loc);
%disp(length(loc));
y = diff(timeaz);

z = (y < 0.2*10^9);
z = padarray(z,1,0,'post');
tmp = find(z==1) + 1;
y = [find(z==1) tmp];
timeaz(y)=[];

z=diff(timeaz)/10^9;
sum=0;k=1;j=1;
for i=1:length(z)
    sum = sum + z(i);
    if(sum > 2)
        sum = z(i);
        arr(j)=k;
        j = j + 1;
        k = 0;
    end
    k = k+1;
end
arr(j) = k;
j = 0;sum=0;
temp = [];
for i=1:length(timeaz)
    if(i>sum)
        j = j+1;
        sum = sum + arr(j);
        switch(arr(j))
            case 0
                stride = 0;
            case 1
                stride = height/5;
            case 2
                stride = height/4;
            case 3
                stride = height/4;
            case 4
                stride = height/3;
            case 5 
                stride = height/2;
            case 6
                stride = height/1.2;
            case 7
                stride = height;
            case 8
                stride = height;
            otherwise
                stride = height*1.2;
        end
    end
    temp(i) = stride;
end

ortime = ori(:,1);
ort = ori(:,3);
%plot(ori(:,1),ori(:,3));
%ort = angledim(ori(:,3),'degrees','radians');
j = 1;
k = 1;
l = 1;
linaccTime = linacc(:,1);
magTime = mag(:,1);
xarr(1) = 0;
yarr(1) = 0;
brng =[];
dist = [];
for i=1:length(timeaz)
    while j<length(ortime) && timeaz(i) > ortime(j)
        j = j + 1;
    end
    angle = ort(j);
    brng = [brng,angle];
    %Apply Pedometer algorithm only when in motion
    %Sample linacc and mag for the next 5 seconds
    while(timeaz(i) > linaccTime(k))
        if(k<length(linaccTime))
            k = k + 1;
        else
            break;
        end
    end
    kstart = k;
    if(k+10 > length(linaccTime))
        k = length(linaccTime);
    else
        k = k + 10;
    end
    linaccSample = linacc(kstart:k,[3 4 5]);
    
    while(timeaz(i) > magTime(l))
        if(l<length(magTime))
            l = l + 1;
        else
            break;
        end
    end
    lstart = l;
    if(l+10 > length(magTime))
        l = length(magTime);
    else
        l = l + 10;
    end
    
    magSample = mag(lstart:l,[3 4 5]);
    if(l - lstart < 2 || k - kstart < 2)  
       activity = 2; 
    else
       activity = getSeedLandmarks(linaccSample,magSample);
    end
    
%    if(activity ~= 2)
        xarr(i+1) = xarr(i) + temp(i)*cos(angle);
        yarr(i+1) = yarr(i) + temp(i)*sin(angle);
%    else
%         xarr(i+1) = xarr(i);
%         yarr(i+1) = yarr(i);
%     end
    dist = [dist,sqrt((xarr(i+1)-xarr(i))^2+(yarr(i+1)-yarr(i))^2)];
end
% figure(3);
% plot(xarr,yarr,'-');

gtime = gyro(:,1);
gz = gyro(:,5);
z = diff(ort);
x = diff(ortime);
x = x./10^9;
z = z./x;
z = padarray(z,1,0,'post');

GtimeInSec = (gtime - gtime(1))./10^9;
OtimeInSec = (ortime - ortime(1))./10^9;

for i=2:length(gtime)
    ang(i) = trapz(GtimeInSec(1:i),gz(1:i));
end

% figure(4);
% hold on
% plot(GtimeInSec,ang.*(180/pi),'r');
% plot(OtimeInSec,ort.*(180/pi),'b');

xavg=0;yavg=0;

%bias calculation taking difference of gyro and compass
%for i=1:length(gtime)
% for i=1:1
%     tmpx = cos(ang(i))-cos(ort(i));
%     tmpy = sin(ang(i))-sin(ort(i));
%     tmpangle = atan(tmpy/tmpx);
%     if((tmpy <= 0 && tmpx <=0 && tmpangle >= 0) || (tmpy >= 0 && tmpx <=0 && tmpangle <= 0))
%         tmpangle = pi + tmpangle;
%     end
%     xavg = xavg + cos(tmpangle);
%     yavg = yavg + sin(tmpangle);
% end
% bias = atan(yavg/xavg);
% if((yavg <= 0 && xavg <=0 && bias >= 0) || (yavg >= 0 && xavg <=0 && bias <= 0))
%     bias = pi + bias;
% end

bias = ang(1) - ort(1);
brng = brng + bias ;
%
for i=1:length(timeaz)
    xold = xarr(i+1);
    yold = yarr(i+1);
    xarr(i+1) = xold*cos(bias) - yold*sin(bias);
    yarr(i+1) = xold*sin(bias) + yold*cos(bias);
end

for i=1:length(timeaz)
    xarr(i) = -1*xarr(i);
    yarr(i) = -1*yarr(i);
end
% figure(1);
% hold on
% plot(xarr,yarr,'-');
% axis([-5 18 -20 5]);
h=dialog ( 'visible', 'off', 'windowstyle', 'normal' );
ax=axes('parent', h, 'nextplot', 'add' );
plot(ax,xarr,yarr,'-');
%saveas ( ax, strcat(foldername,'/','path'), 'png' )
close(h)
end

