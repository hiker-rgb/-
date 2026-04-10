function V = A_fun1(a, b, V_left, V_right, V_bottom, V_top)
    % A_fun1: 求解矩形金属槽内的电位分布
    % 输入参数:
    %   a - 金属槽宽度 (m)
    %   b - 金属槽高度 (m)
    %   V_left - 左边电位 (V)
    %   V_right - 右边电位 (V)
    %   V_bottom - 底边电位 (V)
    %   V_top - 顶边电位 (V)
    % 输出:
    %   V - 电位分布矩阵
    
    % 离散化参数
    Nx = 100;      % x方向网格点数
    Ny = 100;      % y方向网格点数
    N_terms = 100; % 级数项数
    
    % 创建网格
    x = linspace(0, a, Nx);
    y = linspace(0, b, Ny);
    [X, Y] = meshgrid(x, y);
    
    % 初始化电位分布
    V = zeros(Ny, Nx);
    
    % 求解左边边界条件 (x=0, V=V_left)
    for n = 1:N_terms
        beta = n * pi / b;
        Cn = 2 * V_left * (1 - (-1)^n) / (n * pi);
        V = V + Cn * sinh(beta * (a - X)) .* sin(beta * Y) / sinh(beta * a);
    end
    
    % 求解右边边界条件 (x=a, V=V_right)
    for n = 1:N_terms
        beta = n * pi / b;
        Cn = 2 * V_right * (1 - (-1)^n) / (n * pi);
        V = V + Cn * sinh(beta * X) .* sin(beta * Y) / sinh(beta * a);
    end
    
    % 求解底边边界条件 (y=0, V=V_bottom)
    for n = 1:N_terms
        beta = n * pi / a;
        Cn = 2 * V_bottom * (1 - (-1)^n) / (n * pi);
        V = V + Cn * sinh(beta * (b - Y)) .* sin(beta * X) / sinh(beta * b);
    end
    
    % 求解顶边边界条件 (y=b, V=V_top)
    for n = 1:N_terms
        beta = n * pi / a;
        Cn = 2 * V_top * (1 - (-1)^n) / (n * pi);
        V = V + Cn * sinh(beta * Y) .* sin(beta * X) / sinh(beta * b);
    end
    
    % 绘制二维热力图
    figure('Position', [100, 100, 800, 700]);  % 增加图形高度
    
    % 绘制图像
    imagesc(x, y, V);
    set(gca, 'YDir', 'normal');
    xlabel('x (m)', 'FontSize', 12);
    ylabel('y (m)', 'FontSize', 12);
    
    % 调整标题位置，避免与标注重叠
    title('矩形金属槽内电位分布', 'FontSize', 14, 'FontWeight', 'bold', 'Position', [a/2, b*1.3, 0]);
    
    % 使用更美观的颜色映射
    colormap(jet(256));
    
    cbar = colorbar;
    cbar.Label.String = '电位 (V)';
    cbar.Label.FontSize = 12;
    
    axis equal tight;
    
    % 方法1：调整边界标注位置，增加偏移量
    offset = 0.08;  % 偏移系数，根据图形大小自动调整
    
    % 底边标注 - 放在图形下方
    text(a/2, -b*offset, sprintf('底边: %.1f V', V_bottom), ...
        'HorizontalAlignment', 'center', 'FontSize', 10, ...
        'BackgroundColor', 'white', 'EdgeColor', 'none', 'Margin', 1);
    
    % 顶边标注 - 放在图形上方
    text(a/2, b + b*offset, sprintf('顶边: %.1f V', V_top), ...
        'HorizontalAlignment', 'center', 'FontSize', 10, ...
        'BackgroundColor', 'white', 'EdgeColor', 'none', 'Margin', 1);
    
    % 左边标注 - 放在图形左侧
    text(-a*offset, b/2, sprintf('左边: %.1f V', V_left), ...
        'HorizontalAlignment', 'center', 'FontSize', 10, ...
        'BackgroundColor', 'white', 'EdgeColor', 'none', 'Margin', 1, 'Rotation', 90);
    
    % 右边标注 - 放在图形右侧
    text(a + a*offset, b/2, sprintf('右边: %.1f V', V_right), ...
        'HorizontalAlignment', 'center', 'FontSize', 10, ...
        'BackgroundColor', 'white', 'EdgeColor', 'none', 'Margin', 1, 'Rotation', 90);
    
    % 可选：添加边框显示区域
    hold on;
    plot([0 a a 0 0], [0 0 b b 0], 'k-', 'LineWidth', 1.5);
    hold off;
    
    % 调整坐标轴范围，给标注留出空间
    xlim([-a*0.2, a*1.2]);
    ylim([-b*0.2, b*1.2]);
end