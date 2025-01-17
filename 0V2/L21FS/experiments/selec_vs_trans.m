%{
This file is to compare selection and tranformation

Features are selected in the range of {10,20,30,....}

%}

clear;
clc;
addpath("../");
DataName='Isolet';
rateList=10:10:300;
%rateList = 1:25;

datapath=['../../../data/',DataName,'.mat'];
load(datapath);

B=[gnd fea];
rdim=length(unique(gnd))-1;

%% gui yi hua 
A=B(1:end,2:end); % A is the input data
Max=max(max(A));
Min=min(min(A));
A=2*(A-Min)./(Max-Min)-1; 

%%
d=B(1:end,1); % d is the labels
trainCorr=0;
testCorr=0;
[sm sn]=size(A);
    
%% random the order
rand('state',1);
r=randperm(size(d,1));
d=d(r,:);
A=A(r,:);

%% get the best parameter with  40% data
%mm=floor(0.4*size(d,1));
%Result=hibiscus(d(1:mm,:),A(1:mm,:),feaNum,rdim);
Result=hibiscus(d,A,20,rdim);
c = Result.Best_c;

testCorrList=[];

for i=1:length(rateList)
    feaNum = rateList(1,i); 
    
    %% cross validation
    k=5;
    indx = [0:k];indx = floor(sm*indx/k);
    for i = 1:k
      
        Ctest = []; dtest = [];Ctrain = []; dtrain = [];
        Ctest  = A((indx(i)+1:indx(i+1)),:);
        dtest  = d(indx(i)+1:indx(i+1));
        Ctrain = A(1:indx(i),:);
        Ctrain = [Ctrain;A(indx(i+1)+1:sm,:)];
        dtrain = [d(1:indx(i));d(indx(i+1)+1:sm,:)];
        
        % compute and time
        tic
        [ W ] = svc(dtrain,Ctrain,c,rdim);
        thistoc(i,1)=toc;
        [ Accuracy ] = svcerror( W,Ctrain,dtrain,Ctest,dtest,feaNum );
        tmpTestCorr(i,1)=Accuracy;
        
    end
    testCorr = sum(tmpTestCorr)/k;
    testCorrList = [testCorrList testCorr]
    
    
end
testCorrList_selection = testCorrList
save('testCorrList_selection','testCorrList_selection')
rateList
