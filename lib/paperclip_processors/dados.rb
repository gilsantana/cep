module Paperclip
  class Dados < Processor

    class InstanceNotGiven < ArgumentError; end


    def initialize(file, options = {})
      super
      @file = file
      @instance = options[:instance]
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
    end

    def make
      
    end

  end
end