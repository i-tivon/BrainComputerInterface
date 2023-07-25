function [yfita, yfitb, yfitc, yfitd, Mdla, Mdlb, Mdlc, Mdld, Ba, Bb, Bc, Bd, ia, ib, ic, id] = final_model(train_feats, Y, test_feats)

%for n = 6:6
    [Ba,FitInfoa] = lasso(train_feats,Y(:,1),'CV',5);
    [Bb,FitInfob] = lasso(train_feats,Y(:,2),'CV',5);
    [Bc,FitInfoc] = lasso(train_feats,Y(:,3),'CV',5);
    [Bd,FitInfod] = lasso(train_feats,Y(:,5),'CV',5);

    ia = find(FitInfoa.MSE>min(FitInfoa.MSE)+std(FitInfoa.MSE),1);
    ib = find(FitInfob.MSE>min(FitInfob.MSE)+std(FitInfob.MSE),1);
    ic = find(FitInfoc.MSE>min(FitInfoc.MSE)+std(FitInfoc.MSE),1);
    id = find(FitInfod.MSE>min(FitInfod.MSE)+std(FitInfod.MSE),1);

    Pa = train_feats(:,Ba(:,ia)~=0);
    Pb = train_feats(:,Bb(:,ib)~=0);
    Pc = train_feats(:,Bc(:,ic)~=0);
    Pd = train_feats(:,Bd(:,id)~=0);
    ta = test_feats(:,Ba(:,ia)~=0);
    tb = test_feats(:,Bb(:,ib)~=0);
    tc = test_feats(:,Bc(:,ic)~=0);
    td = test_feats(:,Bd(:,id)~=0);

    N_wind = 6;
    Ra =create_R_matrix(Pa, N_wind);
    Rb =create_R_matrix(Pb, N_wind);
    Rc =create_R_matrix(Pc, N_wind);
    Rd =create_R_matrix(Pd, N_wind);

    Rta = create_R_matrix(ta, N_wind);
    Rtb = create_R_matrix(tb, N_wind);
    Rtc = create_R_matrix(tc, N_wind);
    Rtd = create_R_matrix(td, N_wind);

    %corrc = zeros(1,5);
    Mdla = fitrensemble(Ra,Y(:,1),'Method','LSBoost','NumLearningCycles',40, 'Learners',templateTree('MaxNumSplits',10),'LearnRate',0.1);
    yfita = predict(Mdla, Rta);
     %corrc(1) = corr(Y1t(:,1),yfita);
    Mdlb = fitrensemble(Rb,Y(:,2),'Method','LSBoost','NumLearningCycles',40, 'Learners',templateTree('MaxNumSplits',10),'LearnRate',0.1);
    yfitb = predict(Mdlb, Rtb);
     %corrc(2) = corr(Y1t(:,2),yfitb);
    Mdlc = fitrensemble(Rc,Y(:,3),'Method','LSBoost','NumLearningCycles',40, 'Learners',templateTree('MaxNumSplits',10),'LearnRate',0.1);
    yfitc = predict(Mdlc, Rtc);
     %corrc(3) = corr(Y1t(:,3),yfitc);
    Mdld = fitrensemble(Rd,Y(:,5),'Method','LSBoost','NumLearningCycles',40, 'Learners',templateTree('MaxNumSplits',10),'LearnRate',0.1);
    yfitd = predict(Mdld, Rtd);
     %corrc(5) = corr(Y1t(:,5),yfitd);
%     disp(n);
%     disp(corrc);
%end
