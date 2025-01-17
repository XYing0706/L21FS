function [ Data ] = instance( B,feaNum,rdim )
%B:        the input data, including label+data
%feaNum:   selected features number
%rdmin:    the project matrix dimension
    %% if print out 
    output=1;
    
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
    accuIter = 0;
    cpu_time = 0;
    
    %% random the order
    a=11;
    rand('state',a);
    r=randperm(size(d,1));
    d=d(r,:);
    A=A(r,:); 
    
    %% get the best parameter with  40% data
%     mm=floor(0.4*size(d,1));
%     Result=hibiscus(d(1:mm,:),A(1:mm,:),feaNum,rdim);
    Result=hibiscus(d,A,feaNum,rdim);
    lambd = Result.Best_lambd;
    
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
        [ W ] = svc( dtrain,Ctrain,lambd,rdim);
        thistoc(i,1)=toc;
        [ Accuracy ] = svcerror( W,Ctrain,dtrain,Ctest,dtest,feaNum );
        tmpTestCorr(i,1)=Accuracy;
        
    end
    
    
    %% output
    testCorr = sum(tmpTestCorr)/k;
    cpu_time=sum(thistoc)/k;
    testcorrstd=std(tmpTestCorr,1);
    if output==1
        fprintf(1,'==============================================');
        fprintf(1,'\nTesting set correctness: %3.2f%',testCorr/100);
        fprintf(1,'\nAverage cpu_time: %10.4f',cpu_time);
        fprintf(1,'\nTest corrstd: %3.4f\n',testcorrstd);
    end
    
    Data.tmpTestCorr=tmpTestCorr;
    Data.thistoc=thistoc;
    Data.avg.testCorr=testCorr;
    Data.avg.cpu_time=cpu_time;
    Data.avg.testcorrstd=testcorrstd;
 

end

