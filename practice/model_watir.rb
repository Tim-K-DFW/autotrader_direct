require 'mechanize'
require 'watir-webdriver'
require 'pry'

INITIAL_PAGE = 'http://www.autotrader.com/'

MAKE_SELECT_FIELD = 'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu'

FORM_DATA = { 'fyc' => 'true',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu' => 'DODGE',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageModel-selectOneMenu' => '',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepagePrice-selectOneMenu' => '',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-j_id_1_ad_1e' => '',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_33-make_input' => '',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_3s-vehicleStyle_input' => '',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_4b-j_id_1_ad_4h-minPrice-selectOneMenu' => '',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_4b-j_id_1_ad_4v-maxPrice-selectOneMenu' => '',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_6d-flyoutZip' => 'dcKl17RDHDFDQ3+4q/CNtAsxM68Krll06uu11RQLbmtRP5jH',
              'j_id_1_ac-j_id_1_ad_1_SUBMIT' => '1',
              'javax.faces.ViewState' => 'PUYmpdPQScQr097zgaS/Y8Ww7jfVT5eLuHA/g7WDv4IHFS+i',
              'javax.faces.behavior.event' => 'valueChange',
              'org.richfaces.ajax.component' => 'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu',
              'AJAX:EVENTS_COUNT' => '1',
              'javax.faces.partial.event' => 'change',
              'javax.faces.source' => 'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu',
              'javax.faces.partial.ajax' => 'true',
              'javax.faces.partial.execute' => '@component',
              'javax.faces.partial.render' => '@component',
              'j_id_1_ac-j_id_1_ad_1' => 'j_id_1_ac-j_id_1_ad_1' }


HEADERS = { 'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Encoding' => 'gzip, deflate',
            'Accept-Language' => 'en-US,en;q=0.8,ru;q=0.6',
            'Connection' => 'keep-alive',
            'Content-Length' => '1285',
            'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
            'Faces-Request' => 'partial/ajax',
            'Host' => 'www.autotrader.com',
            'Origin' => 'http://www.autotrader.com',
            'Referer' => 'http://www.autotrader.com/',
            'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36' }


# MODEL_HANDLE = '#j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageModel'
MODEL_HANDLE = '#j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageModel-selectOneMenu'
MODEL_HANDLE2 = '.atcui-selectOneMenu-styled'

# mech = Mechanize.new
# url = INITIAL_PAGE
# test = mech.post(url, FORM_DATA, HEADERS)


b = Watir::Browser.new
b.goto INITIAL_PAGE
b.select_list(:id => MAKE_SELECT_FIELD).select 'BMW'

binding.pry