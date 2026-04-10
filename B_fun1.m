function [E0, H0, Savg] = B_fun1(A0, f)
% 计算电磁波的电场、磁场振幅和平均坡印廷矢量
% 输入：
%   A0 - 矢量磁位振幅 (Wb/m)
%   f  - 频率 (Hz)
% 输出：
%   E0   - 电场振幅 (V/m)
%   H0   - 磁场振幅 (A/m)
%   Savg - 平均坡印廷矢量大小 (W/m^2)

    % 物理常数
    c = 3e8;                    % 光速 (m/s)
    mu0 = 4*pi*1e-7;            % 真空磁导率 (H/m)
    eps0 = 8.85e-12;            % 真空介电常数 (F/m)
    eta0 = sqrt(mu0/eps0);      % 真空本征阻抗 (Ω)
    
    % 计算角频率和波数
    omega = 2 * pi * f;          % 角频率 (rad/s)
    k = omega / c;               % 波数 (rad/m)
    
    % 计算电场振幅
    % E = -jωA，振幅 E0 = ω * A0
    E0 = omega * A0;
    
    % 计算磁场振幅
    % 方法1: H = E / η0
    H0 = E0 / eta0;
    
    % 方法2: H = (k/μ0) * A0 (验证)
    % H0_check = k * A0 / mu0;
    
    % 计算平均坡印廷矢量
    % Savg = (1/2) * E0 * H0
    Savg = 0.5 * E0 * H0;
    
end