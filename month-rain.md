# matlab plot -- month rainfall
### * 2021 rainfall-data-plot
### * demo code : 

```
clear;clc;close all
station_id='C0C700';
station_name='中壢';
target_year='2021';
start_date_str=[target_year,'-01-01'];
end_date_str=[target_year,'-01-31'];
Target_Weathers.DateFrom=start_date_str;
Target_Weathers.DateTo=end_date_str;       

Target_Weathers.OneDay.DataHeader={'DayNumber_From','DayNumber_To','日累積降水量(mm)'};

for i_datenumber=datenum(start_date_str):datenum(end_date_str)
        date_str=datestr(i_datenumber,'yyyymmdd');
        mat_file_name=[station_id,'\',target_year,'\',date_str(5:6),'\',date_str,'_',station_id,'.mat'];
        temp_data=load(mat_file_name);
       
        % 雨量
        temp_data2=temp_data.Weather.Data(:,11);
        temp_data2=strrep(temp_data2,'T','0.0');
        temp_data2=str2double(temp_data2);
       
        % 如果24小時有8小時都NaN就當作整天NaN，如果8小時以下就拿有數值的算總和
        if (sum(isnan(temp_data2)) >= 8)
            Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;
        elseif (length(temp_data2) == 24)
                temp_data2(isnan(temp_data2))=[];
                if ~isempty(temp_data2)
                    Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=sum(temp_data2);
                else
                    Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;
                end
        else
            Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;
        end
        
        OneDay_rainfall_sum=Target_Weathers.OneDay.Data(:,3);

end

One_Month_sum=sum(OneDay_rainfall_sum) % 選定一個月份，將其中所有的"日雨量"加總，計算每月份的"月"雨量累計。

```

### * demo-month-plot:

```
clear;clc;close all
% 以月雨量為例製作雨量圖
% 整理好的月雨量資料:
Data=[
1,46
2,39.5
3,113.5
4,61.5
5,143
6,179
7,291
8,292.5
9,76
10,76
11,0
12,63
];
% 繪圖
figure
bar(Data(:,1),Data(:,2))
% 調整繪圖
title('2021每月累積降水量')
set(gca,'XLim',[0,13]);
set(gca,'XTick',1:12);
set(gca,'YLim',[0,300]);
xlabel('時間(月)');	% x 軸的說明文字
ylabel('降水量(mm)');	% y 軸的說明文字
% 存圖
saveas(gcf,'month.png','png');
```
### result:

<p align="left"><img src='https://raw.githubusercontent.com/luoyan109/matlab-rainfall-plot/main/plot%20image/month.png' width="75%" height="75%"></p>
