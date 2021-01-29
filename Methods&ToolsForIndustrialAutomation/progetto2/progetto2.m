clear;
clc;

%% parametri
alphabet = ('A':'Z')';
sheet = "sheet1";
start_value = 5;
num_job = xlsread("progetto2.xlsx",sheet,"B1");
num_constraints = xlsread("progetto2.xlsx",sheet,"B2");

J = (1:num_job)';
p = xlsread("progetto2.xlsx",sheet,strcat("E2:",alphabet(start_value+num_job),"2"))';
d = xlsread("progetto2.xlsx",sheet,strcat("E3:",alphabet(start_value+num_job),"3"))';
w = xlsread("progetto2.xlsx",sheet,strcat("E4:",alphabet(start_value+num_job),"4"))';
constraints=xlsread("progetto2.xlsx",sheet,strcat("A5:B",num2str(start_value+num_constraints)));


X0=0;

%creazione dei vari stadi
for i = 1:num_job 
    X{i} = combnk(1:num_job,i);
end


%passo num_job;
stati(num_job) = size(X{num_job},1);
Go{num_job} = 0;
index{num_job} = 0;

%passo k=num_job-1...3,2,1;
for k = num_job-1:-1:1
    stati(k) = size(X{k},1); %numero di stati per stadio
    G{k} = 10000*ones(stati(k),stati(k+1));
    for i = 1:stati(k)
        start_time = durata(X{k}(i,:),p); % somma di processing time dello stato scelto
        for j = 1:stati(k+1)
            if ismember(X{k}(i,:),X{k+1}(j,:))  % se è subset
                if(respect_constraints(X{k}(i,:),X{k+1}(j,:),constraints))
                    controllo(i,j) = setdiff(X{k+1}(j,:),X{k}(i,:)); % elemento aggiuntivo nello stadio successivo
                    G{k}(i,j) = Go{k+1}(j)+w(controllo(i,j))*max((start_time+p(controllo(i,j))-d(controllo(i,j))),0);
                end
            end
        end
        [Go{k}(i),index{k+1}(i)] = min(G{k}(i,:));
    end
end
%passo 0;
for i = 1:length(J)
    G0(i) = Go{1}(i)+w(X{1}(i))*max((p(X{1}(i))-d(X{1}(i))), 0);
end

[Go0, index{1}] = min(G0);


%% passo forwarding
ordered_job(1) = X{1}(index{1});
ordered_index(1) = index{1};
for stadio = 2:num_job
     ordered_index(stadio) = index{stadio}(ordered_index(stadio-1));
     ordered_job(stadio) = setdiff(X{stadio}(ordered_index(stadio),:),ordered_job);
end


%% calcolo ritardo totale 
ritardo_totale = 0;
ritardo_totale_pesato = 0;
processing_time_totale = 0;
for stadio = ordered_job
    processing_time_totale = processing_time_totale+p(stadio);
    ritardo_totale = ritardo_totale + max(processing_time_totale - d(stadio),0);
    ritardo_totale_pesato = ritardo_totale_pesato + max(processing_time_totale - d(stadio),0)*w(stadio);
end

xlswrite("progetto2.xlsx",ordered_job,sheet,strcat("E27:",alphabet(start_value+num_job),"27"));
xlswrite("progetto2.xlsx",ritardo_totale,sheet,strcat("F28"));
xlswrite("progetto2.xlsx",ritardo_totale_pesato,sheet,strcat("J28"));

ordered_job
ritardo_totale
ritardo_totale_pesato
