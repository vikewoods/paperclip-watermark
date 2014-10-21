module Paperclip
  class Textmark < Processor

    attr_accessor :format, :text, :position, :size, :color, :offset

    def initialize(file, options = {}, attachment = nil)
      super
      @file     = file
      @format   = options[:format]
      @textmark = options[:textmark]
      @text     = @textmark[:text]
      @position = @textmark[:position].nil? ? "SouthEast" : @textmark[:position]
      @offset   = @textmark[:offset].nil? ? "0" : @textmark[:offset]
      @size     = @textmark[:size].nil? ? "14" : @textmark[:size]
      @color    = @textmark[:color].nil? ? "black" : @textmark[:color]

      @current_format = File.extname(@file.path)
      @basename = File.basename(@file.path, @current_format)
    end

    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode

      command = "convert"
      params = "-gravity #{@position} -pointsize #{@size} -fill #{@color} " \
               "-annotate #{@offset} #{@text} #{fromfile} #{tofile(dst)}"

      begin
        success = Paperclip.run(command, params)
      rescue Paperclip::Errors::CommandNotFoundError
        raise Paperclip::Errors::CommandNotFoundError, \
          "There was an error processing the textmark for #{@basename}"
      end

      dst
    end

    def fromfile
      File.expand_path(@file.path)
    end

    def tofile(destination)
      [@format, File.expand_path(destination.path)].compact.join(':')
    end
  end
end
