module Helper
  UP = [-1, 0]
  RIGHT = [0, 1]
  DOWN = [1, 0]
  LEFT = [0, -1]

  def read_file(file_name)
    lines = []
    File.open(file_name).read.each_line do |line|
      lines << line
    end

    lines
  end

  def pretty_print_matrix(matrix)
    array = matrix.to_a
    column_width = array.flatten.map { |elem| elem.to_s.length }.max
    array.each do |row|
      puts row.map { |elem| elem.to_s.rjust(column_width) }.join
    end
    puts ""
  end

  # graph is a hash, where key is source, and value is an hash of pairs [destination, cost]
  # for example { "A" => { "B" => 1, "C" => 2 } }
  def dijkstra_all_paths(graph, start, skip_paths: false)
    distances = Hash.new(Float::INFINITY)
    distances[start] = 0
    
    if !skip_paths
      paths = Hash.new { |hash, key| hash[key] = [] }
      paths[start] = [[start]]
    end
    # Priority queue implemented as a sorted array
    queue = [[0, start]] # [distance, node]
    
    until queue.empty?
      current_distance, current_node = queue.shift
      
      # If the current distance is greater than the recorded shortest distance, skip
      next if current_distance > distances[current_node]
      
      # Explore neighbors
      graph[current_node].each do |neighbor, weight|
        distance = current_distance + weight
        
        if distance < distances[neighbor]
          # Found a new shortest distance
          distances[neighbor] = distance
          paths[neighbor] = paths[current_node].map { |path| path + [neighbor] } if !skip_paths
          
          # Add to queue
          queue.push([distance, neighbor])
          queue.sort_by!(&:first) # Maintain priority order
        elsif distance == distances[neighbor]
          # Found an alternate shortest path
          paths[neighbor].concat(paths[current_node].map { |path| path + [neighbor] }) if !skip_paths
        end
      end
    end
    
    skip_paths ? { distances: distances } : { distances: distances, paths: paths }
  end
end