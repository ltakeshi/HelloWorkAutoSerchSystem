#!/usr/bin/ruby1.9.1
# -*- coding: utf-8 -*-

require 'optparse'
require 'yaml'

opt = OptionParser.new do |o|
  o.on('-o FILENAME','--output=FILENAME','出力ファイル名を指定'){|filename| $name = filename}
  o.on('-p PageNum','--pages=PageNum','取得するページ数を指定'){|pages| $pageNum = pages}
  o.on('-n Number','--kyusyokuNumber=Number','13桁の求職番号を入力') {|s| $kyusyokuNumber = s}
  o.on('-s KyujinSyurui','--kyujinShurui=KyujinSyurui','求人種類を指定'){|syurui| $kyujinShurui = syurui}
  o.on('-h','--hakenOrUkeoi','派遣・請負を除く'){|h| $hakenOrUkeoi = h}

  begin
    o.parse!
  rescue
    puts "Invalid option. \nsee #{o}"
    exit
  end
end

#p :name => $name

hash = {
  'base' => 
  { 'name' => $name, # -n
    'getPageNum' => $pageNum,# -p
    'kyushokuUmu' => '',
    'kyushokuNumber1' => $kyusyokuNumber.slice(0..4), # -n
    'kyushokuNumber2' => $kyusyokuNumber.slice(5..12),
    'kyujinShurui' => '', # -s
    'hakenOrUkeoi' => '', # -h
    'gekkyuKagen' => '', # -k
    'teate' => '', # -t
    'jikyuKagen' => '', 
    'kiboShokushu' => '',
    'todofuken1' => '',
    'todofuken1_chiku' => '',
    'todofuken2' => '',
    'todofuken2_chiku' => '',
    'todofuken3' => '',
    'todofuken3_chiku' => '',
    'todofuken4' => '',
    'todofuken4_chiku' => '',
    'todofuken5' => '',
    'todofuken5_chiku' => '',
    'nenrei' => '',
    'shinchakuKyujin' => '',
    'kiboSangyo' => '',
    'saishuGakureki' => '',
    'zennendoSotsugyo' => '',
  },
  'detail' =>
  {
    'keiyakuKoshin' => '1',
    'koyoKeitai' => ['1','2','3'],
    'keiyakuKoshin' => '',
    'myCarTsukin' => '',
    'kiboShokushuDetail' => '',
    'freeWordType' => '',
    'freeWord' => '',
    'freeWordRuigigo' => '',
    'kanyuHoken' => '',
    'sumikomi' => '',
    'nyukyoKanou' => ['1','2'],
    'takujijo' => '',
    'shoyo' => '',
    'kiboSangyoDetail' => '',
    'kyujitsu' => ['1','2','3','4','5','6','7','8','9'],
    'shukyuFutsuka' => '',
    'shoteiRodoNissuKagen' => '',
    'kyujinShurui' => '',
    'shoteiRodoNissuKagen' => '',
    'rdoJkgi' => '',
    'jikangaiHeikin' => '',
    'rdojikangaiHeikin' => '',
    'fulltimeKaishiHH' => '',
    'fulltimeKaishiMM' => '',
    'fulltimeShuryoHH' => '',
    'fulltimeShuryoMM' => '',
    'licenseCheck' => '',
    'license1' => '',
    'license2' => '',
    'license3' => '',
    'gakurekiFumon' => '',
    'keikenFumon' => '',
    'jigyoshomei' => '',
  }
}

yaml = YAML.load(hash.to_yaml)

p yaml["base"]["kyushokuNumber1"]
p yaml["base"]["kyushokuNumber2"]
#p yaml["base"]
