# matlab plot -- year rainfall
### * 2011-2020 rainfall-data-plot
### * code : 

```
%--------------------------------------------------------------------------
%   Name:month_plot  
%   Author: 羅子妍
%   Version: v20220601a
%   Description: 繪製日雨量長條圖
%   Advisor:陳建志教授
%--------------------------------------------------------------------------

clear;clc;close all
station_id='C0C480';
station_name='桃園';
start_date=2011;
end_date=2020;
Target_Weathers.OneDay.DataHeader={'年累積降水量(mm)'};

for i_datenumber=start_date:end_date
    date_str=num2str(i_datenumber)
    mat_file_name=[station_id,'\','10_year_data','\',date_str,'_',station_id,'.mat'];
    temp_data=load(mat_file_name);
    
    % 雨量
    temp_data2=temp_data.Weather.Data(:,19);
    % T表示微量，設定為0
    temp_data2=strrep(temp_data2,'T','0.0');
    % 把文字轉為數值，如果無法轉換則為NaN
    temp_data2=str2double(temp_data2);
    % 如果12的月有10個月都NaN就當作整年NaN，如果10個月以下就拿有數值的算總和
    if (sum(isnan(temp_data2)) >= 10)
        Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date)+1,3)=NaN;
    elseif (length(temp_data2) == 12)
            temp_data2(isnan(temp_data2))=[];
            if ~isempty(temp_data2)
                Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date)+1,3)=sum(temp_data2);
            else
                Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date)+1,3)=NaN;
            end
    else
        Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date)+1,3)=NaN;
    end
    
    OneDay_rainfall=Target_Weathers.OneDay.Data(:,3)
 
end

Target_year=start_date:end_date
figname=[station_id,'測站'];
figure('NumberTitle', 'off', 'Name',figname);
bar(Target_year,OneDay_rainfall); % 長條圖繪製每年雨量
title([num2str(start_date),'-',num2str(end_date)],'年累積降水量(mm)')
set(gca,'XLim',[start_date-1,end_date+1]); % x軸的範圍
set(gca,'XTick',start_date:end_date); % x軸的刻度
xlabel('時間 (年)');	% x 軸的說明文字
ylabel('雨量 mm');	% y 軸的說明文字
saveas(gcf,[num2str(start_date),'_',num2str(end_date)],'png'); %儲存長條圖繪製結果為圖檔(.png)
```

### * result:

<p align="left"><img src='https://raw.githubusercontent.com/luoyan109/matlab-rainfall-plot/main/plot%20image/2011_2020.png' width="50%" height="50%"></p>

