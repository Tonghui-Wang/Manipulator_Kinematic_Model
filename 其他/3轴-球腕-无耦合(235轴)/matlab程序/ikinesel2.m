function[qsel] = ikinesel2(p,qlast)

error=Inf;

for flag=-1:2:1
    q=ikine2(p,flag);
    
    sum=0;
    for m=1:6
        sum=sum+abs(q(m)-qlast(m));%关节空间位移变化量
    end
    
    if sum<error%最小变化量选解
        error=sum;
        qsel=q;
    end
end
