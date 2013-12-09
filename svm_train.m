function svmstruct_all = svm_train(features)

addpath('./libsvm-3.17/matlab')
%feat_ = load(feature_path);
%features = feat_.features;

svmstruct_all = cell(4,1);

for i=1:4
    labels = -ones(1,size(features,1))';
    if i == 1
        labels(1:250) = 1;
    elseif i == 2
        labels(251:465) = 1;
    elseif i == 3
        labels(466:615) = 1;
    else
        labels(616:865) = 1;
    end
    %labels((i-1)*50 + 1:(i-1)*50 + 50) = 1;
    s = ['training classifier ',int2str(i),'...' ];
    disp(s)
    
    % cross validation - useful in order to estimate the value
    % of the parameters of the kernel
%     CV = cvpartition(labels, 'Kfold', 10);
%     err = zeros(CV.NumTestSets);
%     for i=1:CV.NumTestSets
%         trIdx = CV.training(i);
%         teIdx = CV.test(i);
%         svmstr_test = svmtrain(features(trIdx,:), labels(trIdx,:), 'autoscale', false, 'method', 'QP', 'kernel_function', 'rbf', 'rbf_sigma', 1);
%         res = svmclassify(svmstr_test, features(teIdx,:));
% 
%         err(i) = sum(-labels(teIdx,:) == res);
%     end
%     cvErr = sum(err)/sum(CV.TestSize)
        
    svmstruct_all{i} = svmtrain(labels,features, '-s 0 -t 0 -b 1');
    
end
disp('training finished...')


end