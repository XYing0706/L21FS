function [ accuracy ] = svcerror( FeaIndex,xtrain,ytrain,xtest,ytest )
%SVCERROR Summary of this function goes here
%   Detailed explanation goes here
    SelectFeaIdx = FeaIndex{1};
    xtrain = xtrain(:,SelectFeaIdx);
    xtest=xtest(:,SelectFeaIdx);
    
    %% libsvm cross validate
    model=libsvmtrain(ytrain,xtrain,'-q');
    [predicted,accuracyList,prob_estimates]= libsvmpredict(ytest,xtest,model,'-q'); 
    %err = sum(predicted~=ytest);
    accuracy = accuracyList(1,1);


end

