require "tty-progressbar"

module IMDb
  class Downloader
    MIRROR = "ftp://ftp.fu-berlin.de/pub/misc/movies/database"

    def self.download(name)
      new.download(name)
    end

    def download(name)
      unless File.exists?("data/#{name}.list")
        download_file("#{name}.list.gz", "data/#{name}.list.gz")
        unzip_file("data/#{name}.list.gz")
      end
      File.expand_path("data/#{name}.list")
    end

    private

    def download_file(source, destination)
      system "wget #{File.join(MIRROR, source)} -O #{destination} --quiet --show-progress"
    end

    def unzip_file(filename)
      system "gzip --decompress --force #{filename}"
    end
  end

  class Extractor
    MOVIE_REGEX = /^
      (?<title>.+)\s        # Game of Thrones
      \((?<year>\d{4})\)\s  # (1994)
      (\{(?<episode>.+)\})? # {The Watchers on the Wall (#4.5)}
    /x

    def self.extract(path, number)
      new.extract(path, number)
    end

    def extract(path, number)
      lines = File.open(path, encoding: "iso-8859-1:utf-8").each_line
      lines.next until lines.peek.start_with?("MV: ")

      progress_bar = TTY::ProgressBar.new(":bar :percent", total: number, width: 50, complete: "#")
      number.times.each_with_object([]) do |_, movies|
        movie = extract_movie(lines)
        plot = extract_plots(lines).join("\n\n")
        redo if movie.nil?
        movie[:plot] = plot
        movies << movie
        progress_bar.advance
      end
    end

    private

    def extract_plots(lines)
      plots = []
      until lines.peek.start_with?("------")
        plot = lines.take_while { |line| line.start_with?("PL: ") }
        plots << plot.map! { |line| line.match(/^PL: /).post_match.chomp }.join(" ")
        3.times { lines.next }
      end
      lines.next
      plots
    end

    def extract_movie(lines)
      text = lines.next.match(/^MV: /).post_match
      match = text.match(MOVIE_REGEX)
      lines.next
      return if match.nil?

      {
        title:   match[:title].gsub(/^"|"$/, ""),
        year:    match[:year].to_i,
        episode: match[:episode],
      }
    end
  end
end

task :import do
  puts "Downloading..."

  path = IMDb::Downloader.download("plot")

  puts "Extracting..."

  movies = IMDb::Extractor.extract(path, 10_000)

  puts "Importing..."

  $engines.each do |engine|
    engine.clear
    engine.import(movies)
  end
end
