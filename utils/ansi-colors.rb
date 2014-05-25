#!/usr/bin/ruby
# ansi-colors.rb
# description: Prints out a 16x16 grid of ANSI colors

CSI = "\x1b["
RESET = "#{CSI}0m"

((40..47).to_a + (100..107).to_a).each do |bg|
  line = "#{RESET} %03d " % [bg]
  ((30..37).to_a + (90..97).to_a).each do |fg|
    line << "#{CSI}#{bg};#{fg}m%03d " % [fg]
  end
  puts line
end

