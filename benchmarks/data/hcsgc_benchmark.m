args = argv();
if nargin == 0
    bms = {
    "synthetic"
    % "synthetic_cold"
    % "connected_component_uk"
    % "maximal_clique_uk"
    % "enwiki"
          };
else
    bms = args;
end
pkg load statistics;
db = [];
labels = {};
for i = 0:18
    labels{i+1} = int2str(i);
end

image_path = sprintf("%s/images/evaluation", fileparts(mfilename('fullpath')));
set (0, "defaultaxesfontname", "FreeHelvetion")
set (0, "defaulttextfontname", "FreeHelvetion")
for bm_index = 1:rows(bms)
    bm = bms{bm_index}

    1;
    %% exec time
    db = [];
    for loop_index = 2:31
        db(:, loop_index-1) = importdata(sprintf("mtime.%s.%d.txt", bm, loop_index));
    end
    db = db';
    % db is 30 x 19; each column is one config, each row is one run

    close all
    subplot(3, 1, 1);
    boxplot(db);
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("Wall-clock time (s)")
    title(bm, 'Interpreter', 'none')

    subplot(3, 1, 2);
    bootstrap_db = [];
    for db_c = 1:columns(db)
        bootstrap_db(:, db_c) = mean(empirical_rnd(db(:, db_c), rows(db), 10000), 1)';
    end
    % bootstrap_db is 10000 x 19; each column is one config, each row is one run
    bootstrap_mean = mean(bootstrap_db, 1);
    ci = prctile(bootstrap_db, [2.5, 97.5]);
    err_low = bootstrap_mean - ci(1, :);
    err_high = ci(2, :) - bootstrap_mean;

    h = errorbar(1:columns(bootstrap_mean), bootstrap_mean, err_low, err_high, '*');
    set(h, "linestyle", "none")
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("Mean estimate and CI (s)")

    subplot(3, 1, 3);
    speedup = bootstrap_mean / bootstrap_mean(1)
    speedup = floor(speedup * 100) - 100;
    bar(speedup, 'facecolor', 'g')
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("Normalized to Config 0 (%)")

    xlabel("Config ID")

    set(gcf, 'PaperPosition', [0 0 8 6]);
    set(gcf, 'PaperSize', [8 6]);
    print(1, sprintf("%s/%s_mtime.pdf", image_path, bm), '-dpdf')
    print(1, sprintf("%s/%s_mtime.png", image_path, bm), '-dpng')

    2;
    %% perf cache stats
    db = []
    for loop_index = 2:31
        db(:, loop_index-1) = importdata(sprintf("cache.%s.%d.txt", bm, loop_index));
    end
    db = db';
    l1_loads = db(:, 1:19);
    l1_misses = db(:, 20:38);
    llc_misses = db(:, 39:57);
    %% it's unclear to me if we should use l1 hits or total l1 loads; using
    %% total l1 loads for now, since it's proportional to work load
    % l1_loads = l1_loads - l1_misses - llc_misses;

    l1_loads = mean(l1_loads, 1);
    l1_misses = mean(l1_misses, 1);
    llc_misses = mean(llc_misses, 1);

    % 1 x 19; one value for each config

    close all
    speedup = [
        floor(l1_loads / l1_loads(1) * 100) - 100;
        floor(l1_misses / l1_misses(1) * 100) - 100;
        floor(llc_misses / llc_misses(1) * 100) - 100;
    ]';
    size(speedup)
    h = bar(speedup);
    set(h(1), 'facecolor', 'g')
    set(h(2), 'facecolor', 'r')
    set(h(3), 'facecolor', 'b')
    title(bm, 'Interpreter', 'none')
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    h = legend('Total loads', 'L1 misses', 'LLC misses');
    ylabel("Each normalized against config 0 (%)")
    legend(h, 'location', 'northwest')

    xlabel("Config ID")

    set(gcf, 'PaperPosition', [0 0 8 6]);
    set(gcf, 'PaperSize', [8 6]);
    print(1, sprintf("%s/%s_cache.pdf", image_path, bm), '-dpdf')
    print(1, sprintf("%s/%s_cache.png", image_path, bm), '-dpng')

    3;
    %% per_gc stats
    db = [];
    for loop_index = 2:31
        db(:, loop_index-1) = importdata(sprintf("per_gc.%s.%d.txt", bm, loop_index));
    end
    db = db';
    gcs = db(:, 1:19);
    relocate_set_sizes = db(:, 20:38);
    hot_percents = db(:, 39:57);

    gcs = mean(gcs, 1);
    relocate_set_sizes = mean(relocate_set_sizes, 1);
    hot_percents = mean(hot_percents, 1);
    hot_percents = [0, 0, 0, 0, 0, hot_percents(1, 6:end) - hot_percents(6)];
    hot_percents = round(hot_percents);

    close all
    subplot(3, 1, 1);
    bar(gcs, 'facecolor', 'g')
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("#GC cycles")
    title(bm, 'Interpreter', 'none')

    subplot(3, 1, 2);
    bar(relocate_set_sizes, 'facecolor', 'r')
    text(1,1,'N/A','verticalalignment','bottom','horizontalalignment','center');
    set(gca,'XTick', 1:19, 'XTickLabel', labels);
    ylabel("#pages relocated")

    xlabel("Config ID")

    % subplot(3, 1, 3);
    % bar(hot_percents, 'facecolor', 'b')
    % set(gca,'XTick', 1:19, 'XTickLabel', labels);
    % ylabel("hot % diff with config 5")

    db = importdata(sprintf("heap_usage.%s.txt", bm));
    db = reshape(db, 3, rows(db)/3)';
    % interleaving clock_tick
    clock_tick = db(:, 1)'*1000;
    clock_tick = [clock_tick; clock_tick + 1];
    clock_tick = clock_tick(:)/1000;

    heap_usage = [db(:, 2)'; db(:, 3)'];
    heap_usage = heap_usage(:);
    subplot(3, 1, 3);
    % bar(hot_percents, 'facecolor', 'b')
    % set(gca,'XTick', 1:19, 'XTickLabel', labels);
    plot(clock_tick, heap_usage, '-*')
    ylabel("Heap usage (%)")
    xlabel("One run  of Config 0: exec time (s)")

    set(gcf, 'PaperPosition', [0 0 8 6]);
    set(gcf, 'PaperSize', [8 6]);
    print(1, sprintf("%s/%s_per_gc.pdf", image_path, bm), '-dpdf')
    print(1, sprintf("%s/%s_per_gc.png", image_path, bm), '-dpng')
end
