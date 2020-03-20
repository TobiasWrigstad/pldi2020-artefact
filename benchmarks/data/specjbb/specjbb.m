if nargin == 0
    loop_total = 5;
else
    args = argv();
    loop_total = str2num(args{1});
end
bms = {"specjbb"};
pkg load statistics;
db = [];
labels = {};
for i = 0:18
    labels{i+1} = int2str(i);
end

image_path = sprintf("%s/../images/evaluation", fileparts(mfilename('fullpath')));
set (0, "defaultaxesfontname", "Helvetica")
for bm_index = 1:rows(bms)
    bm = bms{bm_index}

    throughput = [];
    latency = [];
    for loop_index = 1:loop_total
        raw = importdata(sprintf("%d.txt", loop_index));
        throughput(loop_index, :) = raw(:, 1)';
        latency(loop_index, :) = raw(:, 2)';
    end
    % size(throughput)
    % size(latency)
    % throughput is 10 x 19; each column is one config, each row is one run

    db = throughput;
    1;
    %% throughput
    close all
    subplot(3, 1, 1);
    boxplot(db);
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("Throughput score")
    title(sprintf("%s throughput score (higher is better)", bm), 'Interpreter', 'none')

    subplot(3, 1, 2);
    bootstrap_db = [];
    for db_c = 1:columns(db)
        bootstrap_db(:, db_c) = mean(empirical_rnd(db(:, db_c), rows(db), 10000))';
    end
    % bootstrap_db is 10000 x 19; each column is one config, each row is one run
    bootstrap_mean = mean(bootstrap_db);
    ci = prctile(bootstrap_db, [2.5, 97.5])
    err_low = bootstrap_mean - ci(1, :);
    err_high = ci(2, :) - bootstrap_mean;

    h = errorbar(1:columns(bootstrap_mean), bootstrap_mean, err_low, err_high, '*');
    set(h, "linestyle", "none")
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("Boobstrap mean, CI")

    subplot(3, 1, 3);
    speedup = bootstrap_mean / bootstrap_mean(1);
    speedup = floor(speedup * 100) - 100;
    bar(speedup, 'facecolor', 'g')
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("Normalized to Config 0 (%)")

    xlabel("Config ID")

    set(gcf, 'PaperPosition', [0 0 8 6]);
    set(gcf, 'PaperSize', [8 6]);
    print(1, sprintf("%s/%s_throughput.pdf", image_path, bm), '-dpdf')
    print(1, sprintf("%s/%s_throughput.png", image_path, bm), '-dpng')

    db = latency;
    2;
    %% latency
    close all
    subplot(3, 1, 1);
    boxplot(db);
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("Latency score")
    title(sprintf("%s latency score (higher is better)", bm), 'Interpreter', 'none')

    subplot(3, 1, 2);
    bootstrap_db = [];
    for db_c = 1:columns(db)
        bootstrap_db(:, db_c) = mean(empirical_rnd(db(:, db_c), rows(db), 10000))';
    end
    % bootstrap_db is 10000 x 19; each column is one config, each row is one run
    bootstrap_mean = mean(bootstrap_db);
    ci = prctile(bootstrap_db, [2.5, 97.5]);
    err_low = bootstrap_mean - ci(1, :);
    err_high = ci(2, :) - bootstrap_mean;

    h = errorbar(1:columns(bootstrap_mean), bootstrap_mean, err_low, err_high, '*');
    set(h, "linestyle", "none")
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("Boobstrap mean, CI")

    subplot(3, 1, 3);
    speedup = bootstrap_mean / bootstrap_mean(1);
    speedup = floor(speedup * 100) - 100;
    bar(speedup, 'facecolor', 'g')
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("Normalized to Config 0 (%)")

    xlabel("Config ID")

    set(gcf, 'PaperPosition', [0 0 8 6]);
    set(gcf, 'PaperSize', [8 6]);
    print(1, sprintf("%s/%s_latency.pdf", image_path, bm), '-dpdf')
    print(1, sprintf("%s/%s_latency.png", image_path, bm), '-dpng')

    3;
    close all
    db = importdata(sprintf("heap_usage.specjbb.txt", bm));
    db = reshape(db, 3, rows(db)/3)';
    % interleaving clock_tick
    clock_tick = db(:, 1)'*1000;
    clock_tick = [clock_tick; clock_tick + 1];
    clock_tick = clock_tick(:)/1000/60;
    db(:, 3)'
    heap_usage = [db(:, 2)'; db(:, 3)'];
    heap_usage = heap_usage(:);

    plot(clock_tick, heap_usage, '-*')
    ylabel("Heap usage (%)")
    xlabel("One run  of Config 0: exec time (min)")

    set(gcf, 'PaperPosition', [0 0 8 6]);
    set(gcf, 'PaperSize', [8 6]);
    print(1, sprintf("%s/%s_per_gc.pdf", image_path, bm), '-dpdf')
    print(1, sprintf("%s/%s_per_gc.png", image_path, bm), '-dpng')
end
