

Covs=[[4.97271379e-04, 4.28737324e-05, 4.65461450e-05, 2.29287321e-05],
       [4.28737324e-05, 8.26610147e-04, 3.52071658e-05, 4.18303591e-05],
       [4.65461450e-05, 3.52071658e-05, 9.84762274e-05, 2.16489089e-05],
       [2.29287321e-05, 4.18303591e-05, 2.16489089e-05, 8.76322234e-05]]

Covs = Covs*252

format short

Q=[[0.02778 0.00387 0.00021]
    [0.00387 0.01112 -0.0002]
    [0.00021 -0.0002 0.00115]];

Mus = [0.1861135158667559 -0.011404279427947195 -0.10053955029174444 0.023231170019832215];

R=0;
for i = 1:100
    R=0.00186*i
    x1 = optimvar('x1');
    x2 = optimvar('x2');
    x3 = optimvar('x3');
    x4 = optimvar('x4');
    x=[x1 x2 x3 x4];
    
    prob = optimproblem;
    prob.Objective = x*Covs*transpose(x);
    prob.Constraints.cons1 = Mus*transpose(x) >= R;
    prob.Constraints.cons2 = x1+x2+x3+x4 == 1;
    prob.Constraints.cons3 = x1 >= 0;
    prob.Constraints.cons4 = x2 >= 0;
    prob.Constraints.cons5 = x3 >= 0;
    prob.Constraints.cons6 = x4 >= 0;

%     prob.Constraints.cons7 = x1 <= 0.4;
%     prob.Constraints.cons8 = x4 <= 0.3;
    
    sol = solve(prob);
    solarre=[sol.x1 sol.x2 sol.x3 sol.x4];
    solarr(i, :) = [sol.x1 sol.x2 sol.x3 sol.x4];
end

STD=sqrt(solarre*Covs*transpose(solarre));

for i = 1:100
    E(i)= Mus*transpose(solarr(i,:));
    STD(i)=sqrt(solarr(i,:)*Covs*transpose(solarr(i,:)));
end


figure
for j=1:10000
    no_opt(:,:,j)=rand(4,1);
    no_opt(:,:,j)=no_opt(:,:,j)/sum(no_opt(:,:,j));
    E_no_opt(j)= Mus*no_opt(:,:,j);
    STD_no_opt(j)=sqrt(transpose(no_opt(:,:,j))*Covs*no_opt(:,:,j));
    scatter(STD_no_opt(j), E_no_opt(j), 50, E_no_opt(j)/STD_no_opt(j), 'Filled');
    hold on
end
grid on





plot(STD,E, 'r', LineWidth=2)
xlabel('Standartinis nuokrypis')
ylabel('Tikėtina grąža')