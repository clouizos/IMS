function evaluate_class(labels_list, ranked_list, size_eval)

% pr curves for all classes
% assume the returned set are all test images
% maximum of the returned results of the classifiers
max(size_eval)
%pre = zeros(4,max(size_eval));
%rec = ones(4,max(size_eval));
pre = cell(1,4);
rec = cell(1,4);
avg_pre = zeros(4,max(size_eval));
map = zeros(1,4);
count = 0;
count2 = 0;
for i=1:size(labels_list,1)
    %pre{1,i} = zeros(1, size_eval(i));
    %rec{1,i} = ones(1, size_eval(i));
    for j=1:max(size_eval)
        
        count2 = count2 + 1;
        %size_eval(i)
        if j > size_eval(i)
            break
        end
        if strcmp(ranked_list{i,j}, labels_list{i,1})
            count = count + 1;
            %rec(i,count) = count/50;
            %pre(i,count) = count/j;
            rec{1,i}(count) = count/50;
            pre{1,i}(count) = count/j;
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
plot(rec{1,1},pre{1,1},'b',rec{1,2},pre{1,2},'r',rec{1,3},pre{1,3},...
    'g',rec{1,4},pre{1,4}, 'm');
xlabel('Recall'); ylabel('Precision');
ylim([-0.1 1.1]);xlim([0 0.99]);
leg = legend('airplanes','cars','faces','motorbikes');

end