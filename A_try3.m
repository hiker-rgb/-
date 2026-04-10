% ==========================================
% main: 主程序，仅负责设置物理参数
% ==========================================
clear; clc; close all;

% --- 物理参数设置 ---
E0 = 1;         % 无限大均匀静电场强度 (V/m)
a = 1;          % 介质圆柱体截面半径 (m)
eps0 = 1;       % 真空介电常数 (归一化以便于可视化)
eps = 4;        % 介质圆柱体介电常数 (示例设为4倍真空介电常数)

% --- 调用解题函数 ---
solveAndPlotCylinderField(E0, a, eps0, eps);


% ==========================================
% fun: 核心解题与可视化函数
% ==========================================
function solveAndPlotCylinderField(E0, a, eps0, eps)
    % 1. 构建空间网格
    L = 3 * a; % 计算区域大小为半径的3倍
    [X, Y] = meshgrid(linspace(-L, L, 300));
    R2 = X.^2 + Y.^2; % 极径的平方 R^2
    R = sqrt(R2);
    
    % 初始化电位和电场矩阵
    Phi = zeros(size(X));
    Ex = zeros(size(X));
    Ey = zeros(size(X));
    
    % 定义区域掩码 (逻辑索引)
    in = R <= a;   % 圆柱体内部
    out = R > a;   % 圆柱体外部
    
    % 2. 核心公式计算 (向量化运算提高效率)
    % 极化因子
    P_factor = (eps - eps0) / (eps + eps0) * a^2 * E0; 
    
    % 内部区域电位与电场
    Phi(in) = - (2 * eps0 / (eps + eps0)) * E0 * X(in);
    Ex(in)  = (2 * eps0 / (eps + eps0)) * E0;
    Ey(in)  = 0;
    
    % 外部区域电位与电场
    Phi(out) = - E0 * X(out) + P_factor * X(out) ./ R2(out);
    Ex(out)  = E0 + P_factor * (X(out).^2 - Y(out).^2) ./ (R2(out).^2);
    Ey(out)  = P_factor * (2 * X(out) .* Y(out)) ./ (R2(out).^2);
    
    % 3. 结果可视化
    figure('Name', '介质圆柱体电磁场分布', 'Position', [100, 100, 1000, 450]);
    
    % --- 绘制电位分布 (等位线与伪彩色图) ---
    subplot(1, 2, 1);
    contourf(X, Y, Phi, 40, 'LineColor', 'none'); 
    colormap parula; colorbar; hold on;
    % 绘制圆柱体边界
    theta = linspace(0, 2*pi, 100);
    plot(a*cos(theta), a*sin(theta), 'k--', 'LineWidth', 1.5);
    title('电位分布 \Phi (V)');
    xlabel('x'); ylabel('y');
    axis equal tight;
    
    % --- 绘制电场分布 (电场线) ---
    subplot(1, 2, 2);
    % 使用 streamslice 绘制平滑的电场线，密度设为1.5
    streamslice(X, Y, Ex, Ey, 1.5); hold on;
    % 绘制圆柱体边界
    plot(a*cos(theta), a*sin(theta), 'k-', 'LineWidth', 2);
    title('电场线分布 \vec{E}');
    xlabel('x'); ylabel('y');
    axis equal tight;
end