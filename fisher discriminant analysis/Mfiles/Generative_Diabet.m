%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Saber Hosseini Moghaddam                %
%       Date : 1392/8/24                        %
%       Classification of Pima indianes Dataset %
%       with Probabilistic Generative Models   %
%       Pattern Recognition Course              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc
clear
close all

load Diabet

Data_Diabet=Diabet(:,1:8);
Data_Target=Diabet(:,9);

Train_Data=Data_Diabet(1:154,:);
Train_Target=Data_Target(1:154,:);

Test_Data=Data_Diabet(155:768,:);
Test_Target=Data_Target(155:768,:);

Train_class_1=Train_Data(find(Train_Target==1),:);
Train_class_0=Train_Data(find(Train_Target==0),:);

Mu1=mean(Train_class_1);
Mu0=mean(Train_class_0);

R=cov(Train_Data);

W=inv(R)*(Mu0-Mu1)';

W0=-1/2*Mu0*inv(R)*Mu0'+1/2*Mu1*inv(R)*Mu1'+log(100/64);


for i=1:length(Test_Data)
P(i,:)=1/(1+exp(-(W'*Test_Data(i,:)'+W0)));
if P(i,:)>=0.5
    k(i,:)=0;
else
    k(i,:)=1;
end
end


d=0;
for n=1:length(Test_Data)
    if (k(n,:)~=Test_Target(n,:))
        d=d+1;
    end
end

A=length(find(k==1));
B=length(find(k==0));
figure
h=pie([A,B],[0,1]);
textObjs = findobj(h,'Type','text');
oldStr = get(textObjs,{'String'});
val = get(textObjs,{'Extent'});
oldExt = cat(1,val{:});
Names = {'Sick(Classifier): ';'Healthy(classifier):'};
newStr = strcat(Names,oldStr);
set(textObjs,{'String'},newStr)
set(h(1),'FaceColor','y')
set(h(3),'FaceColor','r')



A1=length(find(Test_Target==1));
B1=length(find(Test_Target==0));
figure
p=pie([A1,B1],[0,1]);

textObjs = findobj(p,'Type','text');
oldStr = get(textObjs,{'String'});
val = get(textObjs,{'Extent'});
oldExt = cat(1,val{:});
Names = {'Sick(Dataset): ';'Healthy(Dataset):'};
newStr = strcat(Names,oldStr);
set(textObjs,{'String'},newStr)
set(p(1),'FaceColor','y')
set(p(3),'FaceColor','r')

TP=0;
FN=0;
TN=0;
FP=0;

for h=1:614
    if k(h,:)==1 & Test_Target(h,:)==1
       TP=TP+1;
    end
    
    
    if k(h,:)==0 & Test_Target(h,:)==1
       FN=FN+1;
    end
    
    
    if k(h,:)==0 & Test_Target(h,:)==0
       TN=TN+1;
    end
    
    
    if k(h,:)==1 & Test_Target(h,:)==0
       FP=FP+1;
    end
     
end

Sensitivity=TP/(TP+FN);
Specificity=TN/(TN+FP);
Precision=TP/(TP+FP);
Accuracy=(TP+TN)/(TP+FN+FP+TN);
