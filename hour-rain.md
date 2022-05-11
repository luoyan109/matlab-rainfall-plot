# matlab plot -- hourly rainfall<p>

繪製一天之內24小時，每小時各自累計之雨量，依水利所告示，0:01~01:00此區間之累計雨量，定義為1時之累計時雨量，並以此區間類推。
### * 2021/01/07 rainfall-data-plot

### code before debug :
```clear;clc;close all
filename='20210107_C0C700.mat'; 
r_data=load(filename);      % 將2021/01/07.mat匯入matlab
Target_Weathers=r_data.Weather; 
% 將變數設定成.Weather，因先前從網站上抓取資料時，將mat檔案名稱設定成.Weather，因此匯入後會發現檔案變成"Weather"

figname=[filename(10:15),'測站']
figure('NumberTitle', 'off', 'Name',figname); % 改變figure名稱
x=1:24;     %1~24小時
bar(Target_Weathers.Data(:,11));     % bar=長條圖
set(gca,'XTick',1:1:24);    % x軸刻度1~24，間隔1
title('時雨量資料',filename(1:8));
xlabel('時間 hr');	% x 軸的說明文字
ylabel('雨量 mm');	% y 軸的說明文字
```
### bug:<br>

### 1.Error using bar : Not enough input arguments.<br>
沒有足夠的輸入參數。<br>
### solution:
(1) 檔案匯入錯誤，需確認檔案(.mat)匯入後的名稱，例如匯入後，變成取.Weather檔中的Data表格繪製

```
filename='20210107_C0C700.mat'; 
r_data=load(filename);      % 將2021/01/07.mat匯入matlab
Target_Weathers=r_data.Weather; 
bar(Target_Weathers.Data(:,11)
```
<p><br><p>

(2) 表格中的'T'字無法繪製導致參數不足，因此需要將表格中的'T'替換為'0.0'
* 使用strrep()函數，strrep(被替換者所在資料,被替換者,替換者)

```
arget_Weathers.Data=strrep(Target_Weathers.Data,'T','0.0'); % 將data表格中的"T"替換成0.0
```
<p><br><p>
    
### 2.Error using bar : Input arguments must be numeric, datetime, duration or categorical.<br>
輸入參數必須是數字、日期時間、持續時間或分類。</p>
### solution: 因表格中的資料為"字串"，因此必須使用str2num()，將字串轉為"數值"
* str2num()  = 字串轉數值 ，2=to
* num2str()  = 數值轉字串

```
for i=1:24;
    data3(i)=str2num(Target_Weathers.Data{i,11});   % 將data表格中的文字轉為數值
end
```
--------
### after debug:
```
%--------------------------------------------------------------------------
%   Name:month_plot  
%   Author: 羅子妍
%   Version: v20220505a
%   Description: 繪製日雨量長條圖
%   Advisor:陳建志教授
%--------------------------------------------------------------------------

clear;clc;close all
filename='20210107_C0C700.mat'; 
r_data=load(filename);      % 將2021/01/07的data匯入
Target_Weathers=r_data.Weather; 
Target_Weathers.Data=strrep(Target_Weathers.Data,'T','0.0'); % 將data表格中的"T"替換成0.0

for i=1:24;
    data3(i)=str2num(Target_Weathers.Data{i,11});   % 將data表格中的文字轉為數值
end

figname=[filename(10:15),'測站']
figure('NumberTitle', 'off', 'Name',figname); % 改變figure名稱
x=1:24;     % 1~24小時
bar(data3);     % bar=長條圖
set(gca,'XTick',1:1:24);    % x軸刻度1~24，間隔1
title('時雨量資料',filename(1:8));
xlabel('時間 hr');	% x 軸的說明文字
ylabel('雨量 mm');	% y 軸的說明文字
```

### result:
<p><img src="https://raw.githubusercontent.com/luoyan109/matlab-rainfall-plot/main/plot%20image/2021-01-07.PNG" width=500px></p>
