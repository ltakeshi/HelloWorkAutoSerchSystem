#!/usr/bin/ruby1.9.1

class CheckConfig
  def initialize(x,y)
    @x, @y = x, y
  end

  def to_s
    "(#@x,#@y)"
  end

  def checkShokushu
    if (@x == 'A' && @y.to_i.between?( 1,20)) ||
       (@x == 'B' && @y.to_i.between?(21,24)) || 
       (@x == 'C' && @y.to_i.between?(25,31)) || 
       (@x == 'D' && @y.to_i.between?(32,33)) || 
       (@x == 'E' && @y.to_i.between?(34,39)) || 
       (@x == 'F' && @y.to_i.between?(40,42)) || 
       (@x == 'G' && @y.to_i.between?(43,45)) || 
       (@x == 'H' && @y.to_i.between?(46,50)) || 
       (@x == 'I' && @y.to_i.between?(51,80))
      return 1
    else
      return 0
    end
  end

  def checkSangyo
    if (@x == 'A' && @y.to_i.between?( 1, 2)) ||
       (@x == 'B' && @y.to_i.between?( 3, 4)) ||
       (@x == 'C' && @y.to_i == 5) ||
       (@x == 'D' && @y.to_i.between?( 6, 8)) ||
       (@x == 'E' && @y.to_i.between?( 9,32)) ||
       (@x == 'F' && @y.to_i.between?(33,36)) ||
       (@x == 'G' && @y.to_i.between?(37,41)) ||
       (@x == 'H' && @y.to_i.between?(42,49)) ||
       (@x == 'I' && @y.to_i.between?(50,61)) ||
       (@x == 'J' && @y.to_i.between?(62,67)) ||
       (@x == 'K' && @y.to_i.between?(68,70)) ||
       (@x == 'L' && @y.to_i.between?(71,74)) ||
       (@x == 'M' && @y.to_i.between?(75,77)) ||
       (@x == 'N' && @y.to_i.between?(78,80)) ||
       (@x == 'O' && @y.to_i.between?(81,82)) ||
       (@x == 'P' && @y.to_i.between?(83,85)) ||
       (@x == 'Q' && @y.to_i.between?(86,87)) ||
       (@x == 'R' && @y.to_i.between?(88,96)) ||
       (@x == 'S' && @y.to_i.between?(97,98)) ||
       (@x == 'T' && @y.to_i == 99)
      return 1
    else
      return 0
    end
  end
end
