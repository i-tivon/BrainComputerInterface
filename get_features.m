function [features] = get_features(clean_data,fs)
    %
    % get_features_release.m
    %
    % Instructions: Write a function to calculate features.
    %               Please create 4 OR MORE different features for each channel.
    %               Some of these features can be of the same type (for example, 
    %               power in different frequency bands, etc) but you should
    %               have at least 2 different types of features as well
    %               (Such as frequency dependent, signal morphology, etc.)
    %               Feel free to use features you have seen before in this
    %               class, features that have been used in the literature
    %               for similar problems, or design your own!
    %
    % Input:    clean_data: (samples x channels)
    %           fs:         sampling frequency
    %
    % Output:   features:   (1 x (channels*features))
    % 
%% Your code here (8 points)
    [L,nchannels] = size(clean_data);
    features = zeros(nchannels, 7);
    for channel = 1: nchannels
%         % average frequency domain feature for specific bands
%         %Compute the Fourier transform of the signal. 
%         Y = fft(clean_data(:,channel));
%         %Compute the two-sided spectrum P2. Then compute the single-sided
%         %spectrum P1 based on P2 and the even-valued signal length L.
%         P2 = abs(Y/L);
%         P1 = P2(1:L/2+1);
%         P1(2:end-1) = 2*P1(2:end-1);
%         %if i want power instead of amplitude
%         %P1 = 10*log10(P1)
     
        %5-15hz
%         l = length(P1);
%         f = fs*(0:(L/2))/L;
%         fl = length(f);
%         m1 = mean(P1(f>= 5 & f<= 15));
        m1 = bandpower(clean_data(:,channel),1000,[5 15]);
        features(channel, 1) = m1;
        %20-25
        %m2 = mean(P1(f>= 20 & f<= 25));
        m2 = bandpower(clean_data(:,channel),1000,[20 25]);
        features(channel, 2) = m2;
        %75-115
        %m3 = mean(P1(f>= 75 & f<= 115));
        m3 = bandpower(clean_data(:,channel),1000,[75 115]);
        features(channel, 3) = m3;
        %125-160
        %m4 = mean(P1(f>= 125 & f<= 160));
        m4  = bandpower(clean_data(:,channel),1000,[125 160]);
        features(channel, 4) = m4;
        %160-175
        %m5 = mean(P1(f>= 160 & f<= 175));
        m5 = bandpower(clean_data(:,channel),1000,[160 175]);
        features(channel, 5) = m5;
        
        %average time domain voltage/ local motor potential
        features(channel, 6) = mean(clean_data(:,channel));
        
        %variance feature
        features(channel, 7) =var(clean_data(:,channel));
        
        
        
    end
    features = reshape(features',1,nchannels*7);
end

