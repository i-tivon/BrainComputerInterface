%load data
load('final_proj_part1_data.mat');
load('leaderboard_data.mat');

%% Extract dataglove and ECoG data 
% Dataglove should be (samples x 5) array 
% ECoG should be (samples x channels) array

% use all the training data
%training set of all 3 subjects
train_dg_mat = cell2mat(train_dg);
final_traindg_1 = train_dg_mat(:,1:5);
final_traindg_2 = train_dg_mat(:,6:10);
final_traindg_3 = train_dg_mat(:,11:15);

final_trainecog_1 = train_ecog{1}(:,:);
final_trainecog_2 = train_ecog{2}(:,:);
final_trainecog_3 = train_ecog{3}(:,:);

ltest1 = leaderboard_ecog{1};
ltest1(:,55) = [];
ltest2 = leaderboard_ecog{2};
ltest2(:,21) = [];
ltest2(:,38) = [];
ltest3 = leaderboard_ecog{3};
%% Get Features
% run getWindowedFeats function
%
window_length = 80e-3;
window_overlap = 40e-3;
fs = 1000;
%train features for each subject

%% features loaded above, uncomment to run again
% [final_test_feats1]=getWindowedFeats(ltest1, fs, window_length, window_overlap);
% 
% [final_test_feats2]=getWindowedFeats(ltest2, fs, window_length, window_overlap);
% 
% [final_test_feats3]=getWindowedFeats(ltest3, fs, window_length, window_overlap);
% 
% %train features
% [final_train_feats1]=getWindowedFeats(final_trainecog_1, fs, window_length, window_overlap);
% 
% [final_train_feats2]=getWindowedFeats(final_trainecog_2, fs, window_length, window_overlap);
% 
% [final_train_feats3]=getWindowedFeats(final_trainecog_3, fs, window_length, window_overlap);

%% create Rmatrix and train model
final_downsampdg1 = downsample(final_traindg_1,40);
final_downsampdg2 = downsample(final_traindg_2,40);
final_downsampdg3 = downsample(final_traindg_3,40);


final_Y1 = final_downsampdg1(2:end,:);
final_Y2 = final_downsampdg2(2:end,:);
final_Y3 = final_downsampdg3(2:end,:);

[yfita1, yfitb1, yfitc1, yfitd1, Mdla1, Mdlb1, Mdlc1, Mdld1,Ba1, Bb1, Bc1, Bd1, ia1, ib1, ic1, id1]  = final_model(final_train_feats1, final_Y1, final_test_feats1);
[yfita2, yfitb2, yfitc2, yfitd2, Mdla2, Mdlb2, Mdlc2, Mdld2,Ba2, Bb2, Bc2, Bd2,ia2, ib2, ic2, id2]  = final_model(final_train_feats2, final_Y2, final_test_feats2);
[yfita3, yfitb3, yfitc3, yfitd3, Mdla3, Mdlb3, Mdlc3, Mdld3,Ba3, Bb3, Bc3, Bd3,ia3, ib3, ic3, id3]  = final_model(final_train_feats3, final_Y3, final_test_feats3);

%%
predicted_dg = cell(3,1);


%
a = {yfita1, yfitb1, yfitc1, yfitd1, yfitd1};
T = zeros(147500, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', 40);
    temp = [temp, temp(end) *ones(60,1)']';
    T(:,i) = temp;
end
predicted_dg{1} = T;

a = {yfita2, yfitb2, yfitc2, yfitd2,yfitd2};
T = zeros(147500, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', 40);
    temp = [temp, temp(end) *ones(60,1)']';
    T(:,i) = temp;
end
predicted_dg{2} = T;

a = {yfita3, yfitb3, yfitc3, yfitd3,yfitd3};
T = zeros(147500, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', 40);
    temp = [temp, temp(end) *ones(60,1)']';
    T(:,i) = temp;
end
predicted_dg{3} = T;
    

%% moving mean
for i = 1:3
    temp = predicted_dg{i};
    for j = [1 2 3 5]
        mv = movmean(temp(:,j),276);
        temp(:,j) = mv;
    end
    
    predicted_dg{i} = temp; 
end