#!/usr/bin/ruby1.9.1
# -*- coding: utf-8 -*-

require 'rss'
require 'nokogiri'
require 'date'

def return_between(unporsed, start, termi)
  unporsed =~ /#{start}(.*?)#{termi}/
  return $1
end

class String
  def gsubs
    return gsub("\r\n","").gsub("\n","").gsub("\t","").gsub("<br>","")
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

doc = Nokogiri::HTML(open("test.html"))

trs = doc.xpath("//tr")

#puts trs

#p trs[1].xpath("td[5]").to_html.gsub("\r\n","").gsub("\n","").gsub("\t","").gsub("<br>","").scan(/<div>.*<\/div/)
#p gsubs(trs[1].xpath("td[5]").to_html).scan(/<div>.*<\/div/)
#p return_between(trs[1].xpath("td[9]").to_html.gsubs,"<div>","</div>").sub("平成","H").sub("年",".").sub("月",".").sub("日","")
 
rss = RSS::Maker.make("1.0") {|maker|
  xss = maker.xml_stylesheets.new_xml_stylesheet
  xss.href = "./rss2.css"

  maker.channel.about = "htt://example.com/hass/rss.xml"
  maker.channel.title = "ハローワーク本日の新着"
  maker.channel.description = "HelloWorkAutoSerchSystem"
  maker.channel.link = "https://www.hellowork.go.jp/"
  
  maker.items.do_sort = true

  id = trs[1].xpath(".//a").to_html.split("\"").last.gsub("\r\n","").gsub("\n","").gsub("\t","").sub(">","").sub("</a>","") 
  name = trs[1].xpath("td[4]").to_html.gsub("\r\n","").gsub("\n","").gsub("\t","").sub(">","").sub("</td","").split(">").last.sub("</div","")
  url = trs[1].xpath(".//a").to_html.split("\"")[5]
  date = Date.parse(return_between(trs[1].xpath("td[9]").to_html.gsubs,"<div>","</div>").sub("平成","H").sub("年",".").sub("月",".").sub("日",""))

  item = maker.items.new_item
  item.title = id + " " +  name
  item.link = url
  item.dc_subject = name
  item.description = return_between(trs[1].xpath("td[5]").to_html.gsubs,"<div>","</div>") + return_between(trs[1].xpath("td[6]").to_html.gsubs,"<div>","</div>") + "\n就業場所: " + return_between(trs[1].xpath("td[8]").to_html.gsubs,"<div>","</div>")
  item.date = date.to_s
}

puts rss.to_s
