function findmax(a , b , filepath)
fid = fopen(filepath, 'wt');
if a > b
    fprintf(fid,'%i' , a);
else
	fprintf(fid,'%i', b);	
end
fclose(fid);
quit force
end




