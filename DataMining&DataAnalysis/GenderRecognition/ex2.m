
%clear
close all
clc
 
%%
D = load('face_x.txt');
X=reshape(D,90,60,[]);
Y = load('face_y.txt');

Xtest=zeros(45,3600);
Xlearn=zeros(45,3600);
Xtest=reshape(Xtest(:,:),45,60,[]);
Xlearn=reshape(Xlearn(:,:),45,60,[]);
Ylearn=zeros(45,1);
Ytest=zeros(45,1);
j=1;
k=1;

for i=1:90
    if i<=45 
        Xtest(j,:,:)=X(i,:,:);
        Ytest(k,1)=Y(i);
        j=j+1;
    else 
        Xlearn(k,:,:)=X(i,:,:);
        Ylearn(k,1)=Y(i);
        k=k+1;
    end
end

   Xlearn(:,:,:)=permute(Xlearn(:,:,:),[1 3 2]);
   Xtest(:,:,:)=permute(Xtest(:,:,:),[1 3 2]);
   Xlearn = reshape(Xlearn,[],3600,1);
   Xtest = reshape(Xtest,[],3600,1);

w=random('unid',10,[1,3600]);
b=random('unid',10);
err = inf;
i = 1;
iteration=0;

%learning phase
while err > 0
    
    if (i > 45) 
        i = 1;
        err=1;
    end
    
    f = w*Xlearn(i,:)'+b;
    if Ylearn(i,1)*f <= 0 
        w = w + Ylearn(i,1)*Xlearn(i,:);
        b = b + Ylearn(i,1);
        err = err+1;
    end
    
    i = i + 1;
    
    if(i==45)
       % fprintf("ok:%d \n",err);
        iteration=iteration+1;
        err=err-1;
    end
 
end

%testing phase
i=1;
wrong=0;
while i<=45
    
    f = w*Xtest(i,:)'+b;
    if Ytest(i,1)*f <= 0 
       wrong= wrong+1;
    end
    
    i = i + 1;
end


fprintf("fine programma dopo %d iterazioni\n",iteration);
%disp(w);
fprintf("\nbest b=%d\n",b);
%disp(b);
fprintf("\nbest err=%d\n",err);
%w=reshape(w,60,60,[]);
%imagesc(abs(w'));
%colormap gray 
fprintf("il numero di errori durante è stato %d/45 cioè %f in percentuale\n",wrong,wrong/45*100);



