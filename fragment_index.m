clear
clc

load('frag_500km.mat');
load('loss.mat');
load('1978_area.mat');

lat_t1=43;lat_t2=22.4;lon_t1=73.5;lon_t2=104.1;
reso=0.00034;

x=1;y=1;
frag=[];
Area=[];

stp=0.5;

site_0=csvread(['SlopeAve_',num2str(stp),'.csv'],1);

x=nan(206,306);
for isize=1:size(site_0,1) 
    
    xsite_m(1)=round((lat_t1-site_0(isize,1)-stp/2)/reso);    xsite_m(2)=round((site_0(isize,2)-lon_t1-stp/2)/reso);
    xsite_n(1)=round((lat_t1-site_0(isize,1)+stp/2)/reso);    xsite_n(2)=round((site_0(isize,2)-lon_t1+stp/2)/reso);
    xsite_m(xsite_m<0)=1;
    fra_win=marsh(xsite_m(1):xsite_n(1),xsite_m(2):xsite_n(2));
    fra_win(fra_win==1)=0; 
    [~,~,v]=find(fra_win); 
    area_f0=unique(v);
      area=length(find(fra_win~=0))*0.00516;
  area_f=[];
    for i=1:size(area_f0,1)
        area_f(i)=length(find(fra_win==area_f0(i)))*0.00516;
    end
    area_f=area_f';
   F=((sum(75.68*exp(-0.00516 *area_f))./size(area_f,1))./(area/500));
    
    loss_win=r(xsite_m(1):xsite_n(1),xsite_m(2):xsite_n(2));
    L=length(loss_win(loss_win~=1))*0.00156;

    site_0(isize,4)=F; 
    site_0(isize,3)=area; 
    
    site_0(isize,5)=L; 
    site_0(isize,6)=size(area_f,1); 
    
end


 
 
