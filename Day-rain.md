# matlab-rainfall-plot
## Day rainfall:
### 2021/01/07 rainfall-data-plot:

code:

bug:

after debug:
```
clear;clc;close all
filename='20210107_C0C700.mat'; 
r_data=load(filename);      %將2021/01/07的data匯入
Target_Weathers=r_data.Weather; 
Target_Weathers.Data=strrep(Target_Weathers.Data,'T','0.0'); %將data表格中的"T"替換成0.0

for i=1:24;
    data3(i)=str2num(Target_Weathers.Data{i,11});   %將data表格中的文字轉為數值
end

figname=[filename(10:15),'測站']
figure('NumberTitle', 'off', 'Name',figname); %改變figure名稱
x=1:24;     %1~24小時
bar(data3);     bar=長條圖
set(gca,'XTick',1:1:24);    % x軸刻度1~24，間隔1
title('時雨量資料',filename(1:8));
xlabel('時間 hr');	% x 軸的說明文字
ylabel('雨量 mm');	% y 軸的說明文字
```

result:
<p><img src="https://raw.githubusercontent.com/luoyan109/matlab-rainfall-plot/main/plot%20image/2021-01-07.PNG" width=500px></p>
