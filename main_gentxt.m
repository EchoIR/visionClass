clc;  clear all;  
%%下面生成顺序的trainval.txt和labels文件  
%先设置train占数据集的百分比，余下部分为val  
maindir='/home/echo/caffe-master/examples/visionClass/visibData/';  
wf = fopen('trainval.txt','w');  %没有的话会自动创建
lbf=fopen('labels.txt','w');  
train_percent=0.8;%val_percent=1-train_percent  
  
subdir = dir(maindir); %
ii=-1;  
numoffile=0;  
for i = 1:length(subdir)%第一层目录  
  if ~strcmp(subdir(i).name ,'.') && ~strcmp(subdir(i).name,'..')  
     ii=ii+1;  
     label = subdir(i).name;  
     fprintf(lbf,'%s\n',label);  
     label=strcat(label,'/');  
     subsubdir = dir(strcat(maindir,label));  
    for j=1:length(subsubdir)  
         if ~strcmp(subsubdir(j).name ,'.') && ~strcmp(subsubdir(j).name,'..')  
           fprintf(wf,'%s%s%s %d\n','visibData/',label,subsubdir(j).name,ii);  
           numoffile=numoffile+1; 
           fprintf('处理标签为%d的第%d张图片\n',ii,j-2);  
         end  
    end  
     
  end  
end  
fclose(wf);  
fclose(lbf);  
  
%%  
%下面将trainval的顺序打乱  
file=cell(1,numoffile);  
fin=fopen('trainval.txt','r');  %mine：fin相当于是一个文件内容的指针，可能是以enter为分界符的
i=1;  
while ~feof(fin)  
    tline=fgetl(fin);  
    file{i}=tline;  
    i=i+1;  
end  
fclose(fin);  
  
fprintf('\ntrainval.txt共%d行，开始打乱顺序....\n',numoffile);  
pause(1);  %pause(a)暂停a秒后执行下一条指令
rep=randperm(numoffile);  
fout=fopen('trainval.txt','w'); %表示可以覆盖写进去
for i=1:numoffile  
    fprintf(fout,'%s\n',file{rep(i)});  
end  
fprintf('生成的trainval.txt已打乱顺序.\n');  
fclose(fout);  
  
%%  
%下面根据打乱顺序的trainval.txt生成train.txt和val.txt  
fprintf('开始生成train.txt和val.txt...\n');  
pause(1);  
train_file=fopen('train.txt','w');  
text_file=fopen('val.txt','w');  
trainvalfile=fopen('trainval.txt','r');  
  
num_train=sort(randperm(numoffile,floor(numoffile*train_percent)));  %应该是从里面随机抽取
num_test=setdiff(1:numoffile,num_train);  %应该是里面除了
i=1;  
while ~feof(trainvalfile)  
    tline=fgetl(trainvalfile);  
    if ismember(i,num_train)  
        fprintf(train_file,'%s\n',tline);  
    else  
        fprintf(text_file,'%s\n',tline);  
    end  
    i=i+1;  
end  
fclose(train_file);  
fclose(text_file);  
fclose(trainvalfile);  
fprintf('共有图片%d张!\n',numoffile);  
fprintf('Done！\n');  