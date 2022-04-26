# matlab-rainfall-plot
# Month rainfall:

### * demo code: just for oneday-sum 2021/01/07 

```
clear;clc;close all
station_id='C0C700';
station_name='中壢';
target_year='2021';
start_date_str=[target_year,'-01-07'];
end_date_str=[target_year,'-01-07'];

i_datenumber=datenum(start_date_str):datenum(end_date_str)
date_str=datestr(i_datenumber,'yyyymmdd');
mat_file_name=[date_str,'_',station_id,'.mat'];
temp_data=load(mat_file_name);
temp_data2=temp_data.Weather.Data(:,11);
temp_data2=strrep(temp_data2,'T','0.0');
temp_data2=str2double(temp_data2);
index=0

for i =1:24
    index=index+temp_data2(i,1)
end

figname=[station_id,'測站']
figure('NumberTitle', 'off', 'Name',figname);
bar(index)
title('日累積降水量')
xlabel('時間 day');	% x 軸的說明文字
ylabel('雨量 mm');	% y 軸的說明文字

```
### result:
<p align="left"><img src='https://raw.githubusercontent.com/luoyan109/matlab-rainfall-plot/main/plot%20image/one_day_sum.PNG' width="40%" height="40%"></p>

#### 補充: 以下程式碼可改寫成`s_num=sum(temp_data2)`
```
for i =1:24
    index=index+temp_data2(i,1)
end
```

-----------

## * 2021/01/01 - 2021/01/31  rainfall-month-plot
### code before debug :
```
clear;clc;close all
station_id='C0C700';
station_name='中壢';
target_year='2021';
start_date_str=[target_year,'-01-01'];
end_date_str=[target_year,'-01-31'];

Target_Weathers.StationID=station_id;
Target_Weathers.StationName=station_name;
Target_Weathers.DateFrom=start_date_str;
Target_Weathers.DateTo=end_date_str;
index=0;

for i_datenumber=datenum(start_date_str):datenum(end_date_str)
        date_str=datestr(i_datenumber,'yyyymmdd');
        
        mat_file_name=[date_str,'_',station_id,'.mat'];
        if (exist(mat_file_name,'file')==2)
            index=index+1;
            Target_Weathers.Data(index,1)=i_datenumber;
            temp_data=load(mat_file_name);
            
            % 雨量
            temp_data2=temp_data.Weather.Data(:,11);
            temp_data2=strrep(temp_data2,'T','0.0');
            temp_data2=str2double(temp_data2);
            % 如果24小時有8小時都NaN就當作整天NaN，如果8小時以下就拿有數值的算總和
            if (sum(isnan(temp_data2)) >= 8)
                Target_Weathers.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;
            elseif (length(temp_data2) == 24)
                temp_data2(isnan(temp_data2))=[];
                %disp(length(temp_data2))
                if ~isempty(temp_data2)
                    Target_Weathers.Data(i_datenumber-datenum(start_date_str)+1,3)=sum(temp_data2);
                else
                    Target_Weathers.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;  
                end
            else
                Target_Weathers.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;            
            end

        end
end


figname=[station_id,'測站']
figure('NumberTitle', 'off', 'Name',figname);
x=1:31;
bar(Target_Weathers.Data);
title('日累積降水量(mm)')
set(gca,'XTick',1:1:31);
xlabel('時間 day');	% x 軸的說明文字
ylabel('雨量 mm');	% y 軸的說明文字

```
### bug:
1.Reference to non-existent field 'Data'.<br>
引用不存在的字段“數據”<br>
### solution:路徑問題，程式需與檔案放在同一路徑</p>
2.繪圖錯誤:只取到同一天的資料、重複繪製
<p align="left"><img src='https://raw.githubusercontent.com/luoyan109/matlab-rainfall-plot/main/plot%20image/error1.PNG' width="50%" height="50%"></p>

### solution:
for 迴圈問題，目前正嘗試解決

### after debug:

```
clear;clc;close all
station_id='C0C700';
station_name='中壢';
target_year='2021';
start_date_str=[target_year,'-01-01'];
end_date_str=[target_year,'-01-31'];
    
Target_Weathers.StationID=station_id;
Target_Weathers.StationName=station_name;
Target_Weathers.DateFrom=start_date_str;
Target_Weathers.DateTo=end_date_str;
index=0;

Target_Weathers.OneDay.DataHeader={'DayNumber_From','DayNumber_To','日累積降水量(mm)'};

for i_datenumber=datenum(start_date_str):datenum(end_date_str)
        date_str=datestr(i_datenumber,'yyyymmdd');
        mat_file_name=[station_id,'\',target_year,'\',date_str(5:6),'\',date_str,'_',station_id,'.mat'];
        if (exist(mat_file_name,'file')==2)
            index=index+1;
            Target_Weather.OneDay.Data(index,1)=i_datenumber;
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
                %disp(length(temp_data2))
                if ~isempty(temp_data2)
                    Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=sum(temp_data2);
                else
                    Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;  
                end
            else
                Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;            
            end

        end
        

        temp_date_tick = datenum([
        ['2021-01-',date_str(5:6)]
        ],'yyyy-mm-dd');
end
        for j = 1:31
            B(j) = Target_Weathers.OneDay.Data(j,3);
        end

figname=[station_id,'測站'];
figure('NumberTitle', 'off', 'Name',figname);
x=1:31;
bar(x,B);
title('日累積降水量(mm)')
set(gca,'XTick',1:1:31);
xlabel('時間 (天)');	% x 軸的說明文字
ylabel('雨量 mm');	% y 軸的說明文字
```
