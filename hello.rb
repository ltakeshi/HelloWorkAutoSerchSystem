#!/usr/bin/ruby1.9.1
# -*- coding: utf-8 -*-
#参考
# http://d.hatena.ne.jp/otn/20090509/p1
# http://w.livedoor.jp/ruby_mechanize/
# http://d.hatena.ne.jp/kitamomonga/
# http://www.ruby-lang.org/ja/old-man/html/OpenSSL_X509_Store.html

require 'mechanize'
require 'logger'
require 'net/https'
require 'yaml'
require_relative 'checkConfig'
require_relative 'mkRss'


$config = YAML.load_file ARGV[0]

if $config["base"]["name"].nil?
  FILENAME = "result.html"
else
  FILENAME = $config["base"]["name"] + ".html"
end

if $config["base"]["getPageNum"].nil?
  getPageNum = 10
else
  getPageNum = $config["base"]["getPageNum"].to_i
end

agent = Mechanize.new

#agent.log = Logger.new('hello.log')

# 検索トップページ
page = agent.get("https://www.hellowork.go.jp/servicef/130020.do?action=initDisp&screenId=130020")
agent.user_agent_alias = 'Windows IE 7'

# 検索ページ
agent.page.form_with(:name => 'mainForm'){|form|

# 求職登録有無
  if $config["base"]["kyushokuUmu"] == 1
    form.radiobuttons_with(:name => 'kyushokuUmu')[0].check
    form['kyushokuNumber1'] = $config["base"]["kyushokuNumber1"]
    form['kyushokuNumber2'] = $config["base"]["kyushokuNumber2"]
  else
    form.radiobuttons_with(:name => 'kyushokuUmu')[1].check
  end

# 求人情報の種類
  if $config["base"]["kyujinShurui"] == 1
    form.radiobutton_with(:value => '1',:name => 'kyujinShurui').check
  elsif $config["base"]["kyujinShurui"] == 2
    form.radiobutton_with(:value => '2',:name => 'kyujinShurui').check
  else
    form.radiobutton_with(:value => '3',:name => 'kyujinShurui').check
  end

# 派遣・請負
  if $config["base"]["hakenOrUkeoi"] == 1
    form.checkbox_with(:text => /派遣・請負を除く/).check
  end

# 賃金 (一部未実装)
# 時給と月給or時給の場合分け
  form['gekkyuKagen'] = $config["base"]["gekkyuKagen"]
  if $config["base"]["kyujinShurui"] == 2
    form.checkbox_with(:text => /手当等を含む/).uncheck
  elsif $config["base"]["teate"] == 1
    form.checkbox_with(:text => /手当等を含む/).check
  end

# 希望する職種
  form.field_with(:name => 'kiboShokushu'){|list|
    list.value = $config["base"]["kiboShokushu"]
  }

# 都道府県／市区町村名
  form.field_with(:name => 'todofuken1'){|list|
    list.value = $config["base"]["todofuken1"]
  }
  form['chiku1'] = $config["base"]["todofuken1_chiku"]

  form.field_with(:name => 'todofuken2'){|list|
    list.value = $config["base"]["todofuken2"]
  }
  form['chiku2'] = $config["base"]["todofuken2_chiku"]

  form.field_with(:name => 'todofuken3'){|list|
    list.value = $config["base"]["todofuken3"]
  }
  form['chiku3'] = $config["base"]["todofuken3_chiku"]

  form.field_with(:name => 'todofuken4'){|list|
    list.value = $config["base"]["todofuken4"]
  }
  form['chiku4'] = $config["base"]["todofuken4_chiku"]

  form.field_with(:name => 'todofuken5'){|list|
    list.value = $config["base"]["todofuken5"]
  }
  form['chiku5'] = $config["base"]["todofuken5_chiku"]

# 年齢
  form['nenrei'] = $config["base"]["nenrei"]

# 新着求人
  if $config["base"]["shinchakuKyujin"] == 1
    form.checkbox_with(:text => /最新の求人情報から検索する/).check
  end

# 希望する産業
  form.field_with(:name => 'kiboSangyo'){|list|
    list.value = $config["base"]["kiboSangyo"]
  }

# 検索ボタン
  if $config["base"]["syousai"] == 1
    form.click_button(form.button_with(:name => 'commonNextScreen')) # 詳細条件入力
  else
    form.click_button(form.button_with(:name => 'commonSearch')) # 検索
  end
#  puts agent.page.body
}

if $config["base"]["syousai"] == 1
# 詳細条件入力のページ
  agent.page.form_with(:name => 'mainForm'){|form|

# 雇用形態欄
    unless $config["detail"]["koyoKeitai"].nil?
      $config["detail"]["koyoKeitai"].each {|i|
        form.checkbox_with(:name => 'koyoKeitai', :value => "#{i}").check
      }
    end

# 契約更新の可能性欄
    if $config["detail"]["keiyakuKoshin"] == 1
      form.checkbox_with(:name => 'keiyakuKoshin').check
    end

# マイカー通勤欄
    if $config["detail"]["myCarTsukin"] == 1
      form.checkbox_with(:name => 'myCarTsukin').check
    end

# 希望する職種(詳細)欄
    unless $config["detail"]["kiboShokushuDetail"].nil?
      if CheckConfig.new($config["base"]["kiboShokushu"],$config["detail"]["kiboShokushuDetail"]).checkShokushu == 1
        unless $config["detail"]["kiboShokushuDetail"].nil?
          form.field_with(:name => 'kiboShokushuDetail'){|list|
            list.value = $config["detail"]["kiboShokushuDetail"]
          }
        end
      else
       puts "設定ファイル整合性エラー"
        puts "希望する職種と希望する職種(詳細)が一致しません。"
        exit
      end
    end  

# フリーワード欄
    if $config["detail"]["freeWordType"] == 0
      form.radiobutton_with(:value => '0',:name => 'freeWordType').check
    else
      form.radiobutton_with(:value => '1',:name => 'freeWordType').check
    end
    
    form["freeWord"] = $config["detail"]["freeWord"]

    if $config["detail"]["freeWordRuigigo"] == 1
      form.checkbox_with(:name => 'freeWordRuigigo').check
    end

# 加入保険欄
    if $config["detail"]["kanyuHoken"] == 1
      form.checkbox_with(:name => 'kanyuHoken').check
    end

# 住込欄
    if $config["detail"]["sumikomi"] == 1
      form.checkbox_with(:name => 'sumikomi').check
    end

# 入居可能住宅欄
    unless $config["detail"]["nyukyoKanou"].nil?
      $config["detail"]["nyukyoKanou"].each {|i|
        form.checkbox_with(:name => 'nyukyoKanou', :value => "#{i}").check
      }
    end

# 利用可能な託児所欄
    if $config["detail"]["takujijo"] == 1
      form.checkbox_with(:name => 'takujijo').check
    end

# 賞与欄
    if $config["detail"]["shoyo"] == 1
      form.checkbox_with(:name => 'shoyo').check
    end

# 希望する産業(詳細)欄
    unless $config["detail"]["kiboSangyoDetail"].nil?
      if CheckConfig.new($config["base"]["kiboSangyo"],$config["detail"]["kiboSangyoDetail"]).checkSangyo == 1
        unless $config["detail"]["kiboSangyoDetail"].nil?
          form.field_with(:name => 'kiboSangyoDetail'){|list|
            list.value = $config["detail"]["kiboSangyoDetail"]
          }
        end
      else
        puts "設定ファイル整合性エラー"
        puts "希望する産業と希望する産業(詳細)が一致しません。"
        exit
      end
    end

# 希望する休日
    unless $config["detail"]["kyujitsu"].nil?
      $config["detail"]["kyujitsu"].each {|i|
        form.checkbox_with(:name => 'kyujitsu', :value => "#{i}").check
      }
    end

# 週休二日欄
    if $config["detail"]["shukyuFutsuka"] == 1
      form.radiobutton_with(:value => '1',:name => 'shukyuFutsuka').check
    elsif $config["detail"]["shukyuFutsuka"] == 2
      form.radiobutton_with(:value => '2',:name => 'shukyuFutsuka').check
    elsif $config["detail"]["shukyuFutsuka"] == 3
      form.radiobutton_with(:value => '3',:name => 'shukyuFutsuka').check
    elsif $config["detail"]["shukyuFutsuka"] == 4
      form.radiobutton_with(:value => '4',:name => 'shukyuFutsuka').check
    else 
      form.radiobutton_with(:value => '0',:name => 'shukyuFutsuka').check
    end
    
# 年間休日数欄
    if $config["base"]["kyujinShurui"] == 1 or $config["base"]["kyujinShurui"] == 3
      form["nenkanKyujitsu"] = $config["detail"]["nenkanKyujitsu"]
    end

# 週所定労働日数欄
    if $config["base"]["kyujinShurui"] == 2
      form["shoteiRodoNissuKagen"] = $config["detail"]["shoteiRodoNissuKagen"]
    end

# 時間外欄
    if $config["detail"]["rdoJkgi"] == 1
      form.radiobutton_with(:value => '1',:name => 'rdoJkgi').check
      form["jikangaiHeikin"] = $config["detail"]["jikangaiHeikin"]
      if $config["detail"]["jikangaiHeikin"] == 1
        form.radiobutton_with(:value => '1',:name => 'rdojikangaiHeikin').check
      else
        form.radiobutton_with(:value => '0',:name => 'rdojikangaiHeikin').check
      end
    elsif $config["detail"]["rdoJkgi"] == 0
      form.radiobutton_with(:value => '0',:name => 'rdoJkgi').check
    else
      form.radiobutton_with(:value => '9',:name => 'rdoJkgi').check
    end

# 希望する就業時間欄
    unless ($config["detail"]["fulltimeKaishiHH"].nil? or $config["detail"]["fulltimeKaishiMM"].nil? or
            $config["detail"]["fulltimeShuryoHH"].nil? or $config["detail"]["fulltimeShuryoMM"].nil?)
      form['fulltimeKaishiHH'] = $config["detail"]["fulltimeKaishiHH"]
      form['fulltimeKaishiMM'] = $config["detail"]["fulltimeKaishiMM"]
      form['fulltimeShuryoHH'] = $config["detail"]["fulltimeShuryoHH"]
      form['fulltimeShuryoMM'] = $config["detail"]["fulltimeShuryoMM"]
    end

# 転勤欄
    if $config["detail"]["tenkin"] == 0
      form.radiobutton_with(:value => '0',:name => 'tenkin').check
    end

# 免許・資格欄
    if $config["detail"]["licenseCheck"] == 1
      form.radiobutton_with(:value => '1',:name => 'licenseCheck').check
    elsif !$config["detail"]["license1"].nil?
      form["license1"] = $config["detail"]["license1"]
    elsif !$config["detail"]["license2"].nil?
      form["license2"] = $config["detail"]["license2"]
    else !$config["detail"]["license3"].nil?
      form["license3"] = $config["detail"]["license3"]
    end

# 学歴欄
    if $config["detail"]["gakurekiFumon"] == 1
      form.checkbox_with(:value => '1',:name => 'gakurekiFumon').check
    end
    
# 経験欄
    if $config["detail"]["keikenFumon"] == 1
      form.checkbox_with(:value => '1',:name => 'keikenFumon').check
    end

# 事業所名欄
    form['jigyoshomei'] = $config["detail"]["jigyoshomei"]

# 検索ボタン
    form.click_button(form.button_with(:name => 'commonSearch')) # 検索
#    puts agent.page.body
  }
end

html_doc = Nokogiri::HTML(agent.page.body)
#取得したHTMLの検索結果に``ご希望の条件に合致する情報は見つかりませんでした。"と表示された場合の処理
searchError = (html_doc.xpath("/html/body/div/div/div[4]/div/div/p"))
#p searchError
if searchError.to_s =~ /ご希望の条件に合致する情報は見つかりませんでした。/
  puts "ご希望の条件に合致する情報は見つかりませんでした。"
  exit
end

pageNum = (html_doc.xpath("/html/body/div/div/div[4]/div/form[2]/div[2]/div/p").first.to_s.gsub(/\302\240/," ").split[2].to_f / 20).ceil

# 検索結果を取得、HTMLを生成
#  puts (i+1).to_s + " page get"
html_doc = Nokogiri::HTML(agent.page.body)
builder = Nokogiri::HTML::Builder.new(:encoding => 'UTF-8'){
  html{
    head{
      link(:rel => "stylesheet",:type => "text/css",:href => "html.css")
      title "検索結果"
    }
    body{
      table{
        tr{
          th "NO" 
          th "求人番号"
          th "職種"
          th "雇用形態/賃金(税込)"
          th "就業時間/休日/週休二日"
          th "産業"
          th "沿線/就業場所"
          th "受理日"
        }
        [getPageNum,pageNum].min.times{
          (2..html_doc.xpath("//div[2]/table/tr").length).each{|j|
            tr{
              url = html_doc.xpath("//table/tr[#{j}]/td[3]/a")[0]["href"].sub("./","https://www.hellowork.go.jp/servicef/")
              td html_doc.xpath("//table/tr[#{j}]/td[2]")[0].text.gsubs
              td {
                a(:href => url, :target => "_blank") {text html_doc.xpath("//table/tr[#{j}]/td[3]")[0].text.gsubs}
              }
              td html_doc.xpath("//table/tr[#{j}]/td[4]")[0].text.gsubs
              td html_doc.xpath("//table/tr[#{j}]/td[5]")[0].text.gsubs
              td html_doc.xpath("//table/tr[#{j}]/td[6]")[0].text.gsubs
              td html_doc.xpath("//table/tr[#{j}]/td[7]")[0].text.gsubs
              td html_doc.xpath("//table/tr[#{j}]/td[8]")[0].text.gsubs
              td html_doc.xpath("//table/tr[#{j}]/td[9]")[0].text.gsubs.dsub
            }
          }
          agent.page.form_with(:name => 'multiForm2'){|form|
            form.click_button(form.button_with(:name => 'fwListNaviBtnNext')) # 次へ
          }
          html_doc = Nokogiri::HTML(agent.page.body)
        }
      }
    }
  }
}

if $config["custom"]["rss"] == 1
# RSS生成
  open(FILENAME.sub("html","rdf"),"w"){|o|
    puts "Generate RSS"
    if $config["custom"]["about"] != nil
      about = $config["custom"]["about"]
    else
      about = "http://example.com/rss.rdf"
    end

    rss = MkRss.new(builder.to_html,about).genRss
    o.write rss
  }
else
#HTML出力
  open(FILENAME,"w"){|o|
    o.write builder.to_html
  }
end
