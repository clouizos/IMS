function svmstruct_all = svm_train(features)

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
    svmstruct_all{i} = svmtrain(features,labels,'kernel_function','rbf', 'rbf_sigma', 15);
   
end
disp('training finished...')


end