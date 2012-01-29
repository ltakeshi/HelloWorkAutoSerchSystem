#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#参考
# http://d.hatena.ne.jp/otn/20090509/p1
# http://w.livedoor.jp/ruby_mechanize/
# http://d.hatena.ne.jp/kitamomonga/
# http://www.ruby-lang.org/ja/old-man/html/OpenSSL_X509_Store.html

require 'mechanize'
require 'logger'
require 'net/https'
require 'fileutils'
require 'yaml'

FILENAME1 = "out.html"
FILENAME2 = "result.html"

$config = YAML.load_file "config.yaml"

agent = Mechanize.new
#agent.log = Logger.new('hello.log')

# 検索トップページ
page = agent.get("https://www.hellowork.go.jp/servicef/130020.do?action=initDisp&screenId=130020")
agent.user_agent_alias = 'Linux Firefox'

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

# 賃金
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
    if $config["detail"]["koyoKeitai"].nil?
    else
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
    if $config["detail"]["kiboShokushuDetail"].nil?
    else
      form.field_with(:name => 'kiboShokushuDetail'){|list|
        list.value = $config["detail"]["kiboShokushuDetail"]
      }
    end

# フリーワード欄
    if $config["detail"]["freeWordType"] == 0
      form.radiobutton_with(:value => '0',:name => 'freeWordType').check
    else $config["detail"]["freeWordType"] == 1
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
    if $config["detail"]["nyukyoKanou"].nil?
    else
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

# 希望する休日
    if $config["detail"]["kyujitsu"].nil?
    else
    $config["detail"]["kyujitsu"].each {|i|
        form.checkbox_with(:name => 'kyujitsu', :value => "#{i}").check
      }
    end

# 週休二日欄
    if $config["detail"]["shukyuFutsuka"] == 0
      form.radiobutton_with(:value => '0',:name => 'shukyuFutsuka').check
    elsif $config["detail"]["shukyuFutsuka"] == 1
      form.radiobutton_with(:value => '1',:name => 'shukyuFutsuka').check
    elsif $config["detail"]["shukyuFutsuka"] == 2
      form.radiobutton_with(:value => '2',:name => 'shukyuFutsuka').check
    elsif $config["detail"]["shukyuFutsuka"] == 3
      form.radiobutton_with(:value => '3',:name => 'shukyuFutsuka').check
    else $config["detail"]["shukyuFutsuka"] == 4
      form.radiobutton_with(:value => '4',:name => 'shukyuFutsuka').check
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


# 希望する就業時間欄


# 転勤欄


# 免許・資格欄


# 学歴欄


# 経験欄


# 事業所名欄


# 検索ボタン
#  form.click_button(form.button_with(:name => 'commonNextScreen')) # 基本条件の変更



#    form.checkbox_with(:name => 'keiyakuKoshin').check

    form.click_button(form.button_with(:name => 'commonSearch')) # 検索
    puts agent.page.body
  }
end

#10.times{ # 検索結果を10ページ分取得
#  puts "get pages"
#  html_doc = Nokogiri::HTML(agent.page.body)
##  puts html_doc
#  open(FILENAME1,"a"){|f|
#   f.write html_doc.xpath("/html/body/div/div/div[4]/div/form[2]/div[2]/div[2]/table")
#  }
#  agent.page.form_with(:name => 'multiForm2'){|form|
#    form.click_button(form.button_with(:name => 'fwListNaviBtnNext')) # 次へ
#  }
#}

# 生成したHTMLの相対URLを置換
#open(FILENAME1){|f|
#  open(FILENAME2,"w"){|o|
#    while line = f.gets
#      line.gsub!("./130050.do","https://www.hellowork.go.jp/servicef/130050.do")
#      o.puts line
#    end
#  }
#}

#FileUtils.rm(FILENAME1)
