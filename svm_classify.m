function svm_classify(voc_size,type)

s = strcat('features_',int2str(voc_size),'_',type,'.mat');
s2 = strcat('features_test_',int2str(voc_size),'_',type,'.mat');
feature_train_ = load(s);
features_train = feature_train_.features;
feat_t_ = load(s2);
features_test = feat_t_.features;

svmstruct_all = svm_train(features_train, voc_size);
fprintf('\n')
disp('Starting testing... ')
% for each binary classifier
predictions = zeros(4,200);
prob_estimates = cell(1,4);
for i=1:4
    % adjust the labels accordingly
    labels = -ones(1,size(features_test,1))';
    labels((i-1)*50 + 1:(i-1)*50 + 50) = 1;
    
    %predictions(i,:) = svmpredict(labels,features_test,svmstruct_all{i}, '-b')';
    [predict,accuracy,prob_est] = svmpredict(labels,features_test(:,1:end-1),svmstruct_all{i}, '-b 1');
    %predictions(i,:) = predict;
    predictions(i,:) = prob_est(:,1)';
%     accuracy;
%     idx_pred = find(predict == 1);
%     labels_idx = labels(idx_pred);
%     prob_estimates{1,1} = prob_est(find(predict == 1)); 
%     prob_estimates{1,1};
    
    
    % find positive and negative examples and find
    % precision, recall, fmeasure and accuracy
%     pos = find(labels == 1);
%     neg = find(labels == -1);
%     
%     pos_p = find(predict == 1);
%     neg_p = find(predict == -1);
%     
%     true_pos = length(intersect(pos, pos_p));
%     true_neg = length(intersect(neg, neg_p));
%     
%     false_pos _list= length(intersect(pos_p, neg));
%     false_neg = length(intersect(neg_p, pos));

    % use matlab builtin confusionmat instead
    CM = confusionmat(labels', predict');
    

    if i == 1
        classif = 'airplanes';
    elseif i == 2
        classif = 'cars';
    elseif i == 3
        classif = 'faces';
    elseif i == 4
        classif = 'motorbikes';       
    end
    disp('-------')
    show = ['Results from classifer for ', classif, ':'];
    disp(show)
    precision = CM(2,2)/(CM(2,2) + CM(1,2))
    recall = CM(2,2)/(CM(2,2) + CM(2,1))
    f_measure = 2* (precision*recall)/(precision + recall)
    tot_accuracy = (CM(2,2) + CM(1,1))/(sum(sum(CM)))
       
    disp('-------')
    fprintf('\n')
   
end
disp('finished the classification. Writing the ranked images...')
fprintf('\n')
% create the ranked lists
[ranked_list, size_ones] = create_ranked_lists(predictions, 1, voc_size);
size_ones
evaluate_class(ranked_list, size_ones);

end