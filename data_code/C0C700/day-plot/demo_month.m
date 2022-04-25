clear;clc;close all
station_id='C0C700';
station_name='中壢';
target_year='2021';
start_date_str=[target_year,'-01-07'];
end_date_str=[target_year,'-01-07'];

i_datenumber=datenum(start_date_str):datenum(end_date_str)
datenumber=datenum(start_date_str):datenum(end_date_str)
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


