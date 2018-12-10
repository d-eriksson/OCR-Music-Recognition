function [] = PlayMusic(Notething,BPM)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
freqs = [880.00;783.99;698.46;659.25;587.33;523.25;493.88;440.00;392.00;349.23;329.63;293.66;261.63;246.94;220.00;196.00;174.61;164.81;146.83;130.81;123.47;110.00;98.00;87.31;82.41;73.42;65.41;61.74;55.00;49.00];
amp=10; 
fs=20500;  % sampling frequency
Notething(Notething(:,3) == 0,:) = [];
Notething(:,3) = 1./Notething(:,3);
BeatDuration = 1/(BPM/60);
duration=sum(Notething)*BeatDuration;
values=0:1/fs:duration;
prev = 1;
a = zeros(size(values));
for i = 1:size(Notething,1)
    freq = freqs(Notething(i,1)+10);
    a(round(prev*fs):round((prev+Notething(i,3)*BeatDuration)*fs))=amp*sin(2*pi* freq*values(round(prev*fs):round((prev+Notething(i,3)*BeatDuration)*fs)));
    prev = prev+Notething(i,3)*BeatDuration;
end
sound(a,fs);
end

