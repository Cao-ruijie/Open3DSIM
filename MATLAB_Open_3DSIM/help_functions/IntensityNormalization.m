function Snoisy = IntensityNormalization(Snoisy,num)
% 归一化
mean = zeros(1,num);
standard = zeros(1,num);
for jnum = 1:num
    s = Snoisy(:,:,jnum);
    mean(1,jnum) = mean2(s);% 均值
    standard(1,jnum) = std(s(:));% 标准差
end
m_max = max(mean);
s_max = max(standard);
for jnum = 1:num
    Snoisy(:,:,jnum)=(Snoisy(:,:,jnum)-mean(jnum)).*(s_max/standard(1,jnum))+m_max;
end

end