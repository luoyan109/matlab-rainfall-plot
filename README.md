# matlab-rainfall-plot
## Day rainfall:
### 2021/01/07 rainfall-data-plot:

code:

bug:

after debug:
```
clear;clc;close all
filename='20210107_C0C700.mat'; 
r_data=load(filename);
Target_Weathers=r_data.Weather; 
Target_Weathers.Data=strrep(Target_Weathers.Data,'T','0.0');
for i=1:24;
    data3(i)=str2num(Target_Weathers.Data{i,11});
end

figname=[filename(10:15),'測站']
figure('NumberTitle', 'off', 'Name',figname);
x=1:24;
bar(data3);
set(gca,'XTick',1:1:24);
title('時雨量資料',filename(1:8));
xlabel('時間 hr');	% x 軸的說明文字
ylabel('雨量 mm');	% y 軸的說明文字
```

result:
