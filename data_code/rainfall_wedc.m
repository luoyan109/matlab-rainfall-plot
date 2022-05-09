clear;clc;close all

station_id='C0C700';
station_name='中壢';
station_name_urlencode=urlencode(urlencode(station_name));
target_start_date_str='2021-12-01';
target_end_date_str='2021-12-31';
  
    disp('開始...') % disp:輸出
   
    for i_datenumber=datenum(target_start_date_str):datenum(target_end_date_str)
        target_date_str=datestr(i_datenumber,'yyyy-mm-dd');
       
        % 建立輸出資料夾
        output_folder=[station_id,'\',target_date_str(1:4),'\',target_start_date_str(6:7)];
        if exist(output_folder,'dir')~=7
            mkdir(output_folder)
        end
        % 準備輸出檔名
        output_mat_file_name=[output_folder,'\',strrep(target_date_str,'-',''),'_',station_id,'.mat'];
        %--
        Weather.StationID=station_id;
        Weather.StationName=station_name;
        Weather.Date=target_date_str;
        % 下載
        if (exist(output_mat_file_name,'file')==2)
            disp('檔案存在,skip!')
        else        
            disp(target_date_str)
            temp_char = webread(['http://e-service.cwb.gov.tw/HistoryDataQuery/DayDataController.do?command=viewMain&station=',station_id,'&stname=',station_name_urlencode,'&datepicker=',target_date_str,'&altitude=151m']);
           
           
            % 確認資料有幾小時，完整一天應該有24小時
            temp_str='</tr>';
            temp_index=strfind(temp_char,temp_str);
            hour_count=length(temp_index)-4;
           
            % 取出<tr class="second_tr"> ~ </tr>
           
            % 找開頭
            temp_str='<tr class="second_tr">';
            temp_start_index=strfind(temp_char,temp_str);
            % 去掉前面的
            temp_char=temp_char(temp_start_index(1):end);
            % 找結尾
            temp_str='</tr>';
            temp_end_index=strfind(temp_char,temp_str);
            temp_target_char=temp_char(1:temp_end_index(1)+length(temp_str)-1);
            % 去掉前面的
            temp_char=temp_char(temp_end_index(1)+length(temp_str):end);
          
            % 分析
            temp_th_start_index=strfind(temp_target_char,'<th');
            temp_th_end_index=strfind(temp_target_char,'</th>');
            if length(temp_th_start_index)==length(temp_th_end_index)
                temp_vertical_column_count=length(temp_th_start_index);
                %disp(['欄位數量=',num2str(temp_vertical_column_count)])
            else
                disp('錯誤!<th>與</th>數量不同!')
                temp_vertical_column_count=0;
                return
            end
          
            % 寫入資料標頭
            for i=1:temp_vertical_column_count
                %disp(temp_target_char(temp_th_start_index(i)+length('<tr>'):temp_th_end_index(i)-1))   
                temp_str=temp_target_char(temp_th_start_index(i):temp_th_end_index(i)-1);
                temp_str=strrep(temp_str,'<th>','');
                temp_str=strrep(temp_str,'<br>','');        
                Weather.DataHeader{1,i}=temp_str;
            end
           
            % 取出<tr class="third_tr"> ~ </tr>
            
            % 找開頭
            temp_str='<tr class="third_tr">';
            temp_start_index=strfind(temp_char,temp_str);
            % 去掉前面的
            temp_char=temp_char(temp_start_index(1):end);
            % 找結尾
            temp_str='</tr>';
            temp_end_index=strfind(temp_char,temp_str);
            temp_target_char=temp_char(1:temp_end_index(1)+length(temp_str)-1);
            % 去掉前面的
            temp_char=temp_char(temp_end_index(1)+length(temp_str):end);
            %--
            % 分析
            temp_th_start_index=strfind(temp_target_char,'<th>');
            temp_th_end_index=strfind(temp_target_char,'</th>');
            if length(temp_th_start_index)==length(temp_th_end_index)
                temp_vertical_column_count=length(temp_th_start_index);
                %disp(['欄位數量=',num2str(temp_vertical_column_count)])
            else
                disp('錯誤!<th>與</th>數量不同!')
                temp_vertical_column_count=0;
                return
            end
          
            % 寫入資料標頭
            for i=1:temp_vertical_column_count
                %disp(temp_target_char(temp_th_start_index(i)+length('<tr>'):temp_th_end_index(i)-1))   
                temp_str=temp_target_char(temp_th_start_index(i):temp_th_end_index(i)-1);
                temp_str=strrep(temp_str,'<th>','');
                temp_str=strrep(temp_str,'<br>','');        
                Weather.DataHeader2{1,i}=temp_str;
            end
         
            for i_loop=1:hour_count
               
                % 取出<tr class="second_tr"> ~ </tr>
               
                % 找開頭
                temp_str='<tr>';
                temp_start_index=strfind(temp_char,temp_str);
                % 去掉前面的
                temp_char=temp_char(temp_start_index(1):end);
                % 找結尾
                temp_str='</tr>';
                temp_end_index=strfind(temp_char,temp_str);
                temp_target_char=temp_char(1:temp_end_index(1)+length(temp_str)-1);
                % 去掉前面的
                temp_char=temp_char(temp_end_index(1)+length(temp_str):end);
              
                % 分析
                temp_th_start_index=strfind(temp_target_char,'<td');
                temp_th_end_index=strfind(temp_target_char,'</td>');
                if length(temp_th_start_index)==length(temp_th_end_index)
                    temp_vertical_column_count=length(temp_th_start_index);
                    %disp(['欄位數量=',num2str(temp_vertical_column_count)])
                else
                    disp('錯誤!<th>與</th>數量不同!')
                    temp_vertical_column_count=0;
                    return
                end
            
                % 寫入資料標頭
                for i=1:temp_vertical_column_count
                    %disp(temp_target_char(temp_th_start_index(i):temp_th_end_index(i)-1))   
                    temp_str=temp_target_char(temp_th_start_index(i):temp_th_end_index(i)-1);
                    temp_str=strrep(temp_str,'<td nowrap>','');
                    temp_str=strrep(temp_str,'<td>','');
                    temp_str=strrep(temp_str,'&nbsp;','');        
                    Weather.Data{i_loop,i}=temp_str;
                end
              
            end
                  
            % 存檔        
            save(output_mat_file_name,'Weather')
          
        end
    end
    disp('結束!')
