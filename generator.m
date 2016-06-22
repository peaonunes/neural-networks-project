mkdir('./Results');

number_iterations = 2;

trainMseVector = [];
validMseVector = [];
testMseVector = [];

auc0Vector = [];
auc1Vector = [];

for n = 1:number_iterations
    fprintf('Rodando itera��o: %d ...', n);
    
    %Assinatura da fun��o redes neurais, em ordem:
    %num_intermediate_nodes    num de n�s na camada intermedi�ria(int)
    %learning_rate             taxa de aprendizagem(doubleO)
    %activation_function_name  fun��o de ativa��o(string)
    %output_function_name      fun��o dos n�s de sa�da(string)
    %learning_algorithm_name   algoritmo de aprendizagem(string)
    %weigth_algorithm_name)    algoritmo de aprendizegem do pesos(string)
    
    %Op��es de fun��o de ativa��o: 
    %'tansig', 'logsig', or 'purelin'
    
    %Op��es de fun��o de n� de sa�da:
    %'tansig', 'logsig', or 'purelin'
    
    %Op��es de algoritmo de aprendizagem:
    %'traincgb', 'traincgf', 'traincgp', 'traingda', 'traingdm', 'traingdx', 'trainlm',
    %'trainoss', 'trainrp', 'trainscg
    
    %Op��es de algoritmo de aprendizagem de peso:
    %'learngd' or 'learngdm'
    
    [targets, otuputs, MSE_train, MSE_valid, MSE_test]=redes_neurais(50, 0.2, 'tansig', 'tansig', 'traingdm', 'learngdm');
    
    %Adicionando os valores do MSE
    trainMseVector(end+1) = MSE_train;
    validMseVector(end+1) = MSE_valid;
    testMseVector(end+1) = MSE_test;
    %Calcula a area embaixo da curva ROC
    [X_0,Y_0,T_0,AUC_0] = perfcurve(targets(1,:), otuputs(1,:), 1);
    [X_1,Y_1,T_1,AUC_1] = perfcurve(targets(2,:), otuputs(2,:), 1);
    
    %Adicionando os valores do AUC
    auc0Vector(end+1) = AUC_0;
    auc1Vector(end+1) = AUC_1;
    
    %Criando diretorio de resultados
    outdir = sprintf('./Results/Iteration%d', n);
    mkdir(outdir);
    
    %Plota a matriz de confus�o
    figure('Name', 'Matriz de confus�o', 'Visible', 'Off');
    plotconfusion(targets, otuputs);
    print(strcat(outdir, '/Confusion') , '-dpng');
    
    %Plota a curva ROC
    figure('Name', 'Curva ROC', 'visible', 'off');
    plotroc(targets, otuputs);
    print(strcat(outdir, '/ROC'), '-dpng');
    
end

meanTrainMse = mean(trainMseVector);
meanValidMse = mean(validMseVector);
meanTestMse = mean(testMseVector);
meanAuc0 = mean(auc0Vector);
meanAuc1 = mean(auc1Vector);

rootdir = './Results';
fileID = fopen(strcat(rootdir, '/results.txt'), 'w');
fprintf(fileID, 'Resultados m�dio de %d itera��es... \r\n\r\n', n);

str = mat2str(trainMseVector);
fprintf(fileID, '%s\r\n' ,str);
fprintf(fileID, 'MSE m�dio para o conjunto de treinamento: %6.5f \r\n',meanTrainMse);
fprintf(fileID, 'MSE (desvio padr�o) para o conjunto de treinamento: %6.5f \r\n\r\n',std(trainMseVector));

str = mat2str(validMseVector);
fprintf(fileID, '%s\r\n' ,str);
fprintf(fileID, 'MSE m�dio para o conjunto de validacao: %6.5f \r\n',meanValidMse);
fprintf(fileID, 'MSE (desvio padr�o) para o conjunto de validacao: %6.5f \r\n\r\n',std(validMseVector));

str = mat2str(testMseVector);
fprintf(fileID, '%s\r\n' ,str);
fprintf(fileID, 'MSE m�dio para o conjunto de teste: %6.5f \r\n',meanTestMse);
fprintf(fileID, 'MSE (desvio padr�o) para o conjunto de teste: %6.5f \r\n\r\n',std(testMseVector));

str = mat2str(auc0Vector);
fprintf(fileID, 'AUCs-0: %s\r\n' ,str);
str = mat2str(auc1Vector);
fprintf(fileID, 'AUCs-1: %s\r\n' ,str);

fprintf(fileID, 'M�dia de AUC das classes:\r\nAUC-0: %0.10f\r\nAUC-1: %0.10f \r\n', meanAuc0, meanAuc1);
fprintf(fileID, 'Desvio padr�o de AUC das classes:\r\nAUC-0: %0.10f\r\nAUC-1: %0.10f \r\n', std(auc0Vector), std(auc1Vector));
fclose(fileID);

