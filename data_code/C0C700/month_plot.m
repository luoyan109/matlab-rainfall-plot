
clear;clc;close all
station_id='C0C700';
station_name='中壢';
target_year='2021';
start_date_str=[target_year,'-01-01'];
end_date_str=[target_year,'-01-31'];
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
                if ~isempty(temp_data2)
                    Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=sum(temp_data2);
                else
                    Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;  
                end
            else
                Target_Weathers.OneDay.Data(i_datenumber-datenum(start_date_str)+1,3)=NaN;            
            end

        end
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
