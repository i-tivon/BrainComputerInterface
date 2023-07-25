function [all_feats]=getWindowedFeats(raw_data, fs, window_length, window_overlap)
    %
    % getWindowedFeats_release.m
    %
    % Instructions: Write a function which processes data through the steps
    %               of filtering, feature calculation, creation of R matrix
    %               and returns features.
    %
    %               Points will be awarded for completing each step
    %               appropriately (note that if one of the functions you call
    %               within this script returns a bad output you won't be double
    %               penalized)
    %
    %               Note that you will need to run the filter_data and
    %               get_features functions within this script. We also 
    %               recommend applying the create_R_matrix function here
    %               too.
    %
    % Inputs:   raw_data:       The raw data for all patients
    %           fs:             The raw sampling frequency
    %           window_length:  The length of window
    %           window_overlap: The overlap in window
    %
    % Output:   all_feats:      All calculated features
    %
%% Your code here (3 points)
%raw_data = ltest1;
[~,nchannels] = size(raw_data);

% First, filter the raw data
clean_data = filter_data(raw_data);


%displacement 
d = window_length - window_overlap;

%number of windows
%NumWins = @(xLen, fs, winLen, winDisp) (xLen-winLen*fs+winDisp*fs)/(winDisp*fs);
NumWins = @(xLen, fs, winLen, winDisp) (xLen-winLen*fs+winDisp*fs)/(winDisp*fs);
%nw = NumWins(length(clean_data), fs,  window_length, d);
nw = floor(NumWins(length(clean_data), fs,  window_length, d));

% Then, loop through sliding windows
all_feats = zeros(nw, 7*nchannels);
for i = 0:nw-1
    ind = i*d*fs;
    % Within loop calculate feature for each segment (call get_features)
    all_feats(end-i, :) = get_features(clean_data(end-ind-window_length*fs+1:end-ind,:),fs);
end


    

% Finally, return feature matrix

end