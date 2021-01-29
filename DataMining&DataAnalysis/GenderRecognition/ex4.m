
clear
close all
clc
 
%%
D = load('face_x.txt');
X=reshape(D,90,60,[]);
Y = load('face_y.txt');

w=random('unid',10,[1,3600]);
b=random('unid',10);
err = 1;
i = 1;
iteration=0;
index=randperm(90,90);

while err > 0
    if (i > 45) 
        i = 1;
        err=1;
    end
    
    newX=reshape(X(index(i),:,:),60,[]);
    newX=newX';
    newX=reshape(newX,3600,[]);
    f = w*newX+b;
    if Y(index(i))*f <= 0 
        w = w + Y(index(i))*newX';
        b = b + Y(index(i));
        err = err+1;
    end
    i = i + 1;
    
    if(i==45)
        iteration=iteration+1;
        err=err-1;
    end
end

wrong=0;
   
 for i=45:90   
    newX=reshape(X(index(i),:,:),60,[]);
    newX=newX';
    newX=reshape(newX,3600,[]);
    f = w*newX+b;
    if Y(index(i))*f <= 0 
       wrong= wrong+1;
    end
 end

fprintf("fine programma dopo %d iterazioni\n",iteration);
disp(w);
fprintf("\nbest b=");
disp(b);
fprintf("\nbest err=%d\n",err);
w=reshape(w,60,60,[]);
%imagesc(abs(w));
fprintf("il numero di errori durante è stato %d/45 cioè %f in percentuale\n",wrong,wrong/45*100);
%colormap gray 



