clc;
clear all;
close all;
pname=uigetdir;
fname=dir(pname);
source = [];
for i=3:length(fname)
    source{i-2}=fullfile(pname,fname(i).name);
end

pname=uigetdir;
fname=dir(pname);
target = [];
for i=3:length(fname)
    target{i-2}=fullfile(pname,fname(i).name);
end

p = 16;
vs= [];
gs= [];
vt= [];
gt= [];
for j=1:length(source)
    [s fs]=audioread(source{j});
    s = (s-mean(s))/var(s);
    [u_s g_s e_s]=lpcfit(s, p, 200, 400);
    
    vs = [vs u_s'];
    gs = [gs g_s'];
end

for j=1:length(target)
    [t fs]=audioread(target{j});
    t = (t-mean(t))/var(t);
    [u_t g_t e_t]=lpcfit(t, p, 200, 400);
    
    vt = [vt u_t'];
    gt = [gt g_t'];
end
    
net_v=newrb(vs,vt,0.05,0.01);
net_g=newrb(gs,gt,0.05,0.01);

[x fs] = audioread('..\test\6haan.wav');
x = (x-mean(x))/var(x);
[x_l x_g x_e]=lpcfit(x, p, 200, 400);

lpc_op= sim(net_v, x_l');
g_op= sim(net_g, x_g');


z = lpcsynth(lpc_op', g_op', x_e, 200);
soundsc(z, fs);
