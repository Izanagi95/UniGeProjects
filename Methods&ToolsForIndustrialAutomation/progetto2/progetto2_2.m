clear 
clc

%% parametri
sheet="Foglio1";
defects = xlsread("Exercise9.xlsx",sheet,"C2:C21");
size = xlsread("Exercise9.xlsx",sheet,"B2:B21");
label = xlsread("Exercise9.xlsx",sheet,"A2:A21");
label = num2str(label);
units=20;
figure(1);
[a, b]=controlchart(defects,'charttype','u','label',label,'unit',size);



u_= mean(defects./size);
upper_ = u_ + 3*sqrt(u_/units);
bottom_ = u_ - 3*sqrt(u_/units);


%% standard

u_oss = defects./size
z_=(u_oss-u_)./sqrt(u_./size)
z = mean(z_)
upper_z = z + 3*sqrt(z/units)
bottom_z = z - 3*sqrt(z/units)

var=z_.*size


%% standardized 

%{
sheet="Foglio2";
defects = xlsread("Exercise9.xlsx",sheet,"C2:C21");
size = xlsread("Exercise9.xlsx",sheet,"B2:B21");
label = xlsread("Exercise9.xlsx",sheet,"A2:A21");
label = num2str(label);
%}
figure(2);
[a, b]=controlchart(z_,'charttype','u','label',label,'unit',size);













