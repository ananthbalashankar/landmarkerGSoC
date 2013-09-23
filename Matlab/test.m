conn = database('sample','postgres','ananth','org.postgresql.Driver','jdbc:postgresql:sample');
disp(conn);
query = sprintf('create extension pgcrypto;');
curs = exec(conn,query);
a = fetch(curs);


