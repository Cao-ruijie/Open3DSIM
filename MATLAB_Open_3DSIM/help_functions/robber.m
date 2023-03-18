function Wk22 = robber(Wk22_second)
[w,h,t] = size(Wk22_second);
sum_Wk2 = sum(sum(sum(Wk22_second)));
average_Wk2 = sum_Wk2/w/h/t+5;
Wk22 = Wk22_second;
for xx = 1:w
    for yy = 1:h
        for zz = 1:t
            if Wk22_second(xx,yy,zz)> average_Wk2
                Wk22(xx,yy,zz)=0;
            end
        end
    end
end
end