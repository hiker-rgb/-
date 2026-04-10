% ==========================================
% main: 天线阵方向图分析主程序
% ==========================================
clear; clc; close all;

% --- 1. 阵列基础参数 ---
N = 4;                  % 阵元数目
d_lam = 0.5;            % 间距 d = 0.5λ
kd = 2 * pi * d_lam;    % 相位常数项

% --- 2. 任务执行 (修正了 d_lambda 拼写错误) ---
C_fun3(N, d_lam, 0);            % 任务1：边射阵 (alpha = 0)
C_fun3(N, d_lam, -kd);          % 任务2：端射阵 (alpha = -kd)
% ==========================================
% fun: C_fun3 - 核心计算与可视化
% ==========================================
function C_fun3(N, d_lam, alpha)
    % 1. 环境准备
    theta = linspace(0, 2*pi, 1000);
    kd = 2 * pi * d_lam;
    
    % 确定阵列类型名称
    if abs(alpha) < 1e-6
        type_str = '边射阵';
    elseif abs(alpha + kd) < 1e-6
        type_str = '端射阵';
    else
        type_str = '均匀直线阵';
    end
    
    % 2. 计算阵因子 AF (使用 eps 避免除零)
    psi = kd * cos(theta) + alpha;
    AF = abs(sin(N * psi / 2) ./ (sin(psi / 2) + eps));
    
    % 3. 定义单元类型与公式
    % F_e{1}:电基本振子, F_e{2}:磁基本振子, F_e{3}:半波天线
    names = {'电基本振子阵', '磁基本振子阵', '半波天线阵'};
    F_e = {abs(sin(theta)), ...
           abs(cos(theta)), ...
           abs(cos(pi/2 * cos(theta)) ./ (sin(theta) + eps))};
    
    % 4. 循环绘图
    figure('Color', 'w', 'Position', [100, 100, 1200, 400], 'Name', type_str);
    for i = 1:3
        subplot(1, 3, i);
        pattern = (F_e{i} .* AF);
        pattern = pattern / max(pattern + eps); % 归一化
        
        polarplot(theta, pattern, 'LineWidth', 1.5);
        title(names{i}, 'FontSize', 11);
        
        % 坐标优化
        ax = gca;
        ax.ThetaZeroLocation = 'top'; 
        ax.ThetaDir = 'clockwise';
        rlim([0 1.1]);
        grid on;
    end
    sgtitle(sprintf('%s: $N=%d, d=%.1f\\lambda, \\alpha=%.2f$ rad', ...
            type_str, N, d_lam, alpha), 'Interpreter', 'latex');
end