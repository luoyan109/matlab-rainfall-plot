# matlab-rainfall-plot
# Month rainfall:
### 2021/01/01 - 2021/01/31  rainfall-month-plot
### code before debug :
```
clear;clc;close all
station_id='C0C700';
station_name='中壢';
target_year='2021';
start_date_str=[target_year,'-01-01'];
end_date_str=[target_year,'-01-31'];
index=0;

for i_datenumber=datenum(start_date_str):datenum(end_date_str)
        date_str=datestr(i_datenumber,'yyyymmdd');
        
        mat_file_name=[date_str,'_',station_id,'.mat'];
        if (exist(mat_file_name,'file')==2)
            index=index+1;
            Target_Weathers.Data(index,1)=i_datenumber;
            Target_Weathers.Data(index,2)=i_datenumber-1/24/60;
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

Target_Weathers.DataHeader={'DayNumber_From','DayNumber_To','日累積降水量(mm)'};

figname=[station_id,'測站']
figure('NumberTitle', 'off', 'Name',figname);
x=1:31;
bar(Target_Weathers.Data);
set(gca,'XTick',1:1:31);
xlabel('時間 day');	% x 軸的說明文字
ylabel('雨量 mm');	% y 軸的說明文字

```
### bug:
1.Reference to non-existent field 'Data'.<br>引用不存在的字段“數據”<br>
### solution:路徑問題，程式需與檔案放在同一路徑</p>
2.繪圖錯誤:只取到同一天的資料，重複繪製
<p align="left"><img src='https://raw.githubusercontent.com/luoyan109/matlab-rainfall-plot/main/plot%20image/error1.PNG' width="50%" height="50%"></p>

## solution:


