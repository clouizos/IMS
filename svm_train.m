function svmstruct_all = svm_train(features, voc_size, kernel)
% 
% Training an SVM
% 
% Arguments needed:
% 
%     features
%     voc_size
%     kernel: possible choices 'rbf', 'poly', 'linear', 'sigmoid'

addpath('./libsvm-3.17/matlab')
%feat_ = load(feature_path);
%features = feat_.features;

svmstruct_all = cell(4,1);

% turn all nan values to 0
features(isnan(features)) = 0;

for i=1:4
    %labels = -ones(1,size(features,1))';
    labels = features(:,voc_size+1);
    % airplane
    if i == 1
       labels(find(labels > 1)) = -1 ;
       length(find(labels == 1))
       length(find(labels == -1))
       %labels(1:250) = 1;
    % cars   
    elseif i == 2
        labels(find(labels > 2)) = -1;
        labels(find(labels == 1)) = -1;
        labels(find(labels == 2)) = 1;
        length(find(labels == 1))
        length(find(labels == -1))
%         labels(251:465) = 1;
    % faces
    elseif i == 3
        labels(find(labels < 3)) = -1;
        labels(find(labels == 4)) = -1;
        labels(find(labels == 3)) = 1;
        length(find(labels == 1))
        length(find(labels == -1))
%         labels(466:615) = 1;
    % motorbikes
    else
        labels(find(labels < 4)) = -1;
        labels(find(labels == 4)) = 1;
        length(find(labels == 1))
        length(find(labels == -1))
%         labels(616:865) = 1;
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
    
    % rbf: 0.9610, 'opponent', 0.9630 'hsv'
    if strcmp(kernel, 'rbf')
        opts = '-s 0 -t 2 -g 3 -c 10 -b 1 -h 0 -q';
        %opts = '-s 0 -t 2 -g 4 -c 10 -b 1 -h 0 -q';
    elseif strcmp(kernel, 'poly')
    % polynomial: 0.9613, 'opponent'
        opts = '-s 0 -t 1 -g 2 -c 10 -r 1 -d 3 -b 1 -h 0 -e 0.0000001 -q';
    elseif strcmp(kernel, 'linear')
    % linear: 0.9426, 'opponent'
        opts = '-s 0 -t 0 -b 1 -q';
    elseif strcmp(kernel, 'sigmoid')
    % sigmoid: 0.7514, 'RGB'
        opts = '-s 0 -t 3 -g 0.0078 -r 0 -b 1 -q';
    end
    % cross validation doesn't work correctly yet
    cv = 0;
    if cv == 0
        svmstruct_all{i} = svmtrain(labels,features(:,1:end-1), opts);
    else
        model = svmtrain(labels,features(:,1:end-1), [opts,'-v 10']);
        params = model.Parameters;
        opts = ['-s 0 -t 2 -g ',int2str(params(2)),' -c ',int2str(params(3)),...
            ' -w1 ', int2str(params(4)), ' -w-1 ', int2str(params(5)), '-b 1 -h 0'];
        svmstruct_all{i} = svmtrain(labels,features(:,1:end-1), opts);
    end
    
end
disp('training finished...')


end