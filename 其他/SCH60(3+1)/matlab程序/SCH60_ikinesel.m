function[qsel] = SCD20_ikinesel(p,qlast)

error=10000;

for i=-1:2:1
    for j=-1:2:1
        flag=[i,j];%选解标志位
        [q,ierror]=SCD20_ikine(p,flag);
        if ierror==true
            continue;
        end
        
        sum=0;
        for m=1:4
            sum=sum+abs(q(m)-qlast(m));%关节空间位移变化量
        end
        
        if sum<error%最小变化量选解
            error=sum;
            % config=flag;
            qsel=q;
        end
    end
end
