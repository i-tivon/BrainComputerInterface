%% Final project part 1
% Prepared by John Bernabei and Brittany Scheid

% One of the oldest paradigms of BCI research is motor planning: predicting
% the movement of a limb using recordings from an ensemble of cells involved
% in motor control (usually in primary motor cortex, often called M1).

% This final project involves predicting finger flexion using intracranial EEG (ECoG) in three human
% subjects. The data and problem framing come from the 4th BCI Competition. For the details of the
% problem, experimental protocol, data, and evaluation, please see the original 4th BCI Competition
% documentation (included as separate document). The remainder of the current document discusses
% other aspects of the project relevant to BE521.


%% Start the necessary ieeg.org sessions (0 points)

% username = 'itivon';
% passPath = 'iti_ieeglogin.bin';
% 
% % Load training ecog from each of three patients
% s1_train_ecog = IEEGSession('I521_Sub1_Training_ecog', username, passPath);
% 
% % Load training dataglove finger flexion values for each of three patients
% s1_train_dg = IEEGSession('I521_Sub1_Training_dg', username, passPath);

load('final_proj_part1_data.mat')
load('trainfeatsall.mat')
load('testfeatsall.mat')
load('lassomodel.mat')


%% Extract dataglove and ECoG data 
% Dataglove should be (samples x 5) array 
% ECoG should be (samples x channels) array

% Split data into a train and test set (use at least 50% for training)
%split 80/20
%training set of all 3 subjects
train_dg_mat = cell2mat(train_dg);
traindg_All = train_dg_mat(1:240000,:);
traindg_1 = train_dg_mat(1:240000,1:5);
traindg_2 = train_dg_mat(1:240000,6:10);
traindg_3 = train_dg_mat(1:240000,11:15);
testdg_All = train_dg_mat(240001:end,:);
testdg_1 = train_dg_mat(240001:end,1:5);
testdg_2 = train_dg_mat(240001:end,6:10);
testdg_3 = train_dg_mat(240001:end,11:15);


%channels per subject: 61, 46, 64
trainecog_1 = train_ecog{1}(1:240000,:);
trainecog_2 = train_ecog{2}(1:240000,:);
trainecog_3 = train_ecog{3}(1:240000,:);
testecog_1 = train_ecog{1}(240001:end,:);
testecog_2 = train_ecog{2}(240001:end,:);
testecog_3 =train_ecog{3}(240001:end,:);
%% Get Features
% run getWindowedFeats function
%
window_length = 80e-3;
window_overlap = 40e-3;
fs = 1000;
%train features for each subject

%% features loaded above, uncomment to run again
[train_feats1]=getWindowedFeats(trainecog_1, fs, window_length, window_overlap);

[train_feats2]=getWindowedFeats(trainecog_2, fs, window_length, window_overlap);

[train_feats3]=getWindowedFeats(trainecog_3, fs, window_length, window_overlap);

%test features for each subject
[test_feats1]=getWindowedFeats(testecog_1, fs, window_length, window_overlap);

[test_feats2]=getWindowedFeats(testecog_2, fs, window_length, window_overlap);

[test_feats3]=getWindowedFeats(testecog_3, fs, window_length, window_overlap);



%% Create R matrix
% run create_R_matrix
%for training
N_wind = 4;
[R1]=create_R_matrix(train_feats1, N_wind);
[R2]=create_R_matrix(train_feats2, N_wind);
[R3]=create_R_matrix(train_feats3, N_wind);

%for testing
[R1t]=create_R_matrix(test_feats1, N_wind);
[R2t]=create_R_matrix(test_feats2, N_wind);
[R3t]=create_R_matrix(test_feats3, N_wind);

%% Train classifiers (8 points)


% Classifier 1: Get angle predictions using optimal linear decoding. That is, 
% calculate the linear filter (i.e. the weights matrix) as defined by 
% Equation 1 for all 5 finger angles.

%either downsample dataglove or upsample R matrix
downsampdg1 = downsample(traindg_1,40);
downsampdg2 = downsample(traindg_2,40);
downsampdg3 = downsample(traindg_3,40);
downsampdg1t = downsample(testdg_1,40);
downsampdg2t = downsample(testdg_2,40);
downsampdg3t = downsample(testdg_3,40);

Y1 = downsampdg1(2:end,:);
Y2 = downsampdg2(2:end,:);
Y3 = downsampdg3(2:end,:);
Y1t = downsampdg1t(2:end,:);
Y2t = downsampdg2t(2:end,:);
Y3t = downsampdg3t(2:end,:);
%f1 becomes 1285 x 5
f1 = mldivide((R1'*R1),(R1'*Y1));
f2 = mldivide((R2'*R2),(R2'*Y2));
f3 = mldivide((R3'*R3),(R3'*Y3));
%predictions are 5999 x 5


%% correlations for all features with optimal linear decoding
actual1 = Y1t;
pred1 = R1t*f1;
c1 = diag(corr(actual1,pred1));

actual2 = Y2t;
pred2 = R2t*f2;
c2 = diag(corr(actual2,pred2));

actual3 = Y3t;
pred3 = R3t*f3;
c3 = diag(corr(actual3,pred3));





%% Try a form of either feature or prediction post-processing to try and
% improve underlying data or predictions.
%used lassoRemoveFeat to remove features for each finger for each subject
%uncomment line below to run lasso again but everything was loaded above
%[B11, B12, B13, B15, B21, B22, B23, B25, B31, B32, B33, B35, FitInfo11,FitInfo12,FitInfo13,FitInfo15,FitInfo21,FitInfo22,FitInfo23,FitInfo25,FitInfo31,FitInfo32,FitInfo33,FitInfo35, c1lasso, c2lasso, c3lasso] = lassoRemoveFeat(R1, R1t, R2, R2t, R3, R3t, Y1, Y2, Y3);

%now using these reduced features to try other regression models. I didn't
%think classification models like knn would be useful (I still tried knn,
%and it gave extremely low correlations).

%%
% Try at least 1 other type of machine learning algorithm, you may choose
% to loop through the fingers and train a separate classifier for angles 
% corresponding to each finger

%[c1glm, c2glm, c3glm,Ylog1, Ylog2, Ylog3] = glm_model(B11, B12, B13, B15, B21, B22, B23, B25, B31, B32, B33, B35, FitInfo11,FitInfo12,FitInfo13,FitInfo15,FitInfo21,FitInfo22,FitInfo23,FitInfo25,FitInfo31,FitInfo32,FitInfo33,FitInfo35, R1, R1t, R2, R2t, R3, R3t, Y1, Y2, Y3, actual1, actual2, actual3);
%[c1glm, c2glm, c3glm,Ylog1, Ylog2, Ylog3] = glm_model_B(R1, R1t, R2, R2t, R3, R3t, Y1, Y2, Y3, actual1, actual2, actual3);

%% Correlate data to get test accuracy and make figures (2 point)

% Calculate accuracy by correlating predicted and actual angles for each
% finger separately. Hint: You will want to use zohinterp to ensure both 
% vectors are the same length.

disp("correlation for each subject with all features and optimal linear decoding");
c1
c2
c3

disp("correlation for each subject after removing features with lasso and optimal linear decoding");
c1lasso
c2lasso
c3lasso

disp("correlation for each subject after removing features with lasso and using generalized linear model with distr 'normal' and link 'log' (logistic regression)");
c1glm
c2glm
c3glm


figure()
hold on;
for i = 1:5
    plot(actual1(:,i), Ylog1(:,i));
end
title('Actual Angles vs Predictions for Subject 1');
xlabel('Actual Angles');
ylabel('Predicted Angles')
legend('finger1', 'finger2', 'f3', 'f4', 'f5');

figure()
hold on;
for i = 1:5
    plot(actual2(:,i), Ylog2(:,i));
end
title('Actual Angles vs Predictions for Subject 2');
xlabel('Actual Angles');
ylabel('Predicted Angles')
legend('finger1', 'finger2', 'f3', 'f4', 'f5');

figure()
hold on;
for i = 1:5
    plot(actual3(:,i), Ylog3(:,i));
end
title('Actual Angles vs Predictions for Subject 3');
xlabel('Actual Angles');
ylabel('Predicted Angles')
legend('finger1', 'finger2', 'f3', 'f4', 'f5');
