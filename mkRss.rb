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

  def genRss
    doc = Nokogiri::HTML(open(@x))
    agent = Mechanize.new
    rss = RSS::Maker.make("1.0") {|maker|
      xss = maker.xml_stylesheets.new_xml_stylesheet
      xss.href = "./rss.css"

      maker.channel.about = "htt://example.com/hass/rss.xml"
      maker.channel.title = "ハローワーク本日の新着"
      maker.channel.description = "HelloWorkAutoSerchSystem"
      maker.channel.link = "https://www.hellowork.go.jp/"
  
      maker.items.do_sort = true

      (0..doc.xpath("//table[1]/tr/td[2]").length - 1).each{|j|
        id = doc.xpath("//table[1]/tr/td[2]/a")[j].text.gsubs
        name = doc.xpath("//table[1]/tr/td[3]")[j].text.gsubs
        url = doc.xpath("//table[1]/tr/td[2]/a")[j]["href"].gsubs
        page = agent.get(url)
        desc = agent.page.at("table").inner_html
        point = doc.xpath("//table[1]/tr/td[7]")[j].text.gsubs
        date = doc.xpath("//table[1]/tr/td[8]")[j].text.dsub.gsubs
        item = maker.items.new_item
        item.title = id + " " +  name
        item.link = url
        item.dc_subject = name + "  就業場所: " + point
        item.description = desc
        item.date = date.to_s
      }
    }
    rss.to_s
  end
end
