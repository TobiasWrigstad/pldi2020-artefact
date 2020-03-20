heap_usage = []
File.foreach "./gc.log" do |line|
  if line['Garbage Collection']
    at_time = line[/\[([0-9\.]*)s\]/, 1].to_f
    from_heap_usage = line[/\(([0-9]*)%\)->/, 1].to_i
    to_heap_usage = line[/->.*\(([0-9]*)%\)/, 1].to_i
    heap_usage << [at_time, from_heap_usage, to_heap_usage]
    next
  end
end

File.open("./heap_usage.specjbb.txt", 'w') do |file|
  file.puts heap_usage
end

puts "Done"
