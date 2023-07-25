
plot(Y1t(:,1))
figure()
plot(predicted_test{1}(:,1))
figure(); plot(gibby{1}(:,1))

figure()
for i = [1 2 3 5]
    plot(movmean(T(1:1000,i),8))
    hold on;
end


figure()
for i = [1 2 3 5]
    plot(T(1:10000,i))
    hold on;
end

figure()
for i = [1 2 3 5]
    plot(movvar(T(1:1000,i),5))
    hold on;
end
figure()
for i = [1 2 3 5]
    plot(final_traindg_1(1:100000,i))
    hold on;
end

%remove noise
figure()
for i = [1 2 3 5]
    ac = reshape(T(1:144000,i),4000,[]);
    ac = mean(ac,2);
    %subtract ac from all channels
    A = repmat(ac,36,1);
    clean_data = T(1:144000,i) - A;
    plot(clean_data(1:1000))
    hold on;
end