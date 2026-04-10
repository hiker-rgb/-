% ==========================================
% main: 主程序，仅负责设置物理与离散参数
% ==========================================
clear; clc; close all;

% --- 物理与网格参数设置 ---
a = 1;              % 正方形金属平板边长 (m)
V0 = 1;             % 平板已知电位 (V)
N = 20;             % 每条边的离散段数 (剖分面元总数 M = N*N)
eps0 = 8.854e-12;   % 真空介电常数 (F/m)

% --- 调用矩量法解题函数 ---
solveSquarePlateMoM(a, V0, N, eps0);


% ==========================================
% fun: 核心解题与可视化函数
% ==========================================
function solveSquarePlateMoM(a, V0, N, eps0)
    % 1. 网格初始化
    M = N * N;          % 面元总数
    delta = a / N;      % 面元边长
    ds = delta^2;       % 面元面积
    
    % 生成面元中心点坐标
    x_nodes = linspace(-a/2 + delta/2, a/2 - delta/2, N);
    [X, Y] = meshgrid(x_nodes, x_nodes);
    xc = X(:);          % 中心点 x 坐标一维展开
    yc = Y(:);          % 中心点 y 坐标一维展开
    
    % 2. 构造阻抗矩阵 [Z] (电位系数矩阵)
    % 计算所有匹配点之间的距离矩阵 (向量化提高速度)
    [XC1, XC2] = meshgrid(xc, xc);
    [YC1, YC2] = meshgrid(yc, yc);
    R = sqrt((XC1 - XC2).^2 + (YC1 - YC2).^2);
    
    % 计算非对角元 (点电荷近似)
    Z = (1 / (4 * pi * eps0)) * (ds ./ R);
    
    % 计算并替换对角元 (自区解析积分，消除奇异点)
    self_term = (delta / (2 * pi * eps0)) * log(1 + sqrt(2));
    Z(1:M+1:end) = self_term; 
    
    % 3. 求解面电荷密度与电容
    V_vec = V0 * ones(M, 1);    % 激励电压向量 [V]
    rho_vec = Z \ V_vec;        % 求解 [Z][rho] = [V]
    
    Q_total = sum(rho_vec) * ds; % 总电荷量
    C = Q_total / V0;            % 计算电容 C = Q/U
    
    % 终端输出结果
    fprintf('=== 矩量法计算结果 ===\n');
    fprintf('平板尺寸: %.2f m x %.2f m\n', a, a);
    fprintf('网格数量: %d x %d = %d 个面元\n', N, N, M);
    fprintf('计算电容: C = %.4e F (约 %.2f pF)\n', C, C * 1e12);
    fprintf('======================\n');
    
    % 4. 结果可视化 (电荷密度分布)
    rho_matrix = reshape(rho_vec, N, N); % 重新还原为 NxN 矩阵以便绘图
    
    figure('Name', '矩量法求解极板面电荷密度', 'Position', [100, 100, 700, 500]);
    surf(X, Y, rho_matrix);
    shading interp;     % 平滑着色
    colormap jet; colorbar;
    title(sprintf('正方形导体平板面电荷密度分布 (电容 C = %.2f pF)', C * 1e12));
    xlabel('x (m)'); ylabel('y (m)'); zlabel('面电荷密度 \rho_s (C/m^2)');
    view(-35, 45); grid on;
end