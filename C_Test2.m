close all; clc; clear;

%% 1. 基础参数
eta0 = 120*pi;
lambda = 1;
k = 2*pi/lambda;
I = 1;
l = 0.01*lambda;

%% ===================== 电基本振子（x-z 平面）=====================
[x,z] = meshgrid(linspace(-2,2,40));
R = sqrt(x.^2 + z.^2);
R(R<1e-8) = 1e-8;
theta = atan2(x, z);

% 近场公式（正确）
Er = (I*l*cos(theta)) ./ (4*pi*R.^3);
Et = (I*l*sin(theta)) ./ (4*pi*R.^3);
Hf = (I*l*sin(theta)) ./ (4*pi*R.^2);

% 坐标变换
Ex = Er.*sin(theta) + Et.*cos(theta);
Ez = Er.*cos(theta) - Et.*sin(theta);
Hx = -Hf.*sin(theta);
Hz =  Hf.*cos(theta);

%% ===================== 磁基本振子（小电流环）=====================
[xm,zm] = meshgrid(linspace(-2,2,40));
Rm = sqrt(xm.^2 + zm.^2);
Rm(Rm<1e-8) = 1e-8;
thetam = atan2(xm, zm);

% 磁偶极子近场（标准公式）
Hr = (cos(thetam)) ./ Rm.^3;
Ht = (sin(thetam)) ./ Rm.^3;
Ef = (sin(thetam)) ./ Rm.^2;

% 正确坐标变换
Hxm =  Hr.*sin(thetam) + Ht.*cos(thetam);
Hzm =  Hr.*cos(thetam) - Ht.*sin(thetam);
Exm = -Ef.*sin(thetam);
Ezm =  Ef.*cos(thetam);

%% ===================== 方向图角度 =====================
theta_p = linspace(0, 2*pi, 360);
F_e = abs(sin(theta_p));
F_m = abs(sin(theta_p));

%% ===================== 绘图：总览图 =====================
figure('Position',[100,100,1000,800]);

% 电振子 电场
subplot(3,4,1);
quiver(x,z,Ex,Ez,'r','AutoScaleFactor',0.9);
axis equal; grid on; title('电振子 电场');

% 电振子 磁场
subplot(3,4,2);
quiver(x,z,Hx,Hz,'b','AutoScaleFactor',0.9);
axis equal; grid on; title('电振子 磁场');

% 磁振子 电场
subplot(3,4,5);
quiver(xm,zm,Exm,Ezm,'r','AutoScaleFactor',0.9);
axis equal; grid on; title('磁振子 电场');

% 磁振子 磁场
subplot(3,4,6);
quiver(xm,zm,Hxm,Hzm,'b','AutoScaleFactor',0.9);
axis equal; grid on; title('磁振子 磁场');

% --------------------- 方向图（全部显示网格线条）---------------------
% 电 E面：8字
subplot(3,4,9);
polarplot(theta_p, F_e,'LineWidth',1.5);
rlim([0 1]);
title('电 E面：8字');
ax = gca; ax.RGrid = 'on'; ax.ThetaGrid = 'on';

% 电 H面：圆（显示完整圆形）
subplot(3,4,10);
polarplot(theta_p, ones(size(theta_p)),'LineWidth',1.5);
rlim([0 1]);
title('电 H面：圆');
ax = gca; ax.RGrid = 'on'; ax.ThetaGrid = 'on';

% 磁 E面：圆
subplot(3,4,11);
polarplot(theta_p, ones(size(theta_p)),'LineWidth',1.5);
rlim([0 1]);
title('磁 E面：圆');
ax = gca; ax.RGrid = 'on'; ax.ThetaGrid = 'on';

% 磁 H面：8字
subplot(3,4,12);
polarplot(theta_p, F_m,'LineWidth',1.5);
rlim([0 1]);
title('磁 H面：8字');
ax = gca; ax.RGrid = 'on'; ax.ThetaGrid = 'on';

%% ===================== 3D 辐射方向图 =====================
[Theta,Phi] = meshgrid(linspace(0,pi,100),linspace(0,2*pi,100));
F3D = abs(sin(Theta));
X3D = F3D.*sin(Theta).*cos(Phi);
Y3D = F3D.*sin(Theta).*sin(Phi);
Z3D = F3D.*cos(Theta);

figure;
surf(X3D,Y3D,Z3D,'EdgeColor','none');
shading interp; colormap(jet); axis equal;
title('电/磁基本振子 3D 辐射方向图');