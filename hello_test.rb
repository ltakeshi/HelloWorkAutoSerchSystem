#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'mechanize'
require 'logger'

agent = Mechanize.new
agent.log = Logger.new('hello_test.log')

#検索トップページ
page = agent.get("https://www.hellowork.go.jp/servicef/130020.do?action=initDisp&screenId=130020")
#puts agent.page.title
agent.user_agent_alias = 'Linux Firefox'

agent.page.form_with(:name => 'mainForm'){|form|
#検索ボタン
#  agent.page.forms[0].click_button # 詳細条件入力
#  agent.page.forms[1].click_button # 検索

  puts agent.page.body
}


