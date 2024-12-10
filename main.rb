require "benchmark"

Dir.glob("*-day/*.rb").each do |file|
  require_relative file
end

BENCHMARK_RUNS = 10
STARTING_TEST = 1
ENDING_TEST = 10

def main()
  times = []
  for i in (STARTING_TEST..ENDING_TEST)
    begin
      part = Object.const_get("Solution#{i}").new()
      
      puts "Solution for day #{i} 1st part: #{part.solution}"
      puts "Solution for day #{i} 2nd part: #{part.solution_part2}"
    rescue NameError
      puts "Solution for day #{i} is not implemented yet"
    end
  end

  if BENCHMARK_RUNS > 0
    puts ""
    puts "Time statistics (average in #{BENCHMARK_RUNS} runs)"
    for i in (STARTING_TEST..ENDING_TEST)
      begin       
        time1 = Benchmark.realtime { (1..BENCHMARK_RUNS).each { |_| Object.const_get("Solution#{i}").new().solution } } / BENCHMARK_RUNS
        time2 = Benchmark.realtime { (1..BENCHMARK_RUNS).each { |_| Object.const_get("Solution#{i}").new().solution_part2 } } / BENCHMARK_RUNS
        puts "Task #{i}: 1st part #{(time1 * 1000).round(2)}ms, 2nd part #{(time2 * 1000).round(2)}ms, total #{((time1 + time2) * 1000).round(2)}ms"
      rescue NameError
        # puts "Solution for day #{i} is not implemented yet"
      end
    end
  end
end

main()