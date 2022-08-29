nn = 1;

fileinfo = dir('*.P*');

for ii = 1 : size(fileinfo,1)

fileID = fopen(fileinfo(ii).name,'rt');
 C = textscan(fileID,['%5s %2s %2s ' ...
     '%2s %2s %6s %2s %5s %3s %5s' ...
     '%6s %4s %2s %5s %3s %4s %4s %s' ...
     '%2s %3d %1s '],1,'whitespace','');
 fclose(fileID);

 m_yyyy = str2num(cell2mat(C{1,1}(1,1)));
 m_mm = str2num(cell2mat(C{1,2}(1,1)));
 m_dd = str2num(cell2mat(C{1,3}(1,1)));
 m_hr = str2num(cell2mat(C{1,4}(1,1)));
 m_min = str2num(cell2mat(C{1,5}(1,1)));
 m_sec = str2num(cell2mat(C{1,6}(1,1)));
 m_lat_d = str2num(cell2mat(C{1,7}(1,1)));
 m_lat_s = str2num(cell2mat(C{1,8}(1,1)))/60;
 m_lat = m_lat_d + m_lat_s;
 m_lon_d = str2num(cell2mat(C{1,9}(1,1)));
 m_lon_s = str2num(cell2mat(C{1,10}(1,1)))/60;
 m_lon = m_lon_d + m_lon_s;
 m_depth = str2num(cell2mat(C{1,11}(1,1)));
 m_m = str2num(cell2mat(C{1,12}(1,1)));
 m_ev = str2num(cell2mat(C{1,16}(1,1)));
 m_en = str2num(cell2mat(C{1,17}(1,1)));
 m_eh = str2num(cell2mat(C{1,18}(1,1)));


m_times = seconds(minutes(m_min)) + m_sec;

if ~isempty(m_m) &  m_lon_d <= 122.5 & m_lon_d >= 119.5 & m_lat_d >= 19.5 & m_lat_d <= 25.5

hder(nn,:) = sprintf('%4d %2d %2d %2d %2d %5.2f %7.4f %8.4f %6.2f %.2f %4.1f %4.1f %4.2f %s',...
    m_yyyy,m_mm,m_dd,m_hr,m_min,m_sec,m_lat,m_lon,m_depth,...
    m_m,m_eh,m_en,m_ev,fileinfo(ii).name);
nn = nn + 1;
end
end


for i = 1 : size(hder,1)
    hders(i,:) = convertCharsToStrings(hder(i,:));
end


fid = fopen( 'catalog.dat' , 'w+' ) ;
for i = 1 : size(hders,1)
    fprintf(fid ,'%s\n' ...
        , hders(i,:)) ;
end
fclose( fid ); 