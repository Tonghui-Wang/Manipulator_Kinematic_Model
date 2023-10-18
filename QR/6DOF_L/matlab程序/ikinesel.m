function[qsel] = ikinesel(p,qlast)

error=inf;

for i=-1:2:1
    for j=-1:2:1
        for k=-1:2:1
            flag=[i,j,k];%选解标志位
            q=ikine(p,flag);

            sum=0;
            for m=1:6
                sum=sum+abs(q(m)-qlast(m));%关节空间位移变化量
            end
        
            if sum<error%最小变化量选解
                error=sum;
                qsel=q;
            end
        end
    end
end
