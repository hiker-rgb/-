% ==========================================
% main: 主程序，仅负责参数配置与调用
% ==========================================
clear; clc; close all;

% --- 物理参数设置 ---
E0 = 1;                  % 电场基准振幅 (V/m)
eta0 = 377;              % 真空波阻抗 (Ω)
omega = 2*pi;            % 角频率 (rad/s)

% --- 仿真参数设置 ---
t_total = 2*pi/omega;    % 模拟总时间 (1个周期)
frames = 150;            % 动画采样帧数

% --- 调用核心动画函数 ---
animatePolarization(E0, eta0, omega, t_total, frames);


% ==========================================
% fun: 核心计算与动画演示函数
% ==========================================
function animatePolarization(E0, eta0, omega, t_total, frames)
    % 1. 计算时间序列与瞬时场值
    t = linspace(0, t_total, frames);

    % 电场瞬时值 (z=0)
    Ex = E0 * sin(omega * t);
    Ey = -4 * E0 * cos(omega * t);

    % 磁场瞬时值 (z=0)
    Hx = (4 * E0 / eta0) * cos(omega * t);
    Hy = -(E0 / eta0) * sin(omega * t);

    % 2. 图形窗口与坐标轴初始化
    fig = figure('Name', '电磁波极化动态演示', 'Color', 'w', 'Position', [100, 100, 1000, 500]);
    
    % 预设坐标轴限度以精简代码
    lim_E = [-5*E0, 5*E0];
    lim_H = [-5*E0/eta0, 5*E0/eta0];

    % 初始化电场子图 (使用完整周期的 Ex, Ey 作为静态理论椭圆背景)
    ax1 = subplot(1, 2, 1);
    plot(Ex, Ey, 'k--', 'LineWidth', 1, 'DisplayName', '理论椭圆'); hold on;
    h_e_trace = plot(Ex(1), Ey(1), 'r-', 'LineWidth', 2, 'DisplayName', '电场矢量轨迹');
    h_e_point = plot(Ex(1), Ey(1), 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 6, 'HandleVisibility', 'off');
    setupAxis(ax1, '$E_x$ (V/m)', '$E_y$ (V/m)', lim_E);

    % 初始化磁场子图
    ax2 = subplot(1, 2, 2);
    plot(Hx, Hy, 'k--', 'LineWidth', 1, 'DisplayName', '理论椭圆'); hold on;
    h_h_trace = plot(Hx(1), Hy(1), 'b-', 'LineWidth', 2, 'DisplayName', '磁场矢量轨迹');
    h_h_point = plot(Hx(1), Hy(1), 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 6, 'HandleVisibility', 'off');
    setupAxis(ax2, '$H_x$ (A/m)', '$H_y$ (A/m)', lim_H);

    % 3. 动画主循环
    for k = 1:frames
        if ~ishandle(fig) % 若用户提前关闭窗口则安全退出，避免报错
            break;
        end
        
        % 动态更新轨迹与端点数据
        set(h_e_trace, 'XData', Ex(1:k), 'YData', Ey(1:k));
        set(h_e_point, 'XData', Ex(k), 'YData', Ey(k));
        
        set(h_h_trace, 'XData', Hx(1:k), 'YData', Hy(1:k));
        set(h_h_point, 'XData', Hx(k), 'YData', Hy(k));
        
        % 动态更新标题显示相位 (使用 \pi 转义字符优化视觉效果)
        phase_pi = mod(omega * t(k), 2*pi) / pi;
        title(ax1, sprintf('电场极化：左旋椭圆极化 (相位=%.2f\\pi)', phase_pi), 'FontSize', 12);
        title(ax2, sprintf('磁场极化：左旋椭圆极化 (相位=%.2f\\pi)', phase_pi), 'FontSize', 12);
        
        drawnow;
        pause(0.02);
    end

    % 4. 打印核心结论
    printConclusions();
end

% --- 辅助函数：统一坐标轴格式 (消除冗余代码) ---
function setupAxis(ax, x_lbl, y_lbl, limits)
    xlabel(ax, x_lbl, 'Interpreter', 'Latex', 'FontSize', 11);
    ylabel(ax, y_lbl, 'Interpreter', 'Latex', 'FontSize', 11);
    grid(ax, 'on'); 
    axis(ax, 'equal');
    xlim(ax, limits); 
    ylim(ax, limits);
    legend(ax, 'Location', 'best');
end

% --- 辅助函数：终端输出结论 ---
function printConclusions()
    fprintf('\n==== 极化判断结论 ====\n');
    fprintf('1. 电场极化类型：左旋椭圆极化（振幅比 E_y/E_x=4，相位差 π/2）\n');
    fprintf('2. 磁场极化类型：左旋椭圆极化（振幅比 H_x/H_y=4，相位差 π/2）\n');
    fprintf('3. 传播方向：+z 方向，E×H 指向传播方向\n');
    fprintf('======================\n');
end