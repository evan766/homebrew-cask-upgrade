require "bcu/module/pin"

module Bcu
  module Pin
    class Remove
      def process(args, options)
        pin = args[1]
        # TODO: If we used deprecated --pin option, the value is not any more in the args
        pin = options.unpin if pin.nil?

        remove_pin cask:pin
      end

      private

      def remove_pin(cask:, quiet: false)
        unless Pin.pinned.include? cask
          puts "Not pinned: #{Tty.green}#{cask}#{Tty.reset}" unless quiet
          return
        end

        Pin.pinned.delete(cask)

        File.open(PINS_FILE, "w") do |f|
          Pin.pinned.each do |csk|
            f.puts(csk)
          end
        end

        puts "Unpinned: #{Tty.green}#{cask}#{Tty.reset}" unless quiet
      end
    end
  end
end
