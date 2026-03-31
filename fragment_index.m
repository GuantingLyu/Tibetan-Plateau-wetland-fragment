clear
clc

load('M:\WETLAND\data\mat\frag_500km.mat','m1');
% load('M:\WETLAND\data\mat\gain.mat');
% gain=r;
% clear r
load('M:\WETLAND\data\mat\loss.mat');
load('M:\WETLAND\data\mat\1978m_area.mat');

lat_t1=43;lat_t2=22.4;lon_t1=73.5;lon_t2=104.1;
reso=0.00034;

x=1;y=1;
frag=[];
Area=[];

stp=0.5;

site_0=csvread(['M:\WETLAND\data\csvwrite\fragdivide\SlopeAve_',num2str(stp),'.csv'],1);

x=nan(206,306);
for isize=1:size(site_0,1) % funcation of find return the xy have bug that will return a pattern, need to circulation
    
    xsite_m(1)=round((lat_t1-site_0(isize,1)-stp/2)/reso);    xsite_m(2)=round((site_0(isize,2)-lon_t1-stp/2)/reso);
    xsite_n(1)=round((lat_t1-site_0(isize,1)+stp/2)/reso);    xsite_n(2)=round((site_0(isize,2)-lon_t1+stp/2)/reso);
    xsite_m(xsite_m<0)=1;
    fra_win=marsh(xsite_m(1):xsite_n(1),xsite_m(2):xsite_n(2));
    fra_win(fra_win==1)=0; %等于1的值是补足的空白
    [~,~,v]=find(fra_win); %查找所有这个矩阵里的所有有值的点的值
    area_f0=unique(v);%去掉相同的
      area=length(find(fra_win~=0))*0.00516;%这个格子里的总面积
  area_f=[];
    for i=1:size(area_f0,1)
        area_f(i)=length(find(fra_win==area_f0(i)))*0.00516;%查找所有面积值相同的斑块面积，即在全局中属于统一斑块的斑块面积
    end
    % 这样做的思路是，假设在当前的格子中有5个斑块，但这5个斑块在全局中，本应该3个属于一个大板块，另外2个属于另一个大板块
    % 那么在当前格子里，本为一体的3个斑块算为一个斑块，而另外2个斑块，算为另一个斑块
    % 我特么简直是太机智了！！！！！！！！！！
    area_f=area_f';
   F=((sum(75.68*exp(-0.00516 *area_f))./size(area_f,1))./(area/500));
    
    loss_win=r(xsite_m(1):xsite_n(1),xsite_m(2):xsite_n(2));
    L=length(loss_win(loss_win~=1))*0.00156;%

    site_0(isize,62)=F; % geosite to coor
    site_0(isize,3)=area; % geosite to coor
    
    site_0(isize,64)=L; % geosite to coor
    site_0(isize,66)=size(area_f,1); % geosite to coor
    %     site_0(isize,65)=G; % geosite to coor
    
end
site_0(isnan(site_0(:,62)),:)=[];
site_0(:,62)=log10(site_0(:,62));
% csvwrite(['M:\WETLAND\data\csvwrite\SlopeAve_f0.csv'], site_0);frag=site_0(:,62);
site_0(site_0(:,64)==0,:)=[];
site_0(:,65)=site_0(:,64)./100;% site_0(:,65)=site_0(:,64)./site_0(:,3);

site_0(site_0(:,65)>=1,:)=[];


% site_0(site_0(:,62)==0,:)=[];
% site_0(:,62)=log10(site_0(:,62));
% site_0(site_0(:,62)>=log10(85),62)=log10(85);


% site_0(:,4)=log(site_0(:,4));
site_0(isinf(site_0(:,65)),:)=[];
scatter(site_0(:,62),log(site_0(:,65)))
% histogram(site_0(:,3),[0:500:7000])
% s=site_0;
% site_0(:,4)=site_0(:,4)./site_0(:,3);
% site_0(site_0(:,4)<0,4)=log10(-site_0(site_0(:,4)<0,4));
% site_0(site_0(:,4)>0,4)=log10(site_0(site_0(:,4)>0,4));

%  csvwrite(['M:\WETLAND\data\csvwrite\fragdivide\SlopeAve_l_0.1.csv'],site_0,1);
%  
%  
%  xxx=csvread(['M:\WETLAND\data\csvwrite\fragresult\l_SlopeAve.csv'],1);
%  for i=1:size(xxx,1)
%      index=find(site_0(:,1)==xxx(i,1)&site_0(:,2)==xxx(i,2));
%      xxx(i,62)=site_0(index,62);
%  end
%  xxx(:,62)=log10(xxx(:,62));
%  csvwrite(['M:\WETLAND\data\csvwrite\fragdivide\SlopeAve_l.csv'],xxx,1);
%  
 
 
 
