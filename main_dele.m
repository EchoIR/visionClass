clc;clear all;
folder='/home/echo/caffe-master/examples/visionClass/visibData/4/';  
files = dir([folder '*bmp']);
temp = randperm(length(files));
for i = 1:length(files)-1000
    delete([folder files(temp(i)).name]);
end