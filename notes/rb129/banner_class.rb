class Banner
  def initialize(message, fixed_width = nil)
    if fixed_width && fixed_width < 1
      fixed_width = 1
    end
    message = reformat_wrapped(message, (fixed_width || 78))
    @width = (fixed_width || max_line_length(message))
    @message = message
  end

  def to_s
    [horizontal_rule, empty_line, message_lines, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-#{'-' * @width}-+"
  end

  def max_line_length(message)
    message.map(&:length).max
  end

  def reformat_wrapped(text, width = 78)
    lines = []
    words = text.split(/\s+/)
    line = ''
    words.each do |word|
      if word.length >= width
        unless line.rstrip.empty?
          lines << line.rstrip 
          line = ''
        end
        word_chunks = word.scan(/.{1,#{width}}/)
        word = word_chunks.pop
        lines += word_chunks
      end

      if line.length + word.length >= width
        lines << line.rstrip if line.rstrip.length > 0
        line = "#{word} "
      else
        line << "#{word} "
      end
    end
    lines << line.rstrip if line.length > 0 
    lines << '' if lines.empty?
    lines
  end
  
  def empty_line
    "| #{' ' * @width} |"
  end

  def message_lines
    @message.map do |line|
      "| #{line.center(@width)} |"
    end
  end
end

banner = Banner.new('To boldly go where no one has gone before.', 5)
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+

banner = Banner.new('')
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+

banner = Banner.new("Modify this class so new will optionally let you specify a fixed banner width at the time the Banner object is created. The message in the banner should be centered within the banner of that width. Decide for yourself how you want to handle widths that are either too narrow or too wide.")
puts banner