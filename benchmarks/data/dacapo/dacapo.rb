def mean(arr)
  return 0 if arr.empty?
  arr.reduce(:+) / arr.size
end

def median(array)
  return 0 if array.empty?
  # p array
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

configs = 19
iterations = 25

bm = File.basename(Dir.getwd)
unless %w(h2 tradebeans).include? bm
  raise "BM '#{bm}' not found"
end

loop_count_max = 1
(1..10).reverse_each do |loop_count|
  if (File.exist?("./log.total.#{bm}.#{loop_count}.txt"))
    p loop_count_max = loop_count
    break
  end
end

(1..loop_count_max).each do |loop_count|
  i = 0
  gcs = Array.new(configs * iterations, 0)

  l1_loads = []
  l1_misses = []
  llc_misses = []

  durations = []
  in_scope = false

  current_relocate_set_size = []
  relocate_set_sizes = []

  current_hot_percent = []
  hot_percents = []

  File.foreach "./log.total.#{bm}.#{loop_count}.txt" do |line|
    if line[0] == '=' && line['starting']
      in_scope = true
      current_relocate_set_size = []
      current_hot_percent = []
      next
    end
    if in_scope
      if line['Garbage Collection']
        gcs[i] += 1
        next
      end
      if line['Relocating Set']
        current_relocate_set_size << line[/: ([0-9]*)/, 1].to_i
        next
      end
      if line['hot_percentage']
        current_hot_percent << line[/: ([0-9\.]*)/, 1].to_f
        next
      end
    end
    if line[0] == '=' && (line['completed'] || line['PASSED'] || line['FAILED'])
      duration = line[/([0-9]*) msec/, 1]
      if duration.nil?
        STDERR.puts "contains failed iteration"
        duration = durations.last
      else
        duration = duration.to_i
      end
      durations << duration
      relocate_set_sizes << median(current_relocate_set_size)
      hot_percents << median(current_hot_percent)
      in_scope = false
      i += 1
      next
    end
    if line['L1-dcache-loads']
      l1_loads << line[/([0-9,]*) *L1-dcache-loads/, 1].gsub(',', '').to_i
      next
    end
    if line['L1-dcache-load-misses']
      l1_misses << line[/([0-9,]*) *L1-dcache-load-misses/, 1].gsub(',', '').to_i
      next
    end
    if line['LLC-load-misses']
      llc_misses << line[/([0-9,]*) *LLC-load-misses/, 1].gsub(',', '').to_i
      next
    end
  end

  if [durations, gcs, relocate_set_sizes, hot_percents].map(&:size).uniq.count != 1 ||
      durations.size != configs * iterations
    p durations.size
    p gcs.size
    p relocate_set_sizes.size
    p hot_percents.size
    STDERR.puts "sth went wrong"
  end

  File.open("./mtime.#{bm}.#{loop_count}.txt", 'w') do |file|
    file.puts durations
  end

  File.open("./cache.#{bm}.#{loop_count}.txt", 'w') do |file|
    file.puts l1_loads
    file.puts l1_misses
    file.puts llc_misses
  end

  File.open("./per_gc.#{bm}.#{loop_count}.txt", 'w') do |file|
    file.puts gcs
    file.puts relocate_set_sizes
    file.puts hot_percents
  end
end

# heap usage
heap_usage = []
capture = false
File.foreach "./log.total.#{bm}.#{loop_count_max}.txt" do |line|
    if line['starting =====']
      capture = true
      next
    end

    if capture && line['Garbage Collection']
      at_time = line[/\[([0-9\.]*)s\]/, 1].to_f
      from_heap_usage = line[/\(([0-9]*)%\)->/, 1].to_i
      to_heap_usage = line[/->.*\(([0-9]*)%\)/, 1].to_i
      heap_usage << [at_time, from_heap_usage, to_heap_usage]
      next
    end

    if line['PASSED']
      break
    end
end

File.open("./heap_usage.#{bm}.txt", 'w') do |file|
  file.puts heap_usage
end

puts "Done"
