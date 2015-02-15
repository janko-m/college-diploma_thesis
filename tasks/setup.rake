task :setup do
  $engines.each do |engine|
    engine.setup
  end
end
