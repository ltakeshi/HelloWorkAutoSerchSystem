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
require 'hpricot'

agent = Mechanize.new
#agent.log = Logger.new('hello.log')

# 検索トップページ
page = agent.get("https://www.hellowork.go.jp/servicef/130020.do?action=initDisp&screenId=130020")
agent.user_agent_alias = 'Linux Firefox'

# 検索ページ
agent.page.form_with(:name => 'mainForm'){|form|
# 求職登録有無
  form.radiobuttons_with(:name => 'kyushokuUmu')[0].check
  form['kyushokuNumber1'] = '34050'
  form['kyushokuNumber2'] = '1437913'
# 求人情報の種類
  form.radiobuttons_with(:name => 'kyujinShurui')[0].check
# 賃金
  form['gekkyuKagen'] = '180000'
  form.checkbox_with(:text => /手当等を含む/).check
# 希望する職種
  form.field_with(:name => 'kiboShokushu'){|list|
    list.value = "A"
  }
# 都道府県／市区町村名
  form.field_with(:name => 'todofuken1'){|list|
    list.value = "26" # 京都
  }
  form.field_with(:name => 'todofuken2'){|list|
    list.value = "27" # 大阪
  }
  form.field_with(:name => 'todofuken3'){|list|
    list.value = "28" # 兵庫
  }
  form.field_with(:name => 'todofuken4'){|list|
    list.value = "33" # 岡山
  }
  form.field_with(:name => 'todofuken5'){|list|
    list.value = "34" # 広島
  }
# 年齢
  form['nenrei'] = '26'
# 希望する産業
  form.field_with(:name => 'kiboSangyo'){|list|
    list.value = "G"
  }

# 検索ボタン
  form.click_button(form.button_with(:name => 'commonNextScreen')) # 詳細条件入力
#  form.click_button(form.button_with(:name => 'commonSearch')) # 検索

}

# 詳細条件入力のページ
agent.page.form_with(:name => 'mainForm'){|form|

# 検索ボタン
#  form.click_button(form.button_with(:name => 'commonNextScreen')) # 基本条件の変更
  form.click_button(form.button_with(:name => 'commonSearch')) # 検索
}

#puts agent.page.body
html_doc = Nokogiri::HTML(agent.page.body)
puts html_doc.xpath("/html/body/div/div/div[4]/div/form[2]/div[2]/div[2]/table")

#puts html_doc
