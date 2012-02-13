#!/usr/bin/ruby1.9.1

require 'yaml'

class CheckConfig
  def initialize(x,y)
    @x, @y = x, y
  end

  def to_s
    "(#@x,#@y)"
  end

  def checkShokushu
    if (@x == 'A' && @y.to_i >= 1  && @y.to_i <= 20) ||
       (@x == 'B' && @y.to_i >= 21 && @y.to_i <= 24) || 
       (@x == 'C' && @y.to_i >= 25 && @y.to_i <= 31) || 
       (@x == 'D' && @y.to_i >= 32 && @y.to_i <= 33) || 
       (@x == 'E' && @y.to_i >= 34 && @y.to_i <= 39) || 
       (@x == 'F' && @y.to_i >= 40 && @y.to_i <= 42) || 
       (@x == 'G' && @y.to_i >= 43 && @y.to_i <= 45) || 
       (@x == 'H' && @y.to_i >= 46 && @y.to_i <= 50) || 
       (@x == 'I' && @y.to_i >= 51 && @y.to_i <= 80)
      return 1
    else
      return 0
    end
  end

  def checkSangyo
    if (@x == 'A' && @y.to_i >=  1 && @y.to_i <=  2) ||
       (@x == 'B' && @y.to_i >=  3 && @y.to_i <=  4) ||
       (@x == 'C' && @y.to_i == 5) ||
       (@x == 'D' && @y.to_i >=  6 && @y.to_i <=  8) ||
       (@x == 'E' && @y.to_i >=  9 && @y.to_i <= 32) ||
       (@x == 'F' && @y.to_i >= 33 && @y.to_i <= 36) ||
       (@x == 'G' && @y.to_i >= 37 && @y.to_i <= 41) ||
       (@x == 'H' && @y.to_i >= 42 && @y.to_i <= 49) ||
       (@x == 'I' && @y.to_i >= 50 && @y.to_i <= 61) ||
       (@x == 'J' && @y.to_i >= 62 && @y.to_i <= 67) ||
       (@x == 'K' && @y.to_i >= 68 && @y.to_i <= 70) ||
       (@x == 'L' && @y.to_i >= 71 && @y.to_i <= 74) ||
       (@x == 'M' && @y.to_i >= 75 && @y.to_i <= 77) ||
       (@x == 'N' && @y.to_i >= 78 && @y.to_i <= 80) ||
       (@x == 'O' && @y.to_i >= 81 && @y.to_i <= 82) ||
       (@x == 'P' && @y.to_i >= 83 && @y.to_i <= 85) ||
       (@x == 'Q' && @y.to_i >= 86 && @y.to_i <= 87) ||
       (@x == 'R' && @y.to_i >= 88 && @y.to_i <= 96) ||
       (@x == 'S' && @y.to_i >= 97 && @y.to_i <= 98) ||
       (@x == 'T' && @y.to_i == 99)
      return 1
    else
      return 0
    end
  end

end

$config = YAML.load_file ARGV[0]

cShoku = CheckConfig.new($config["base"]["kiboShokushu"], $config["detail"]["kiboShokushuDetail"]).checkShokushu
cSangyo = CheckConfig.new($config["base"]["kiboSangyo"], $config["detail"]["kiboSangyoDetail"])
p cSangyo.to_s.class
puts cSangyo.checkSangyo
