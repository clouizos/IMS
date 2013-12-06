function svm_classify(voc_size)

if voc_size == 800
    feature_train_ = load('features_800.mat');
    features_train = feature_train_.features;

    feat_t_ = load('features_test_800.mat');
    features_test = feat_t_.features;
elseif voc_size == 400
    feature_train_ = load('features_400.mat');
    features_train = feature_train_.features;

    feat_t_ = load('features_test_400.mat');
    features_test = feat_t_.features;
end
svmstruct_all = svm_train(features_train);
fprintf('\n')
disp('Starting testing... ')
% for each binary classifier
%map = zeros(1,4);
for i=1:4
    % adjust the labels accordingly
    labels = -ones(1,size(features_test,1))';
    labels((i-1)*50 + 1:(i-1)*50 + 50) = 1;
    
    predict = svmclassify(svmstruct_all{i},features_test);
    
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
%     false_pos = length(intersect(pos_p, neg));
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
    %map(i) = length(pos)*()
%     [recall_vl, precision_vl] = vl_pr(labels, C);
%     figure(i)
%     plot(recall_vl, precision_vl);
%     title(strcat('precision-recall curve for: ',classif))
    
    
    disp('-------')
    fprintf('\n')
   
end

end