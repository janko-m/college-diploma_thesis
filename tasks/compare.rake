require "celluloid"

class Searcher
  include Celluloid

  def search(engine, query)
    duration = engine.search(query)
    $query_times[engine.name] << duration
  end
end

class Indexer
  include Celluloid

  def index(engine, record)
    duration = engine.index(record)
    $query_times[engine.name] << duration
  end
end

task :compare do
  $query_times = Hash.new { |h, k| h[k] = Queue.new }
  $index_times = Hash.new { |h, k| h[k] = Queue.new }

  sample_query = {
    simple: "Shawshank",
  }

  searcher_pool = Searcher.pool(size: 20)
  indexer_pool  = Indexer.pool(size: 20)

  engines.each do |engine|
    print "#{engine.name} query... "
    queries = engine.supported_query_types.map { |type| sample_query.fetch(type) }
    queries.each do |query|
      100.times do
        searcher_pool.async.search(engine, )
      end
    end
      query_times = 100.times.map { engine.query(sample_query, limit: 20) }
      query_time = query_times.inject(:+)

    print "#{engine.name}"
  end
end
