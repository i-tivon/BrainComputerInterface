function clean_data = filter_data(raw_eeg)
    %
    % filter_data_release.m
    %
    % Instructions: Write a filter function to clean underlying data.
    %               The filter type and parameters are up to you.
    %               Points will be awarded for reasonable filter type,
    %               parameters, and correct application. Please note there 
    %               are many acceptable answers, but make sure you aren't 
    %               throwing out crucial data or adversely distorting the 
    %               underlying data!
    %
    % Input:    raw_eeg (samples x channels)
    %
    % Output:   clean_data (samples x channels)
    % 
%% Your code here (2 points) 
%raw_eeg = final_trainecog_1;
[nsamples,nchannels] = size(raw_eeg);


% high pass filter 0.3hz
%hp = raw_eeg;
%     hp = highpass(raw_eeg, 0.3, 1000);
%     disp("highpass");
% d = designfilt('highpassiir', ...       % Response type
%        'StopbandFrequency',0.15, ...     % Frequency constraints
%        'PassbandFrequency',0.3, ...
%        'DesignMethod','ellip', ...     % Design method
%        'MatchExactly','stopband', ...   % Design method options
%        'SampleRate',1000);               % Sample rate
% hp = filtfilt(d, raw_eeg);
hp = raw_eeg;
%60hz notch filter for power line noise
    wo = 60/(1000/2);  
    bw = wo/35;
    [b,a] = iirnotch(wo,bw);
    ff = filtfilt(b,a,hp);
    disp("60 notch");
%common average reference
%should i align signals??


%     %average across all channels
%     ac = mean(ff,2);
%     %subtract ac from all channels
%     A = repmat(ac,1,nchannels);
%     ac = ac - A;
%     %reshape into trials
%     ac = reshape(ac, 4000,[]);
%     ac = mean(ac,2);
%     %subtract from all trials across all channels
%     A = repmat(ac,nsamples/4000,nchannels);
%     clean_data = ff - A;
% %     clean_data = ac;
%     disp("CAR");


%average across all channels
    ac = mean(ff,2);
    %subtract ac from all channels
    A = repmat(ac,1,nchannels);
    clean_data = ff - A;
    %reshape into trials
%     m = mod(length(raw_eeg),4000);
%     ac = reshape(ac(1:end - m,:), 4000,[]);
%     ac = mean(ac,2);
%     %subtract from all trials across all channels
%     A = repmat(ac,nsamples,nchannels);
%     clean_data = ff - A;
% %     clean_data = ac;
    
end