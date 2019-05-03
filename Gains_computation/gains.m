clear all;
close all;

time = 30;
%theta_desired = pi;
x_desired = [0; 0; 0; 0; 0; 0];
x_init = [0; -0.6; 0; 0; 0; 0; 0; 0; 0]; %x, y, phi, psi, dx, dphi, dpsi, uL, uR

%test_dof
me = 0;
mb = 2 + 2*me;%1;    %mass of body(cart)
d = 0.8;%1.3;%2.86; %length to center of mass of pole
g = 9.81;   %graviy
R=  0.265; % Radius of wheel
mw = 0.5;     % mass of wheel 
L = 0.34;  % distance from center of cart to its Left(or right) wheel
I2 = 0.0945;%0.1889;%1.6290%0.0945%
I3 = 1.6550;%13.0893;%12.3144;%1.6650% %IYY %IXX

% K = [-0.1000,  -11.0386,    0.5477,    -0.5620,   -4.6261,    1.3543;
  %    -0.1000,  -11.0386,   -0.5477,    -0.5620,   -4.6261,   -1.3543];

%Setting the Q and R value to solve LQR control
% Q = diag([31, 50, 45, 21, 10, 25]); %x, phi, psi, dx, dphi, dpsi
% S = diag([5,5]); %tL, tR
% A and B matrix obtained after linearizing the dynamics and ignoring
% second order term
Q = diag([0.1, 50, 3, 0.1, 10, 2]); %x, phi, psi, dx, dphi, dpsi
S = diag([5,5]); %tL, tR


addx   = (d^2*g*mb^2)/(2*d^2*mb^2 + 3*mw*d^2*mb + 3*I3*mb + 3*I3*mw);
addphi = (3*R*d*g*mb^2 + 3*R*d*g*mw*mb)/(R*(2*d^2*mb^2 + 3*mw*d^2*mb + 3*I3*mb + 3*I3*mw));

bddx   = -(mb*d^2 + R*mb*d + I3)/(R*(2*d^2*mb^2 + 3*mw*d^2*mb + 3*I3*mb + 3*I3*mw));
bddphi = -(3*R*mb + 3*R*mw + d*mb)/(R*(2*d^2*mb^2 + 3*mw*d^2*mb + 3*I3*mb + 3*I3*mw));
bddpsi = (2*L*R)/(6*mw*L^2*R^2 + 2*I2*R^2 + mw);

A = [  0   0     0  1  0  0;
       0   0     0  0  1  0;
       0   0     0  0  0  1;
       0  addx    0  0  0  0;
       0  addphi  0  0  0  0;
       0   0     0  0  0  0]
 
B = [0          0;
     0          0;
     0          0;
     bddx    bddx;
     bddphi  bddphi;
     bddpsi  -bddpsi]
 


[K,P,e] = lqr(A,B,Q,S);

% the sign of K is being flipped
% K(1,1) = -K(1,1); 
% K(1,4) = -K(1,4); 
% K(2,1) = -K(2,1); 
% K(2,4) = -K(2,4); 