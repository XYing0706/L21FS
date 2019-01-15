clear;
clc;
DataName={'usps';'madelon';'isolet5';'COIL20';'lung_discrete';'Isolet'};
%DataName={'warpPIE10P';'warpAR10P';'colon';};
%DataName={'colon';};
rate=20;
DataNum=size(DataName,1);
for i=1:DataNum
    datapath=['../../data/',DataName{i},'.mat'];
    if ~exist([num2str(rate),'Data'],'dir') 
        mkdir([num2str(rate),'Data']);
    end 
    savePath=[num2str(rate),'Data/Data_',DataName{i},'.mat'];
    load(datapath);
    B=[gnd fea];
    feaNum=rate;
    rdim=length(unique(gnd))-1;
    %data=instance( B,feaNum,rdim);
    Name = ['Data_',DataName{i}];
    eval([Name,'=instance5( B,feaNum,rdim);']);
    eval(['save(savePath,','''',Name,''');']);
    clearvars -except DataName rate DataNum;
    clc;
end

