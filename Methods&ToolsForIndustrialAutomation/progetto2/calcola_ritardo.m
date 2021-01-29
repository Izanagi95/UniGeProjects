clear
clc

%% parametri
alphabet=('A':'Z')';
sheet="sheet1";
start_value=5;
num_job = xlsread("progetto2.xlsx",sheet,"B1");
num_constraints = xlsread("progetto2.xlsx",sheet,"B2");

J=(1:num_job)';
p=xlsread("progetto2.xlsx",sheet,strcat("E2:",alphabet(start_value+num_job),"2"))';
d=xlsread("progetto2.xlsx",sheet,strcat("E3:",alphabet(start_value+num_job),"3"))';
w=xlsread("progetto2.xlsx",sheet,strcat("E4:",alphabet(start_value+num_job),"4"))';
constraints=xlsread("progetto2.xlsx",sheet,strcat("A5:B",num2str(start_value+num_constraints)));
job=xlsread("progetto2.xlsx",sheet,"E25:O25");

%% calcolo

ritardo_totale=0;
ritardo_totale_pesato=0;
processing_time_totale=0;
for stadio=job
    processing_time_totale = processing_time_totale+p(stadio);
    ritardo_totale = ritardo_totale + max(processing_time_totale - d(stadio),0);
    ritardo_totale_pesato = ritardo_totale_pesato + max(processing_time_totale - d(stadio),0)*w(stadio);
end


xlswrite("progetto2.xlsx",ritardo_totale,sheet,strcat("F26"));
xlswrite("progetto2.xlsx",ritardo_totale_pesato,sheet,strcat("J26"));