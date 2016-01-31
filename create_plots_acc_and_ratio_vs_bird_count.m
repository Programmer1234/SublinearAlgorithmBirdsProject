acc =[0.9167    0.9070    0.8750    0.7800    0.7000];
ratio = [1.8334    2.7210    3.5000    3.9000    4.2000];
bird_count = [2 3 4 5 6];

X_AXIS_MIN = 2;
X_AXIS_MAX = 6;
X_AXIS_LABEL = '# of Bird Species';

% Plot the first graph
Y_AXIS_MIN = 0;
Y_AXIS_MAX = 1;

figure(); 
plot(bird_count, acc); 
axis([X_AXIS_MIN X_AXIS_MAX Y_AXIS_MIN Y_AXIS_MAX]);
xlabel(X_AXIS_LABEL) % x-axis label
ylabel('Classification Accuracy') % y-axis label
title('Classification Accuracy vs # of Bird Species');

% Plot the second graph
Y_AXIS_MIN = 0;
Y_AXIS_MAX = 5;

figure(); 
plot(bird_count, ratio); 
axis([X_AXIS_MIN X_AXIS_MAX Y_AXIS_MIN Y_AXIS_MAX]);
xlabel(X_AXIS_LABEL) % x-axis label
ylabel('Classification Accuracy Ratio') % y-axis label
title('Classification Accuracy Ratio vs # of Bird Species');
