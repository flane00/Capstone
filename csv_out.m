clear all
close all

load '/Users/frank/My Drive/ODUstuff/Research2/workflow_QAQC_unbinned/matchout_pixel.mat'

zbin = [0:10:1000]';

% depth bin fl values 
for i = 1:length(fl)
    for d = 1:length(zbin)
        zbin_index=find(z(i,:)<zbin(d)+5 & z(i,:)>zbin(d)-5);
        fl_zbinned(i,d)=nanmean(fl(i,zbin_index));
    end
end
clear zbin_index
fl_zbinned(find(isnan(fl_zbinned)==1))=0;
%% 
%  integrate down to 300 m
for i = 1:length(t)
fll=NaN(1,30);
fll=fl_zbinned(i,1:30)';
zz=zbin(1:30);
    for kk = 1:length(zz)-1  % start loop over the depth
        intt = ((fll(kk) + fll(kk+1))/2)*(zz(kk+1)-zz(kk));
        int_chll((kk),1) = intt;
        int_chllS_300(i,1) = nansum(int_chll);
        
    end
    clear fll zz 
    clear intt int_chll
end 

%  integrate down to 1000 m 
for i = 1:length(t)

fll=NaN(1,100);
fll=fl_zbinned(i,1:100)';
zz=zbin(1:100);

    for kk = 1:length(zz)-1  % start loop over the depth
        intt = ((fll(kk) + fll(kk+1))/2)*(zz(kk+1)-zz(kk));
        int_chll((kk),1) = intt;
        int_chllS_1000(i,1) = nansum(int_chll);
        
    end
    clear sall fll zz 
    clear intt int_chll
end 

%%
tvec=datevec(t);
lat=lg(:,2);
lon=lg(:,1);
year=tvec(:,1);
month=tvec(:,2);
monthday=tvec(:,3);
yearday=day(datetime(tvec),'dayofyear');

matchtable=table(int_chllS_1000,int_chllS_300,oc,kd,lat,lon,year,month,monthday,yearday);
writetable(matchtable,'/Users/frank/Documents/classes/env.datascience_clayton/capstone/matchtable.csv')


