clear
clc

disp('Inicializando parametros...')
syms q1 q2 q3 q4 q5 q6

   %   a     alfa      d         teta
DH=[0.400,	-pi/2,	0.830,		 q1;
    1.175,	  0.0,	  0.0,	q2-pi/2;
    0.250,	-pi/2,	  0.0,  q3+pi/2;
      0.0,	-pi/2,	1.125,	  q4-pi;
      0.0,	 pi/2,	  0.0,		 q5;
      0.0,	  0.0,	0.230,		 q6];

T_01 = vpa(Translation(DH(1,3), 'z') * Rotation(DH(1,4), 'z') * Translation(DH(1,1), 'x') * Rotation(DH(1,2), 'x'));
T_12 = vpa(Translation(DH(2,3), 'z') * Rotation(DH(2,4), 'z') * Translation(DH(2,1), 'x') * Rotation(DH(2,2), 'x'));
T_23 = vpa(Translation(DH(3,3), 'z') * Rotation(DH(3,4), 'z') * Translation(DH(3,1), 'x') * Rotation(DH(3,2), 'x'));
T_34 = vpa(Translation(DH(4,3), 'z') * Rotation(DH(4,4), 'z') * Translation(DH(4,1), 'x') * Rotation(DH(4,2), 'x'));
T_45 = vpa(Translation(DH(5,3), 'z') * Rotation(DH(5,4), 'z') * Translation(DH(5,1), 'x') * Rotation(DH(5,2), 'x'));
T_56 = vpa(Translation(DH(6,3), 'z') * Rotation(DH(6,4), 'z') * Translation(DH(6,1), 'x') * Rotation(DH(6,2), 'x'));
T_6eff = vpa(Translation(0.4, 'z'));

T_02 = simplify(T_01 * T_12);
T_03 = simplify(T_02 * T_23);
T_04 = simplify(T_03 * T_34);
T_05 = simplify(T_04 * T_45);
T_06 = simplify(T_05 * T_56);
T_0eff = simplify(T_06 * T_6eff);

p_eff = T_0eff(1:3,4);
J = vpa(zeros(6));

% for i=1:3
%     for j=1:6
%         J(i,j) = diff(T_xyz(i),syms_arr(j));
%     end
% end
% 
% for i=4:6
%     for j=1:6
%         J(i,j) = diff(T_rpj(i-3),syms_arr(j));
%     end
% end

z0 = [0;0;1];
J(1:3,1) = cross(z0, p_eff - z0);
J(1:3,2) = cross(T_01(1:3,3), p_eff - T_01(1:3,4));
J(1:3,3) = cross(T_02(1:3,3), p_eff - T_02(1:3,4));
J(1:3,4) = cross(T_03(1:3,3), p_eff - T_03(1:3,4));
J(1:3,5) = cross(T_04(1:3,3), p_eff - T_04(1:3,4));
J(1:3,6) = cross(T_05(1:3,3), p_eff - T_05(1:3,4));

% J(4:6,1) = cross(T_01(1:3,1), T_0eff(1:3,1));
% J(4:6,2) = cross(T_02(1:3,1), T_0eff(1:3,1));
% J(4:6,3) = cross(T_03(1:3,1), T_0eff(1:3,1));
% J(4:6,4) = cross(T_04(1:3,1), T_0eff(1:3,1));
% J(4:6,5) = cross(T_05(1:3,1), T_0eff(1:3,1));
% J(4:6,6) = cross(T_06(1:3,1), T_0eff(1:3,1));

J(4:6,1) = z0;
J(4:6,2) = T_01(1:3,3);
J(4:6,3) = T_02(1:3,3);
J(4:6,4) = T_03(1:3,3);
J(4:6,5) = T_04(1:3,3);
J(4:6,6) = T_05(1:3,3);

J = simplify(J);
disp('Listo.')
