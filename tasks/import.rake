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
        encode_file("data/#{name}.list")
      end
      File.expand_path("data/#{name}.list")
    end

    private

    def download_file(source, destination)
      system "wget #{File.join(URL, source)} -O #{destination} --quiet --show-progress"
    end

    def unzip_file(filename)
      system "gzip --decompress --force #{filename}"
    end

    def encode_file(filename)
      system "vim #{filename} -c 'set fileencoding=utf-8 | write | quit'"
    end
  end

  class Extractor
    MOVIE_REGEX = /^
      (?<title>.+)                     # Game of Thrones
      \s\((?<year>\d{4})\)             # (1994)
      (\s\{(?<episode_name>.+)         #
       \s\(\#(?<season_number>\d+)     ## {The Watchers on the Wall (#4.5)}
       \.(?<episode_number>\d+)\)\})?  #
    /x

    def self.extract(path, number)
      new.extract(path, number)
    end

    def extract(path, number)
      lines = File.open(path).each_line
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
        title:          match[:title].gsub(/^"|"$/, ""),
        year:           match[:year].to_i,
        plot:           "",
        episode_name:   match[:episode_name],
        episode_number: (Integer(match[:episode_number]) rescue nil),
        season_number:  (Integer(match[:season_number]) rescue nil),
      }
    end
  end
end

task :import do
  puts "Downloading..."

  path = IMDb::Downloader.download("plot")

  puts "Extracting..."

  movies = IMDb::Extractor.extract(path, 1_100)

  puts "Importing..."

  $engines.each do |engine|
    engine.clear
    engine.import(movies)
  end
end
