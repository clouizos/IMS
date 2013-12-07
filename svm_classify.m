function svm_classify(voc_size)

if voc_size == 800
    s = 'features_800.mat';
    feature_train_ = load(s);
    features_train = feature_train_.features;

    feat_t_ = load('features_test_800.mat');
    features_test = feat_t_.features;
elseif voc_size == 400
    s = 'features_400.mat';
    feature_train_ = load(s);
    features_train = feature_train_.features;

    feat_t_ = load('features_test_400.mat');
    features_test = feat_t_.features;
end
svmstruct_all = svm_train(features_train);
fprintf('\n')
disp('Starting testing... ')
% for each binary classifier
predictions = zeros(4,200);
for i=1:4
    % adjust the labels accordingly
    labels = -ones(1,size(features_test,1))';
    labels((i-1)*50 + 1:(i-1)*50 + 50) = 1;
    
    predictions(i,:) = svmclassify(svmstruct_all{i},features_test)';
    
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
    CM = confusionmat(labels', predictions(i,:)');
    

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
[labels_list, ranked_list] = create_ranked_lists(predictions, 1);

evaluate_class(labels_list, ranked_list, 200);

end