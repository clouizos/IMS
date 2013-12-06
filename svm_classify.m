function svm_classify
feature_train_ = load('features_800.mat');
features_train = feature_train_.features;

feat_t_ = load('features_test_800.mat');
features_test = feat_t_.features;

svmstruct_all = svm_train(features_train);
fprintf('\n')
disp('Starting testing... ')
% for each binary classifier
%map = zeros(1,4);
for i=1:4
    % adjust the labels accordingly
    labels = -ones(1,size(features_train,1))';
    labels((i-1)*50 + 1:(i-1)*50 + 50) = 1;
    
    C = svmclassify(svmstruct_all{i},features_test);
    
    % find positive and negative examples and find
    % precision, recall, fmeasure and accuracy
    pos = find(labels == 1);
    neg = find(labels == -1);
    
    pos_p = find(C == 1);
    neg_p = find(C == -1);
    
    true_pos = length(intersect(pos, pos_p));
    true_neg = length(intersect(neg, neg_p));
    
    false_pos = length(intersect(pos_p, neg));
    false_neg = length(intersect(neg_p, pos));

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
    precision = true_pos/(true_pos + false_pos)
    recall = true_pos/(true_pos + false_neg)
    f_measure = 2* (precision*recall)/(precision + recall)
    tot_accuracy = (true_pos + true_neg)/(true_pos+true_neg+false_pos+false_neg)
    %map(i) = length(pos)*()
%     [recall_vl, precision_vl] = vl_pr(labels, C);
%     figure(i)
%     plot(recall_vl, precision_vl);
%     title(strcat('precision-recall curve for: ',classif))
    disp('-------')
    fprintf('\n')
end

end