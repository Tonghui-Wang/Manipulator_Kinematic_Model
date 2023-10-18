clear;
clc;

q=[-10,-80,70,0,0,0];
p=sr_fkine(q);
disp('------------------------------------------');
for i=0:1
    for j=0:1
        for k=0:1
            config=[i,j,k];
            q=sr_ikine(config,p);
        end
    end
end
