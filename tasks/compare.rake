require "celluloid"

Celluloid.logger.level = Logger::ERROR

class Array
  def avg
    inject(0, :+).to_f / size
  end
end

class Sender
  include Celluloid

  def call(object, method, *args, &block)
    object.send(method, *args, &block)
  end
end

QUERIES = ["Love", "Student", "Family", "Life", "Partner"]

task :compare do
  puts "Warmup..."
  5.times { query; sleep 1 }

  puts "Query..."
  query
end

def query
  sender = Sender.pool(size: 20)

  $engines.each do |engine|
    query_times = QUERIES.each_with_object([]) do |query, query_times|
      100.times do
        query_times << sender.future(:call, engine, :search, query)
      end
    end
    puts "%.2f" % query_times.map(&:value).avg
  end
end
