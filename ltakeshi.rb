#!/usr/bin/ruby
# -*- coding: utf-8 -*-
#参考
# http://d.hatena.ne.jp/otn/20090509/p1
# http://w.livedoor.jp/ruby_mechanize/
# http://d.hatena.ne.jp/kitamomonga/
# http://www.ruby-lang.org/ja/old-man/html/OpenSSL_X509_Store.html

require 'mechanize'
require 'logger'

agent = Mechanize.new
agent.log = Logger.new('ltakeshi.log')

#検索トップページ
page = agent.get("http://ltakeshi.no-ip.info/~takeshi/test.html")
#puts agent.page.title
agent.user_agent_alias = 'Linux Firefox'

agent.page.form_with(:name => 'mainForm'){|form|
#テキストフォーム
  form['string'] = '180000'

#ラジオボタン
  form.radiobuttons_with(:name => 'q1')[0].check
#チェックボックス
  form.checkbox_with(:text => /その1/).check
#セレクトメニュー
  form.field_with(:name => 'select'){|list|
    list.value = "サンプル1"
  }
  agent.page.forms[0].click_button # 検索

  puts agent.page.body
}

