% ==========================================
% 主程序：电磁波斜入射的反射与折射计算及可视化
% 严格匹配指定教材的符号约定
% ==========================================
clear; clc; close all;

% --- 1. 介质参数设置 ---
epsilon_r1 = 1;   % 介质1（空气）相对介电常数
mu_r1 = 1;        % 介质1相对磁导率
epsilon_r2 = 4;   % 介质2（理想介质）相对介电常数
mu_r2 = 1;        % 介质2相对磁导率

% --- 2. 计算准备 ---
% 入射角范围（度），使用 500 个点保证曲线平滑
theta_i_deg = linspace(0, 90, 500);  

% 调用核心计算函数
[theta_r_deg, theta_t_deg, Gamma_perp, Tau_perp, Gamma_para, Tau_para] = ...
    Calculate_Fresnel_Coeffs(theta_i_deg, epsilon_r1, mu_r1, epsilon_r2, mu_r2);

% 计算布儒斯特角 (Brewster angle) 用于图像标注
% 当波从媒质1进入媒质2时，平行极化波反射系数为0的入射角
theta_B = atand(sqrt((epsilon_r2 * mu_r1) / (epsilon_r1 * mu_r2))); 

% --- 3. 结果可视化 ---

% 图像1：反射角与折射角的变化规律
figure('Name', '角度变化', 'Position', [100, 100, 500, 400]);
plot(theta_i_deg, theta_r_deg, 'b-', 'LineWidth', 2); hold on;
plot(theta_i_deg, theta_t_deg, 'r-', 'LineWidth', 2);
grid on;
title('反射角与折射角随入射角的变化');
xlabel('入射角 \theta_i (度)');
ylabel('角度 (度)');
legend('反射角 \theta_r', '折射角 \theta_t', 'Location', 'northwest');
xlim([0 90]); ylim([0 90]);

% 图像2：菲涅尔系数（反射与折射系数）变化规律
figure('Name', '菲涅尔系数随入射角的变化', 'Position', [650, 100, 1000, 400]);

% 子图(1): 反射系数
subplot(1, 2, 1);
plot(theta_i_deg, Gamma_perp, 'b-', 'LineWidth', 2); hold on;
plot(theta_i_deg, Gamma_para, 'r-', 'LineWidth', 2);
% 标注布儒斯特角
plot(theta_B, 0, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'y'); 
text(theta_B + 2, 0.05, sprintf('布儒斯特角 \\theta_B = %.1f°', theta_B), 'FontSize', 10);
grid on;
title('反射系数随入射角的变化 (遵循课本符号约定)');
xlabel('入射角 \theta_i (度)');
ylabel('反射系数 \Gamma');
legend('垂直极化 \Gamma_{\perp}', '平行极化 \Gamma_{\parallel}', 'Location', 'southwest');
xlim([0 90]);
% 设定纵坐标范围以便清晰观察
ylim([-1.1 1.1]); 

% 子图(2): 折射系数
subplot(1, 2, 2);
plot(theta_i_deg, Tau_perp, 'b-', 'LineWidth', 2); hold on;
plot(theta_i_deg, Tau_para, 'r-', 'LineWidth', 2);
grid on;
title('折射系数随入射角的变化');
xlabel('入射角 \theta_i (度)');
ylabel('折射系数 \tau');
legend('垂直极化 \tau_{\perp}', '平行极化 \tau_{\parallel}', 'Location', 'southwest');
xlim([0 90]);
ylim([0 0.8]);


% ==========================================
% 核心解题函数：Calculate_Fresnel_Coeffs
% 功能：基于斯涅尔定律和菲涅尔公式计算角度及系数
% ==========================================
function [theta_r_deg, theta_t_deg, Gamma_perp, Tau_perp, Gamma_para, Tau_para] = ...
    Calculate_Fresnel_Coeffs(theta_i_deg, epsilon_r1, mu_r1, epsilon_r2, mu_r2)

    % 将角度转换为弧度进行三角函数计算
    theta_i = deg2rad(theta_i_deg);
    
    % 计算真空中光速归一化后的相对折射率
    n1 = sqrt(epsilon_r1 * mu_r1);
    n2 = sqrt(epsilon_r2 * mu_r2);
    
    % 斯涅尔反射定律：反射角等于入射角
    theta_r = theta_i;
    theta_r_deg = rad2deg(theta_r);
    
    % 斯涅尔折射定律：n1*sin(θ_i) = n2*sin(θ_t)
    sin_theta_t = (n1 / n2) * sin(theta_i);
    theta_t = asin(sin_theta_t);
    theta_t_deg = rad2deg(theta_t);
    
    % 计算相对波阻抗比: η2/η1 = sqrt(μ_r2/ε_r2) / sqrt(μ_r1/ε_r1)
    eta_ratio = sqrt((mu_r2/epsilon_r2) / (mu_r1/epsilon_r1));
    
    % 预计算角度余弦值以提高效率
    cos_theta_i = cos(theta_i);
    cos_theta_t = cos(theta_t);
    
    % ---------------------------------------------------------
    % 垂直极化（TE波）反射系数与折射系数
    % ---------------------------------------------------------
    Gamma_perp = (eta_ratio * cos_theta_i - cos_theta_t) ./ ...
                 (eta_ratio * cos_theta_i + cos_theta_t);
                 
    Tau_perp = (2 * eta_ratio * cos_theta_i) ./ ...
               (eta_ratio * cos_theta_i + cos_theta_t);
    
    % ---------------------------------------------------------
    % 平行极化（TM波）反射系数与折射系数
    % *注意*：此处的 Gamma_para 已按照课本图5右图的右手定则矢量方向修正
    % 使得在掠入射 (90度) 时，反射系数趋近于 -1
    % ---------------------------------------------------------
    Gamma_para = (cos_theta_i - eta_ratio * cos_theta_t) ./ ...
                 (cos_theta_i + eta_ratio * cos_theta_t);
                 
    Tau_para = (2 * eta_ratio * cos_theta_i) ./ ...
               (cos_theta_i + eta_ratio * cos_theta_t);
end