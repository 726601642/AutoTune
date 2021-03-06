
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  AutoTune
%  Luks, Apr.12,2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Update:
%  Jul.27,2017��Add PitchDetectorAMDF Function.
%  Jul.26,2017��Add PitchScale and PitchDetector Function,using TIM-master.
%  Apr.13,2017��Supported real-time processing.
%  Apr.12,2017��Created PitchShift.
%  References:
%  [1] 'Using Multiple Processors for Real-Time Audio Effects',
%       Bogdanowicz, K. ; Belcher, R; AES - May 1989.
%
%  [2] 'A Detailed Analysis of a Time-Domain Formant-Corrected
%       Pitch-Shifting Algorithm', Bristow-Johnson, R. ; AES - October 1993.
%
%  [3]  Autocorrelation - http://note.sonots.com/SciSoftware/Pitch.html
%       Power Spectral Density - http://www.ualberta.ca/~mlipsett/ENGM541/Power_spectral_density_Matlab.pdf
%       TIM - https://github.com/stephenchiang/TIM
%       AutoTune Toy - https://ww2.mathworks.cn/matlabcentral/fileexchange/26337-autotune-toy
%  TODO:
%       1.harmonic smooth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;close all;clear;
global block_size step_size Fs;
%% WaveRead
FileName  = 'C:\Users\luks\Harmonic\2_SignalProcessingVS\AutoTune\C_AutoTune\audio\drank.wav';
[Sig,Fs] = audioread(FileName);
%% Initialize
Initialize;
%Info = audioinfo(FileName);
N = floor((length(Sig)-block_size)/step_size);
%% Real-Time Processing
I = 1;
out = [];
target_freq = [];
freq_tmp =zeros(N,1);
Ratio = 0;
print = [];
for n = 1:N
    BlockDate = Sig(I:I+block_size-1);
    %PitchDetector
    freq = PitchDetectorAMDF(BlockDate);
    %PitchScaler
    tune = 'E';
    scale = 'major'; 
    Ratio=PitchScale(freq, tune, scale);
    %PitchShifter
    CorrectedDate = PitchShift(Sig(I:I+step_size-1),Ratio);  
    I = I + step_size;
    out = [out;CorrectedDate];
end
%% WaveWrite
OutFileName = [FileName(1:end-4) '_' tune '_' scale '_lu_AMDF.wav'];
audiowrite(OutFileName,out,Fs);





