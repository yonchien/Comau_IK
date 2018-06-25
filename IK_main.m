l_rate = 0.1;

q1 = 0;
q2 = 0;
q3 = -pi/2;
q4 = 0;
q5 = 0;
q6 = 0;
q_comf = [q1; q2; q3; q4; q5; q6];
q = q_comf;

eps = 0.0001;
q_old = q + 10*eps;

y_ini = subs(T_0eff(1:3,4));
y_target = [1.25;-0.5;0.8;1.5;0.75;-1];

Winv = zeros(6);
for i = 1:6
    Winv(i,i) = i/6 + 0.1;
end

C = eye(6) * 1000;

step = 0;
disp('Comenzando IK...')

hold off
plotKinematicChain(T_01,T_02,T_03,T_04,T_05,T_06,T_0eff);
grid on
hold on
plot3(y_target(1), y_target(2), y_target(3), 'Marker','*','MarkerSize',20)

dcost = 1000
cost = 0
old_cost = 0

while (dcost > eps)
    J_curr = simplify(subs(J));
    Jh = Winv * J_curr' * inv(J_curr * Winv * J_curr' + inv(C));

    y = zeros(6,1);
    T_full_curr = simplify(subs(T_0eff));
    y(1:3) = T_full_curr(1:3,4);
    y(4) = atan2(T_full_curr(3,2), T_full_curr(3,3));
	y(5) = atan2(-T_full_curr(3,1), sqrt(T_full_curr(3,2)^2 + T_full_curr(3,3)^2));
	y(6) = atan2(T_full_curr(2,1), T_full_curr(1,1));
    
    % q_old = q;
    q = q + l_rate*(Jh*(y_target - y)); % + (eye(6) - Jh*J_curr)*(q_comf - q));
    q1 = q(1);
    q2 = q(2);
    q3 = q(3);
    q4 = q(4);
    q5 = q(5);
    q6 = q(6);
    
    plotKinematicChain(T_01,T_02,T_03,T_04,T_05,T_06,T_0eff);
    step = step + 1
    
    dq = q_comf - q;
    cost = dq' * Winv * dq;
    dcost = abs(cost - old_cost);
    old_cost = cost;
end

function plotKinematicChain(T_01,T_02,T_03,T_04,T_05,T_06,T_0eff)
    kc = zeros(8,3);
    kc(2,:) = subs(T_01(1:3,4));
    kc(3,:) = subs(T_02(1:3,4));
    kc(4,:) = subs(T_03(1:3,4));
    kc(5,:) = subs(T_04(1:3,4));
    kc(6,:) = subs(T_05(1:3,4));
    kc(7,:) = subs(T_06(1:3,4));
    kc(8,:) = subs(T_0eff(1:3,4));
    
    plot3(kc(:,1),kc(:,2),kc(:,3),'Marker','o')
end

