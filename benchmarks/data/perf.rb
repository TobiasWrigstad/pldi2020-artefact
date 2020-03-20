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

bm = File.basename(Dir.getwd)
# bm is one of %w(synthetic synthetic_cold ...)

configs = 19
loop_count_max = 31
(2..loop_count_max).each do |loop_count|
  gcs = []
  l1_loads = []
  l1_misses = []
  llc_misses = []
  last_gc = nil

  current_relocate_set_size = []
  relocate_set_sizes = []

  current_hot_percent = []
  hot_percents = []
  File.foreach "./log.total.#{bm}.#{loop_count}.txt" do |line|
    if line['Using The Z Garbage Collector']
      unless last_gc.nil?
        gcs << last_gc

        relocate_set_sizes << median(current_relocate_set_size).to_i
        hot_percents << median(current_hot_percent)

        current_relocate_set_size = []
        current_hot_percent = []
      end
      next
    end
    if line['Garbage Collection']
      last_gc = line[/GC\(([0-9]*)\)/, 1].to_i + 1
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
    if line['Relocating Set']
      current_relocate_set_size << line[/: ([0-9]*)/, 1].to_i
      next
    end
    if line['hot_percentage']
      current_hot_percent << line[/: ([0-9\.]*)/, 1].to_f
      next
    end
  end
  gcs << last_gc
  relocate_set_sizes << median(current_relocate_set_size).to_i
  hot_percents << median(current_hot_percent)

  if gcs.size != configs ||
    l1_loads.size != configs ||
    l1_misses.size != configs ||
    llc_misses.size != configs
    # p configs
    # p gcs.size
    # p l1_loads.size
    # p llc_misses.size
    STDERR.puts "sth went wrong"
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
is_first = true
heap_usage = []
File.foreach "./log.total.#{bm}.#{loop_count_max}.txt" do |line|
  if line['Using The Z Garbage Collector']
    break unless is_first
    is_first = false
    next
  end

  if line['Garbage Collection']
    at_time = line[/^\[([0-9\.]*)s\]/, 1].to_f
    from_heap_usage = line[/\(([0-9]*)%\)->/, 1].to_i
    to_heap_usage = line[/->.*\(([0-9]*)%\)/, 1].to_i
    heap_usage << [at_time, from_heap_usage, to_heap_usage]
    next
  end
end

File.open("./heap_usage.#{bm}.txt", 'w') do |file|
  file.puts heap_usage
end

puts 'Done'
