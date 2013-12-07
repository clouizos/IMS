function evaluate_class(labels_list, ranked_list, size_eval)

% pr curves for all classes
% assume the returned set are all test images
pre = zeros(4,size_eval);
rec = ones(4,size_eval);
avg_pre = zeros(4,size_eval);
map = zeros(1,4);
count = 0;
count2 = 0;
for i=1:size(labels_list,1)
    for j=1:size_eval
        count2 = count2 + 1;
        if strcmp(ranked_list{i,j}, labels_list{i,1})
            count = count + 1;
            rec(i,count) = count/50;
            pre(i,count) = count/j;
            avg_pre(i,count2) = (count/j);
        end
    end
    map(i) = (1/50)*sum(avg_pre(i,:));
    count = 0;
    count2 = 0;
end
mean_average = mean(map)

close all;
figure('name', 'Precision-Recall Graph')
plot(rec(1,:),pre(1,:),'b',rec(2,:),pre(2,:),'r',rec(3,:),pre(3,:),...
    'g',rec(4,:),pre(4,:), 'm');
xlabel('Recall'); ylabel('Precision');
ylim([-0.1 1.1]);xlim([0 0.99]);
leg = legend('airplanes','cars','faces','motorbikes');

end