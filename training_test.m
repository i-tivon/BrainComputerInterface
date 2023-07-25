%% validate by splitting training data
% load('allfeatsB.mat');
load('final_proj_part1_data.mat');
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

%%
downsampdg1 = downsample(traindg_1,40);
downsampdg2 = downsample(traindg_2,40);
downsampdg3 = downsample(traindg_3,40);


Y1 = downsampdg1(2:end,:);
Y2 = downsampdg2(2:end,:);
Y3 = downsampdg3(2:end,:);
Y1t = testdg_1;
Y2t = testdg_2;
Y3t = testdg_3;

[yfita1t, yfitb1t, yfitc1t, yfitd1t, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~] = final_model(train_feats1, Y1, test_feats1);
[yfita2t, yfitb2t, yfitc2t, yfitd2t, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~] = final_model(train_feats2, Y2, test_feats2);
[yfita3t, yfitb3t, yfitc3t, yfitd3t, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~] = final_model(train_feats3, Y3, test_feats3);
%%
predicted_test = cell(3,1);


%
a = {yfita1t, yfitb1t, yfitc1t, yfitd1t, yfitd1t};
T = zeros(60000, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', 40);
    temp = [temp, temp(end) *ones(40,1)']';
    T(:,i) = temp;
end
predicted_test{1} = T;

a = {yfita2t, yfitb2t, yfitc2t, yfitd2t,yfitd2t};
T = zeros(60000, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', 40);
    temp = [temp, temp(end) *ones(40,1)']';
    T(:,i) = temp;
end
predicted_test{2} = T;

a = {yfita3t, yfitb3t, yfitc3t, yfitd3t,yfitd3t};
T = zeros(60000, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', 40);
    temp = [temp, temp(end) *ones(40,1)']';
    T(:,i) = temp;
end
predicted_test{3} = T;

%%
% for i = 200:400
i = 276;
cm1  = [[corr(Y1t(:,1),w_test{1}(:,1),i))],[corr(Y1t(:,2),movmean(predicted_test{1}(:,2),i))],[corr(Y1t(:,3),movmean(predicted_test{1}(:,3),i))],[corr(Y1t(:,5),movmean(predicted_test{1}(:,5),i))]]
cm2  = [[corr(Y2t(:,1),movmean(predicted_test{2}(:,1),i))],[corr(Y2t(:,2),movmean(predicted_test{2}(:,2),i))],[corr(Y2t(:,3),movmean(predicted_test{2}(:,3),i))],[corr(Y2t(:,5),movmean(predicted_test{2}(:,5),i))]]
cm3  = [[corr(Y3t(:,1),movmean(predicted_test{3}(:,1),i))],[corr(Y3t(:,2),movmean(predicted_test{3}(:,2),i))],[corr(Y3t(:,3),movmean(predicted_test{3}(:,3),i))],[corr(Y3t(:,5),movmean(predicted_test{3}(:,5),i))]]
result = mean((cm1+cm2+cm3)/3)
% if result >0.5716
%     break
% end
% end
% disp(i)
%%
% %% moving var
% gibby  = predicted_test;
% for i = 1:3
%     temp = gibby{i};
%     for j = [1 2 3 5]
%         mv = snr(temp(:,j));
%         temp(:,j) = mv;
%     end
%     
%     gibby{i} = temp; 
% end