function [R]=create_R_matrix(features, N_wind)
    %
    % get_features_release.m
    %
    % Instructions: Write a function to calculate R matrix.             
    %
    % Input:    features:   (samples x (channels*features))
    %           N_wind:     Number of windows to use
    %
    % Output:   R:          (samples x (N_wind*channels*features))
    % 
%% Your code here (5 points)
    [M,CF] = size(features);
    %take the first N-1 rows
    n1rows = features(1:N_wind-1,:);
    
    %append flipped to beginning of feature matrix
    appFeat = [flip(n1rows);features];
    
    %create R matrix
    R = ones(M, CF*N_wind);
    
    for c = 0:N_wind-1
        R(:,1+(CF*c):CF*(c+1)) = appFeat(1+c:c+M,:);
        
    end
    
    %add col of ones
    o = ones(M, 1);
    
    R = [o, R];

end