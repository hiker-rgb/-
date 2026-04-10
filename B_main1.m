% 已知真空中矢量磁位的振幅 A0 1Wb/m，电磁波频率为 900MHz，求电场、磁场的振幅以及平均坡印廷矢量的大小。
% 主程序：设置参数并调用求解函数

clear; clc;

% ========== 参数设置 ==========
A0 = 1;                 % 矢量磁位振幅 (Wb/m)
f = 900e6;              % 频率 (Hz) 900 MHz

% ========== 调用求解函数 ==========
[E0, H0, Savg] = B_fun1(A0, f);

% ========== 输出结果 ==========
fprintf('========== 电磁波参数计算 ==========\n\n');
fprintf('已知条件:\n');
fprintf('  矢量磁位振幅 A0 = %.2f Wb/m\n', A0);
fprintf('  频率 f = %.2f MHz\n', f/1e6);
fprintf('  真空中传播\n\n');

fprintf('计算结果:\n');
fprintf('  角频率 ω = %.4e rad/s\n', 2*pi*f);
fprintf('  波数 k = %.4f rad/m\n', 2*pi*f/3e8);
fprintf('  电场振幅 E0 = %.4e V/m\n', E0);
fprintf('  磁场振幅 H0 = %.4e A/m\n', H0);
fprintf('  平均坡印廷矢量 Savg = %.4e W/m^2\n', Savg);