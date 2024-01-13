% Simulates the model with the current parameter Values
amplDiff(PARAMETERS.current);

% Make a plot in current figure
clf
subplot(2,1,1)
plot(time,amplOut(:,1))
ylabel('Error')
subplot(2,1,2)
plot(time,amplOut(:,3),time,amplOut(:,2),'.')
ylabel('y')
legend('Model','Data','Location','SouthEast')
xlabel('Time [s]')