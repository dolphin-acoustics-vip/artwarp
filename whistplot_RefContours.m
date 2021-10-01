%%%%%This program graphs many whistles on one page
%%%%%Julie Oswald
%%%%%3/10/04

close all
clear all
loc='C:\ARTwarp\Data\20_per_enc\Sa\to_check\toplot';  %the folder that the whistles are in
x=1;

d=dir(loc);
s=size(d);
numfiles=s(1);
currentfile=3;

while (currentfile+3 <= numfiles)

    figure
    
for x=1:50;
    %whist=input('What is the name of the whistle file? ','s')
    locwhist=[loc,'\',d(currentfile).name];
    contour=load(locwhist);
    freq=contour(:,2);
    %time=contour(:,4);
    %subplot(6,5,x);
    %subplot(10,5,x);
    subplot(4,5,x);
    plot(freq,'-');
    %plot(time,freq,'-');
    %plot(time,freq,'-');
    axis([0 100 0 25000]);
    %axis([0 1.5 0 23000]);
    %set(d(currentfile),'interpreter',none)
    title(d(currentfile).name);
    currentfile=currentfile+1;
end   

end

%%%%%%%%%%%figure out how to set interpreter to none