
%clear
close all
clc
 
%%
D = load('face_x.txt');
X=reshape(D,90,60,[]);
Y = load('face_y.txt');

%{
newX=X(10,:,:);
newX=reshape(newX,60,[]);
newX=newX';
imagesc(newX);
colormap gray 
%}


w=random('unid',10,[1,3600]);
b=random('unid',10);
err = inf;
i = 1;
iteration=0;

while err > 0
    if (i > 90) 
        i = 1;
        err=1;
    end
    
    newX=reshape(X(i,:,:),60,[]);
    newX=newX';
    newX=reshape(newX,3600,[]);
    f = w*newX+b;
    if Y(i)*f <= 0 
        w = w + Y(i)*newX';
        b = b + Y(i);
        err = err+1;
    end
    
    i = i + 1;
    
    if(i==90)
        iteration=iteration+1;
        err=err-1;
    end
    
    
end


fprintf("fine programma dopo %d iterazioni\n",iteration);
disp(w);
fprintf("\nbest b=");
disp(b);
fprintf("\nbest err=%d\n",err);
w=reshape(w,60,60,[]);
imagesc(abs(w));
colormap gray 



