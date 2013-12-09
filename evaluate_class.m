function evaluate_class(ranked_list, size_eval)

% pr curves for all classes
% assume the returned set are all test images
% maximum of the returned results of the classifiers
%pre = zeros(4,max(size_eval));
%rec = ones(4,max(size_eval));
pre = cell(1,4);
rec = cell(1,4);
avg_pre = zeros(4,max(size_eval));
map = zeros(1,4);
count = 0;
count2 = 0;
% size(ranked_list)
% tmp = ranked_list{1};
% tmp2 = tmp{1}

air_test = './data/airplanes_test/';
car_test = './data/cars_test/';
face_test = './data/faces_test/';
motor_test = './data/motorbikes_test/';
labels_list = {air_test, car_test, face_test, motor_test};
%size(labels_list)
for i=1:size(ranked_list,1)%size(labels_list,1)
    %pre{1,i} = zeros(1, size_eval(i));
    %rec{1,i} = ones(1, size_eval(i));
    tmp = ranked_list{i};
    for j=1:size_eval(i)%max(size_eval)
        
        count2 = count2 + 1;
        %size_eval(i)
%         if j > size_eval(i)
%             break
%         end
        
        %if strcmp(ranked_list{i,j}, labels_list{i,1})
        %check = tmp{j}
        %check2 = labels_list{i}
        if strcmp(tmp{j}, labels_list{i})
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
mean_average_precision = mean(map)
close all;
figure('name', 'Precision-Recall Graph')
plot(rec{1,1},pre{1,1},'b',rec{1,2},pre{1,2},'r',rec{1,3},pre{1,3},...
    'g',rec{1,4},pre{1,4}, 'm');
xlabel('Recall'); ylabel('Precision');
ylim([0 1.1]);xlim([0 0.99]);
leg = legend('airplanes','cars','faces','motorbikes');

end