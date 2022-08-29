% This script is use to produce phase.dat for ph2dt, two outputs
% will automatic saved : phase.dat, catalog.dat
% phase.dat : input for ph2dt
% catalog.dat : event list
% Change the area of the study of interests at line 52
% W.Peng

fileinfo = dir('*.P*');
nn = 1;
for ii = 1 : size(fileinfo,1)
    m_lon = [];
    m_lat = [];
    m_lat_d = [];
    m_lat_s = [];
    m_lon_d = [];
    m_lon_s = [];
    m_m = [];
    m_depth = [];
    m_yyyy = [];
    m_mm = [];
    m_dd =[];
    m_hr =[];
    m_min = [];
    m_sec = [];

    fileID = fopen(fileinfo(ii).name,'rt');
    C = textscan(fileID,['%5s %2s %2s ' ...
        '%2s %2s %6s %2s %5s %3s %5s' ...
        '%6s %4s %2s %5s %3s %4s %4s %4s' ...
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

    if m_lon >= 121.4 & m_lon <= 121.5 & m_lat >= 23.7 & m_lat <= 24 & m_m >= 2

        fileID = fopen(fileinfo(ii).name);

        CC = textscan(fileID,['%5s %6s %4s %5s %3c %6.2f %5.2f ' ...
            ' %5c %6.2f %5.2f %5c %5s %5s %5s %5s %2s %6.1f %5.1f '],'headerlines',1, 'whitespace', '');

        fclose(fileID);

        s_name = string(CC{1,1});
        s_ed = str2double(CC{:,2});
        s_parti = seconds(minutes((str2num(CC{1,5})))) + (CC{:,6});
        s_pdti = abs(s_parti - m_times);
        s_pw = str2num(CC{:,8});
        s_pw = (4 - s_pw)/4;
        s_sarti = seconds(minutes((str2num(CC{1,5})))) + (CC{:,9});
        s_sw = str2num(CC{:,11});
        s_sdti = abs(s_sarti - m_times);
        s_sw = (4 - s_sw)/4;


        % only search station with epicentral distance <= 200
        
        p = CC{:,6}~=0;
        s_namep = s_name(p);
        s_pdtip = s_pdti(p);
        s_pwp = s_pw(p);
        p = CC{:,9}~=0;
        s_names = s_name(p);
        s_sdtis = s_sdti(p);
        s_sws = s_sw(p);

        clear stinfop stinfos

        for i = 1 : size(s_namep,1)
            stinfop(i,:) = convertCharsToStrings(sprintf('%-4s %.2f %.2f P',s_namep(i),s_pdtip(i),s_pwp(i)));
        end
        for i = 1 : size(s_names,1)
            stinfos(i,:) = convertCharsToStrings(sprintf('%-4s %.2f %.2f S',s_names(i),s_sdtis(i),s_sws(i)));
        end

        if exist('stinfop')~=0
            if exist('stinfos')~=0
                stinfo{nn,1} = [stinfop;stinfos];
            else
                stinfo{nn,1} = [stinfop];
            end
        end

        hder(nn,:) = convertCharsToStrings(sprintf('# %4d %2d %2d %2d %2d %5.2f %7.4f %8.4f %6.2f %5.2f %4.1f %4.1f %4.2f %d',...
            m_yyyy,m_mm,m_dd,m_hr,m_min,m_sec,m_lat,m_lon,m_depth,...
            m_m,m_en,m_eh,m_ev,nn));


        hder2(nn,:) = convertCharsToStrings(sprintf('%4d %2d %2d %2d %2d %5.2f %7.4f %8.4f %6.2f %.2f %4.1f %4.1f %4.2f %s',...
            m_yyyy,m_mm,m_dd,m_hr,m_min,m_sec,m_lat,m_lon,m_depth,...
            m_m,m_en,m_eh,m_ev,fileinfo(ii).name));

        nn = nn + 1;

    end
end

fid = fopen( 'phase.dat' , 'w+' ) ;
for i = 1 : size(hder,1)
    fprintf(fid ,'%s\n' ...
        , hder(i,:)) ;
    for j = 1 : size(stinfo{i,1},1)
    fprintf(fid ,'%s\n' ...
        ,stinfo{i,1}(j,:)) ;
    end
end
fclose( fid ); 


fid = fopen( 'catalog.dat' , 'w+' ) ;
for i = 1 : size(hder2,1)
    fprintf(fid ,'%s\n' ...
        , hder2(i,:)) ;
end
fclose( fid ); 

%clear all
