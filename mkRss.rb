#!/usr/bin/ruby1.9.1
# -*- coding: utf-8 -*-

require 'rss'
require 'mechanize'
require 'date'

class String
  def gsubs
    return gsub("\r\n","").gsub("\n","").gsub("\t","").gsub("<br>","")
  end
  def dsub
    return sub("平成","H").sub("年",".").sub("月",".").sub("日","")
  end
end

class MkRss
  def initialize(x)
    @x = x
  end

  def to_s
    "#@x"
  end
end

doc = Nokogiri::HTML(open("result.html"))
agent = Mechanize.new
rss = RSS::Maker.make("1.0") {|maker|
  xss = maker.xml_stylesheets.new_xml_stylesheet
  xss.href = "./rss2.css"

  maker.channel.about = "htt://example.com/hass/rss.xml"
  maker.channel.title = "ハローワーク本日の新着"
  maker.channel.description = "HelloWorkAutoSerchSystem"
  maker.channel.link = "https://www.hellowork.go.jp/"
  
  maker.items.do_sort = true

  (1..doc.xpath("//table").length).each{|i|
    (0..doc.xpath("//table[1]/tr/td[4]").length - 1).each{|j|
      id = doc.xpath("//table[#{i}]/tr/td[3]/a")[j].inner_html.gsubs
      name = doc.xpath("//table[#{i}]/tr/td[4]")[j].text.gsubs
      url = doc.xpath("//table[#{i}]/tr/td[3]/a")[j]["href"].gsubs
      point = doc.xpath("//table[#{i}]/tr/td[8]")[j].text.gsubs
      date = doc.xpath("//table[#{i}]/tr/td[9]")[j].text.dsub.gsubs
#      puts id + " " + name  + " " + point + " " + date
#      page = agent.get(url)
      item = maker.items.new_item
      item.title = id + " " +  name
      item.link = url
      item.dc_subject = name
      item.description = "就業場所: " + point
      item.date = date.to_s
    }
  }
}

puts rss.to_s
