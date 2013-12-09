function svmstruct_all = svm_train(features)

addpath('./libsvm-3.17/matlab')
%feat_ = load(feature_path);
%features = feat_.features;

svmstruct_all = cell(4,1);

for i=1:4
    labels = -ones(1,size(features,1))';
    % airplane
    if i == 1
        labels(1:250) = 1;
    % cars   
    elseif i == 2
        labels(251:465) = 1;
    % faces
    elseif i == 3
        labels(466:615) = 1;
    % motorbikes
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
        

% options:
% -s svm_type : set type of SVM (default 0)
% 	0 -- C-SVC
% 	1 -- nu-SVC
% 	2 -- one-class SVM
% 	3 -- epsilon-SVR
% 	4 -- nu-SVR
% -t kernel_type : set type of kernel function (default 2)
% 	0 -- linear: u'*v
% 	1 -- polynomial: (gamma*u'*v + coef0)^degree
% 	2 -- radial basis function: exp(-gamma*|u-v|^2)
% 	3 -- sigmoid: tanh(gamma*u'*v + coef0)
% -d degree : set degree in kernel function (default 3)
% -g gamma : set gamma in kernel function (default 1/num_features)
% -r coef0 : set coef0 in kernel function (default 0)
% -c cost : set the parameter C of C-SVC, epsilon-SVR, and nu-SVR (default 1)
% -n nu : set the parameter nu of nu-SVC, one-class SVM, and nu-SVR (default 0.5)
% -p epsilon : set the epsilon in loss function of epsilon-SVR (default 0.1)
% -m cachesize : set cache memory size in MB (default 100)
% -e epsilon : set tolerance of termination criterion (default 0.001)
% -h shrinking: whether to use the shrinking heuristics, 0 or 1 (default 1)
% -b probability_estimates: whether to train a SVC or SVR model for probability estimates, 0 or 1 (default 0)
% -wi weight: set the parameter C of class i to weight*C, for C-SVC (default 1)
% -q : quiet mode    
    opts = '-s 0 -t 2 -g 2 -c 2 -b 1 -q';
    svmstruct_all{i} = svmtrain(labels,features, opts);
    
end
disp('training finished...')


end