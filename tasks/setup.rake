task :setup do
  puts "Setting up..."
  $engines.each do |engine|
    engine.setup
  end
end
