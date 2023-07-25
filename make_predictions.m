function [predicted_dg] = make_predictions(test_ecog)

% INPUTS: test_ecog - 3 x 1 cell array containing ECoG for each subject, where test_ecog{i} 
% to the ECoG for subject i. Each cell element contains a N x M testing ECoG,
% where N is the number of samples and M is the number of EEG channels.

% OUTPUTS: predicted_dg - 3 x 1 cell array, where predicted_dg{i} contains the 
% data_glove prediction for subject i, which is an N x 5 matrix (for
% fingers 1:5)

% Run time: The script has to run less than 1 hour. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% load('final_proj_part1_data.mat');
% load('finalTrainFeats.mat');
load('saved_final_models.mat');
%%
% train_dg_mat = cell2mat(train_dg);
% final_traindg_1 = train_dg_mat(:,1:5);
% final_traindg_2 = train_dg_mat(:,6:10);
% final_traindg_3 = train_dg_mat(:,11:15);
% 
% final_trainecog_1 = train_ecog{1}(:,:);
% final_trainecog_2 = train_ecog{2}(:,:);
% final_trainecog_3 = train_ecog{3}(:,:);

ltest1 = test_ecog{1};
ltest1(:,55) = [];
ltest2 = test_ecog{2};
ltest2(:,21) = [];
ltest2(:,38) = [];
ltest3 = test_ecog{3};


%% Get Features
% run getWindowedFeats function
%
window_length = 80e-3;
window_overlap = 40e-3;
fs = 1000;
%train features for each subject


%% features loaded above, uncomment to run again
[final_test_feats1]=getWindowedFeats(ltest1, fs, window_length, window_overlap);

[final_test_feats2]=getWindowedFeats(ltest2, fs, window_length, window_overlap);

[final_test_feats3]=getWindowedFeats(ltest3, fs, window_length, window_overlap);

% %train features
% [final_train_feats1]=getWindowedFeats(final_trainecog_1, fs, window_length, window_overlap);
% 
% [final_train_feats2]=getWindowedFeats(final_trainecog_2, fs, window_length, window_overlap);
% 
% [final_train_feats3]=getWindowedFeats(final_trainecog_3, fs, window_length, window_overlap);
%% create Rmatrix and train model
% final_downsampdg1 = downsample(final_traindg_1,40);
% final_downsampdg2 = downsample(final_traindg_2,40);
% final_downsampdg3 = downsample(final_traindg_3,40);
% 
% 
% final_Y1 = final_downsampdg1(2:end,:);
% final_Y2 = final_downsampdg2(2:end,:);
% final_Y3 = final_downsampdg3(2:end,:);
%%
%make sure to load Mdls and Bs and is
N_wind = 6;
%%
ta = final_test_feats1(:,Ba1(:,ia1)~=0);
tb = final_test_feats1(:,Bb1(:,ib1)~=0);
tc = final_test_feats1(:,Bc1(:,ic1)~=0);
td = final_test_feats1(:,Bd1(:,id1)~=0);

Rta1 = create_R_matrix(ta, N_wind);
Rtb1 = create_R_matrix(tb, N_wind);
Rtc1 = create_R_matrix(tc, N_wind);
Rtd1 = create_R_matrix(td, N_wind);
yfita1 = predict(Mdla1, Rta1);
yfitb1 = predict(Mdlb1, Rtb1);
yfitc1 = predict(Mdlc1, Rtc1); 
yfitd1 = predict(Mdld1, Rtd1);

%%
ta = final_test_feats2(:,Ba2(:,ia2)~=0);
tb = final_test_feats2(:,Bb2(:,ib2)~=0);
tc = final_test_feats2(:,Bc2(:,ic2)~=0);
td = final_test_feats2(:,Bd2(:,id2)~=0);

Rta1 = create_R_matrix(ta, N_wind);
Rtb1 = create_R_matrix(tb, N_wind);
Rtc1 = create_R_matrix(tc, N_wind);
Rtd1 = create_R_matrix(td, N_wind);
yfita2 = predict(Mdla2, Rta1);
yfitb2 = predict(Mdlb2, Rtb1);
yfitc2 = predict(Mdlc2, Rtc1); 
yfitd2 = predict(Mdld2, Rtd1);
%%
ta = final_test_feats3(:,Ba3(:,ia3)~=0);
tb = final_test_feats3(:,Bb3(:,ib3)~=0);
tc = final_test_feats3(:,Bc3(:,ic3)~=0);
td = final_test_feats3(:,Bd3(:,id3)~=0);

Rta1 = create_R_matrix(ta, N_wind);
Rtb1 = create_R_matrix(tb, N_wind);
Rtc1 = create_R_matrix(tc, N_wind);
Rtd1 = create_R_matrix(td, N_wind);
yfita3 = predict(Mdla3, Rta1);
yfitb3 = predict(Mdlb3, Rtb1);
yfitc3 = predict(Mdlc3, Rtc1); 
yfitd3 = predict(Mdld3, Rtd1);
%%
predicted_dg = cell(3,1);


%
[x,~] = size(test_ecog{1});
[y,~] = size(final_test_feats1);
ya = floor(x/y);
yb = rem(x,y);
a = {yfita1, yfitb1, yfitc1, yfitd1, yfitd1};
T = zeros(x, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', ya);
    temp = [temp, temp(end) *ones(yb,1)']';
    T(:,i) = temp;
end
predicted_dg{1} = T;

a = {yfita2, yfitb2, yfitc2, yfitd2,yfitd2};
T = zeros(x, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', ya);
    temp = [temp, temp(end) *ones(yb,1)']';
    T(:,i) = temp;
end
predicted_dg{2} = T;

a = {yfita3, yfitb3, yfitc3, yfitd3,yfitd3};
T = zeros(x, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', ya);
    temp = [temp, temp(end) *ones(yb,1)']';
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
end

