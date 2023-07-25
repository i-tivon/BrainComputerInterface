% [a1,b1,c1,d1] = final_model(final_train_feats1, final_Y1, final_train_feats1);
% [a2,b2,c2,d2] = final_model(final_train_feats2, final_Y2, final_train_feats2);
% [a3,b3,c3,d3] = final_model(final_train_feats3, final_Y3, final_train_feats3);
% 
% %%
% 
% %%
% corr(a3, final_Y3(:,1))
%%
predicted_dg = cell(3,1);


%
a = {a1,b1,c1,d1,d1};
T = zeros(147500, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i))', 19);
    temp = [temp, temp(end) *ones(5019,1)']';
    T(:,i) = temp;
end
predicted_dg{1} = T;

a = {a2,b2,c2,d2,d2};
T = zeros(147500, 5);
for i = [1 2 3 5]
    temp = zoInterp(cell2mat(a(i)'), 19);
    temp = [temp, temp(end) *ones(5019,1)']';
    T(:,i) = temp;
end
predicted_dg{2} = T;

a = {a3,b3,c3,d3,d3};
T = zeros(147500, 5);
for i = [1 2 3 5]
   temp = zoInterp(cell2mat(a(i)'), 19);
    temp = [temp, temp(end) *ones(5019,1)']';
    T(:,i) = temp;
end
predicted_dg{3} = T;
    
%%
temp = zoInterp(final_Y1(:,1)', 19);
temp = [temp, temp(end) *ones(5019,1)']';
%%
subplot(1,2,1);
plot(predicted_dg{1}(:,1))
subplot(1,2,2);
plot(temp)
%%
corr(predicted_dg{1}(:,1),temp)
% %% moving variance
% 
% 
% for i = 1:3
%     temp = predicted_dg{i};
%     for j = [1 2 3 5]
%         mv = movvar(temp(:,j),5);
%         temp(:,j) = mv;
%     end
%     
%     predicted_dg{i} = temp; 
% end