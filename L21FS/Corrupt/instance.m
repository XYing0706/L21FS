function [ Accuracy ] = instance( B,feaNum,rdim )
%B:        the input data, including label+data
%feaNum:   selected features number
%rdim:    the project matrix dimension
   
    %% gui yi hua 
    A=B(1:end,2:end); % A is the input data
    Max=max(max(A));
    Min=min(min(A));
    A=2*(A-Min)./(Max-Min)-1; 
 
    d=B(1:end,1); % d is the labels
 
    
    %% random the order
    a=11;
    rand('state',a);
    r=randperm(size(d,1));
    d=d(r,:);
    A=A(r,:); 
    Result=hibiscus(d,A,feaNum,rdim);
    c = Result.Best_c;

   
    [ W ] = svc(d,A,c,rdim);
    
    normW=sum(W.^2,2).^(1/2);
    [~,index]= sort(normW,1,'DESCEND');
    select_index=index(1:feaNum,:);
    A = A(:,select_index);
    Accuracy = svmtrain(d,A,'-v 5 -q');
    
    
    
   

end
