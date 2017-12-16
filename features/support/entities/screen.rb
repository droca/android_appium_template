module Entities

  class Screen

    attr_accessor :width, :height

    def initialize()
      self.width
      self.height
    end

    #
    # Gets the device screen witdh and returs it as Integer
    #
    def width
      @width ||= size.last.split('x').first.strip!.to_i
    end

    #
    # Gets the device screen height and returs it as Integer
    #
    def height
      @height ||= size.last.split('x').last.strip!.to_i
    end

    private

      def size
        # With the following parsing, We are assuming this command will return something like 'Physical size: 1080x1920'
        @size ||= `adb shell wm size`.split(':')
      end

  end

end
