# from http://github.com/ng/paperclip-watermarking-app
# with modifications from http://exviva.posterous.com/watermarking-images-with-rails-3-and-papercli
# and even more modifications to ensure works with paperclip >= 2.3.8 and rails >= 3
#
# Note: In rails 3 paperclip processors are not automatically loaded.
# You must add the following above your model class definition:
#
# require 'paperclip_processors/watermark'

module Paperclip
  class Watermark < Thumbnail
    # Handles watermarking of images that are uploaded.
    attr_accessor :watermark_path, :overlay, :position

    def initialize file, options = {}, attachment = nil
      super
      
      @watermark_path   = options[:watermark_path]
      @position         = options[:position].nil? ? "SouthEast" : options[:position]
      @overlay          = options[:overlay].nil? ? true : false
    end

    # TODO: extend watermark

    # Performs the conversion of the +file+ into a watermark. Returns the Tempfile
    # that contains the new image.
    def make
      dst = super

      if watermark_path
        command = "composite"
        params = %W[-gravity #{@position} #{watermark_path} #{tofile(dst)}]
        params << tofile(dst)
        begin
          success = Paperclip.run(command, params.flatten.compact.collect{|e| "'#{e}'"}.join(" "))
        rescue Paperclip::Errors::CommandNotFoundError
          raise Paperclip::Errors::CommandNotFoundError, "There was an error processing the watermark for #{@basename}" if @whiny
        end
      end

      dst
    end

    def tofile(destination)
      [@format, File.expand_path(destination.path)].compact.join(':')
    end
  end
end
