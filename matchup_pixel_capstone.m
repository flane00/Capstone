


%  The collocation was done by pulling geographical “near-neighbor” remote sensing observations to each glider observation. 
% Key step is operating the match-up independently on each day. 
% No spatial filter was applied because the remote sensing data is a continuous field, 
% matchups were only filtered out where NaNs occurred for remote sensing pixels (750 meter resolution), 
% indicating a cloud or flagged data. 


% the data file is not on the github at this time. 


%%
% cd /Users/frank/OneDrive/ODUstuff/Research2/workflow_rawgliderdata
clear all
close all
load('matchfood_deepoffset.mat') % the code above generates this workspace
%%
% requires alot of index (be calm, take notes, breathe deep)
%%%%%%%%%%%%%% clear uidx % this line will be needed at the end of the loop
%  usattime is the index of each unique day pulled from satelite

for k = 1:length(usattime) % day k is associated with a day in usattime
    loopprogressratio=k/length(usattime)
    tidx=find(timeidx==k); % find the glider profiles on matching day k
    %     tiidx=timeidx(tidx);
    uidx=find(sattime==usattime(k)); % find the sat swath on day k..
    %      t=sattime(uidx); % sat time
    % this loop concencates all sat swaths on day k in to one matrix
    for kk=1:length(uidx) % loop over all sat swaths on day k (recorded in uidx)
        if ocfile(uidx(kk),:)~=0
            lat = ncread(ocfile(uidx(kk),:), '/navigation_data/latitude'); %this the latitude
            lon = ncread(ocfile(uidx(kk),:), '/navigation_data/longitude'); %this is the longitude
            chl_OC1 = ncread(ocfile(uidx(kk),:), '/geophysical_data/chlor_a'); %this is the NASA chl product
            kd490 = ncread(ocfile(uidx(kk),:), '/geophysical_data/Kd_490'); %this is the kd 490 product!
        end
        % now replace any negative numbers with NaN
        f=find(chl_OC1==-32767);
        chl_OC1(f)=NaN;

        ff=find(chl_OC1==-32767);
        kd490(ff)=NaN;
        clear f ff

        slat(:,1:length(lat(1,:)),kk)=lat;
        slon(:,1:length(lat(1,:)),kk)=lon;
        schl(:,1:length(lat(1,:)),kk)=chl_OC1;
        skd(:,1:length(lat(1,:)),kk)=kd490;

        if kk == 1
            sslat=slat(:,:,kk);
            sslon=slon(:,:,kk);
            sschl=schl(:,:,kk);
            sskd=schl(:,:,kk);
        else
            sslat=cat(2,sslat,slat(:,:,kk));
            sslon=cat(2,sslon,slon(:,:,kk));
            sschl=cat(2,sschl,schl(:,:,kk));
            sskd=cat(2,sskd,skd(:,:,kk));
        end
        % clear slat schl slon
        clear bb ab chl_OC1 lon lat kd490
    end

    % FOR RUN SPEED>>>>>
    % filter to create subdata set of only spatial region of interest!!
    % this is larger for the glider gain correction, there for skip this
    % filter
    %     idx=find(sslat>=30 & sslat<=50);
    %     la=sslat(idx);
    %     lo=sslon(idx);
    %     ch=sschl(idx);
    %     clear idx
    %     idx=find(lo<=-70 & lo>=-85);
    %     lengthidx(k)=length(idx);
    %
    %     % final bounded
    %     lon=lo(idx);
    %     lat=la(idx);
    %     chl=ch(idx);
    %     clear idx

    % in this build do we even need this if can just streamline the outputs to
    % the next step...
    %     %  remove the spatial filter and replace with this for gain correction
    %     %  match up.
    %     lat=sslat;
    %     lon=sslon;
    %     chl=sschl;
    %     kd=sskd;


    % % % % %     THIS IS THE REMOVED NAN CHL filter....
    % %     % remove nans
    %     isn=~isnan(chl);
    %     lsat(:,1)=lon(isn);
    %     lsat(:,2)=lat(isn);
    %     chlo=chl(isn);
    %     kd_490=kd(isn);
    %     clear isn

    % %  rebuild structure of the output of the filter above...
    lsat(:,1)=reshape(sslon,length(sslon)*3200,1);
    lsat(:,2)=reshape(sslat,length(sslat)*3200,1);
    chlo=reshape(sschl,length(sschl)*3200,1);
    kd_490=reshape(sskd,length(sskd)*3200,1);


    % at this point the loop outputs a swath of spatial and oc data for day k

    % now find the sat positions nearest to each glider profile to do matchup
    lidx=knnsearch(lsat,Lg(tidx,:)); % this line might require spatial filter now..
    if ~isempty(lidx)
        lsatnn=lsat(lidx,:);
        chlnn=chlo(lidx);
        kdnn=kd_490(lidx);

        % record the distance(km) between glider profile at nearest neighbor
        % sat pixel
        distance=lsatnn-Lg(tidx,:);
        dkm(:,1)=abs(distance(:,1)*90); % convert lon to km
        dkm(:,2)=abs(distance(:,2)*110); % convert lat to km
        dhkm=sqrt(dkm(:,1).^2 + dkm(:,1).^2);

        % thershold the distance to less than 10 km
        sidx=find(dhkm<10);
        clear dkm dhkm distance
        ptsday(k) = length(sidx);

        % "if" below proceed to generating matched subsets.
        if ~isempty(sidx)
            % index glider for times associated with day k
            l_g=Lg(tidx,:); % glider space
            f=gfl(tidx,:); % glider fluoresecene
            z=gz(tidx,:); % glider depth
            ts=gtime(tidx); % glider time
            sec=gmnum(tidx); % glider mission
            % reindex above to meet <10 km threshold
            secc=sec(sidx);
            tss=ts(sidx);
            lg=l_g(sidx,:);
            fl=f(sidx,:);
            zz=z(sidx,:);
            % do the same threshold for the sat nn outputs and the day k
            % time of sat
            oc=chlnn(sidx);
            ls=lsatnn(sidx,:);
            kd4=kdnn(sidx);
            tt=ones(length(sidx),1).*usattime(k);
            % now establish the intial vector for the first day with
            % matches (this might change because first day may have no
            % matches)

            if k==1
                kdd=kd4;
                seec=secc;
                occ=oc;
                lss=ls;
                lgg=lg;
                fll=fl;
                zzz=zz;
                ttt=tt;
                tsss=tss;
                % now concatenate the orignial vector with following days
                % that have matches....
            else
                kdd=cat(1,kdd,kd4);
                seec=cat(1,seec,secc);
                ttt=vertcat(ttt,tt);
                tsss=cat(1,tsss,tss);
                occ=cat(1,occ,oc);
                lss=cat(1,lss,ls);
                lgg=cat(1,lgg,lg);
                fll=vertcat(fll,fl);
                zzz=vertcat(zzz,zz);
            end
        end
    end
    % end of if loop that generates concatenated array of each interest upto
    % day k

    clear kd4 secc oc ls lg fl zz  tt  tss
    clear sec ts l_g f z
    clear chl lat lon kd lsat chlo kd_490
    clear sslon sslat sschl sskd
    clear uidx idx tidx
    clear lsatnn chlnn kdnn tt
end
%% finalization section 
% re-clear all indexes 

clear kd4 secc oc ls lg fl zz  tt  tss
clear sec ts l_g f z
clear chl lat lon kd lsat chlo kd_490
clear sslon sslat sschl sskd
clear uidx idx tidx
clear lsatnn chlnn kdnn tt
% now remove the NaN for the OC output into all the outputs... and give
% neat output names.... 


%% this section is the output "goods" 
isn = ~isnan(occ);
oc=occ(isn);
fl=fll(isn,:);
z=zzz(isn,:);
ls=lss(isn,:);
lg=lgg(isn,:);
kd=kdd(isn);
tg=tsss(isn); 
t=ttt(isn);
sec=seec(isn);


% wait to clean up the output until its loaded into the next script... that
% way everything is retrievable... 

% 
% clear gfl glat glon gmnum gtime gz
% clear k date 
% clear fll kdd



% f_ll=fll';
% z_zz=zzz';

% see outputs before saving... 
% match=cat(2,tsss,ttt,lss,occ,lgg,seec,f_ll,zzz);
% save(['/Users/frank/Desktop/slopenew/match'],"match")


% move this to the end of the matchup_pixel.m once we know we dont need any
% of this for pipeline script to increase run speed... 
clear skd slat slon schl usattime
clear kdd lgg lss seec occ fll zzz tsss ttt isn
clear Lg  timeidx 
clear gfl glat glon gnum gz gtime gmnum 
clear loopprogressratio i k date kk lidx sidx
clear ocfile 
clear ngfl


% moved this to directory2mat.m if there are deep zeros showing up... 
% quick fix to if_loop_zero bug. 
% 
% zerobug=find(fl==0);
% fl(zerobug)=NaN;
% z(zerobug)=NaN;
% 
% clear zerobug

% deep zerobug check! very visible in the deep values
pcolor(fl)
shading flat
set(gca,'clim',[0 .1])

save("matchout_pixel.mat")
