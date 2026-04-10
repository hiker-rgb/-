% ==========================================
% main: 口径天线方向图分析 (设计题 5)
% ==========================================
clear; clc; close all;

% --- 物理参数设置 ---
lambda = 0.1;       % 工作波长 (m)

% 喇叭天线（矩形口径）参数
a_horn = 5 * lambda; % 宽度
b_horn = 3 * lambda; % 高度

% 抛物面天线（圆形口径）参数
D_parab = 8 * lambda; % 直径

% --- 调用核心功能函数 ---
C_fun5(lambda, a_horn, b_horn, D_parab);
% ==========================================
% fun: C_fun5 - 计算并绘制口径天线方向图
% ==========================================
function C_fun5(lambda, a, b, D)
    % 1. 基础常量与坐标采样
    k = 2 * pi / lambda;
    theta = linspace(-pi/2, pi/2, 1000); % 高密度采样
    
    % 2. 喇叭天线（矩形均匀口径）计算
    % 选取 E 面（x-z面）进行分析
    u_rect = (k * a / 2) * sin(theta);
    % 使用 sinc 函数公式: F = |sin(u)/u|
    % 加上 eps 防止分母为 0
    E_horn = abs(sin(u_rect) ./ (u_rect + eps));
    E_horn = E_horn / max(E_horn); % 归一化

    % 3. 抛物面天线（圆形均匀口径）计算
    % 归一化方向性函数：F = |2 * J1(u) / u|
    R = D / 2;
    u_circ = (k * R) * sin(theta);
    E_parab = abs(2 * besselj(1, u_circ) ./ (u_circ + eps));
    E_parab = E_parab / max(E_parab); % 归一化

    % 4. 结果可视化
    figure('Color', 'w', 'Position', [100, 100, 1100, 500]);

    % --- 子图1：喇叭天线 ---
    subplot(1, 2, 1);
    draw_aperture_polar(theta, E_horn, '喇叭天线 (矩形口径)', 'b');

    % --- 子图2：抛物面天线 ---
    subplot(1, 2, 2);
    draw_aperture_polar(theta, E_parab, '抛物面天线 (圆形口径)', 'r');
    
    % 打印关键工程参数
    fprintf('==== 口径天线分析结论 ====\n');
    fprintf('喇叭天线口径: %.2fλ x %.2fλ\n', a/lambda, b/lambda);
    fprintf('抛物面口径直径: %.2fλ\n', D/lambda);
    fprintf('========================\n');
end

% --- 内部辅助绘图函数 (保持代码简洁) ---
function draw_aperture_polar(theta, pattern, antenna_name, color_str)
    polarplot(theta, pattern, color_str, 'LineWidth', 2);
    title(antenna_name, 'FontSize', 14, 'FontWeight', 'bold');
    
    % 极坐标系优化
    ax = gca;
    ax.ThetaZeroLocation = 'right'; % 0度（主瓣方向）指向右侧
    ax.ThetaDir = 'counterclockwise'; 
    thetalim([-90 90]);              % 仅显示前向波束
    rlim([0 1.1]);
    ax.RAxis.TickValues = [0.2 0.4 0.6 0.8 1.0];
    grid on;
    
    % 增加 LaTeX 标注
    text(0, 1.2, '主瓣方向 ($0^{\circ}$)', 'Interpreter', 'latex', ...
        'HorizontalAlignment', 'center', 'FontSize', 11);
end