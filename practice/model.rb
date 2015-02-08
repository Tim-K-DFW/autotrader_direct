require 'mechanize'
require 'pry'
INITIAL_PAGE = 'http://www.autotrader.com/'
FORM_DATA = { # 'fyc' => 'true',
              'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu' => 'ACURA',              
              # # 'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-j_id_1_ad_1e' => '75024',
              # # 'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_6d-flyoutZip' => '75024',
              # 'j_id_1_ac-j_id_1_ad_1_SUBMIT' => '1',
              # 'javax.faces.ViewState' => 'pjYFDHXMwdRrvneMrLAnuqPJ09WjJYHa/GSc721wp+7QOoqa',
              # 'javax.faces.behavior.event' => 'valueChange',
              # 'org.richfaces.ajax.component' => 'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu',
              # 'AJAX:EVENTS_COUNT' => '1',
              # 'javax.faces.partial.event' => 'change', 
              # 'javax.faces.source' => 'j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageMake-selectOneMenu',
              # 'javax.faces.partial.ajax' => 'true',
              # 'javax.faces.partial.execute' => '@component',
              # 'javax.faces.partial.render' => '@component',
              # 'j_id_1_ac-j_id_1_ad_1' => 'j_id_1_ac-j_id_1_ad_1'
            }
HEADERS = {# 'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            # 'Accept-Encoding' => 'gzip, deflate',
            # 'Accept-Language' => 'en-US,en;q=0.8,ru;q=0.6',
            # 'Connection' => 'keep-alive',
            # # 'Content-Length' => '1282',
            # 'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
            'Faces-Request' => 'partial/ajax',
            # 'Host' => 'www.autotrader.com',
            # 'Origin' => 'http://www.autotrader.com',
            # 'Referer' => 'http://www.autotrader.com/',
            # 'User-Agent' => 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.99 Safari/537.36',
            # 'Cookie' => 'v1st=B0D79A6184E12E71; ATC_ID=68.203.89.27.1421200603043358; cxp_12_16=tandt; BIRF_Audit=true; BIGipServerwww=1267326986.61475.0000; DCNAME=www-7001.autotrader.com; recommendationType=INV; recommendationSubType=SRP; ATC_USER_ZIP=75024; ATC_USER_RADIUS=10; ADRUM=s=1421614044302&r=http%3A%2F%2Fwww.autotrader.com%2F; bn_inventory=%7Btimestamp%3A1421614095654%2Ctype%3A%22SRP%22%2Ctaste%3A%7Bbc%3A%22any%22%2Cma%3A%22BMW%22%2Cmi%3A%22any%22%2Cmo%3A%22any%22%7D%7D%2C%7Btimestamp%3A1421614053492%2Ctype%3A%22SRP%22%2Ctaste%3A%7Bbc%3A%22any%22%2Cma%3A%22BMW%22%2Cmi%3A%22any%22%2Cmo%3A%225_SERIES%22%7D%7D%2C%7Btimestamp%3A1421613912931%2Ctype%3A%22SRP%22%2Ctaste%3A%7Bbc%3A%22any%22%2Cma%3A%22NISSAN%22%2Cmi%3A%22any%22%2Cmo%3A%22any%22%7D%7D%2C%7Btimestamp%3A1421607804355%2Ctype%3A%22SRP%22%2Ctaste%3A%7Bbc%3A%22any%22%2Cma%3A%22BMW%22%2Cmi%3A%22any%22%2Cmo%3A%22BMW740LDXD%22%7D%7D%2C%7Btimestamp%3A1421607600683%2Ctype%3A%22SRP%22%2Ctaste%3A%7Bbc%3A%22any%22%2Cma%3A%22BMW%22%2Cmi%3A%22any%22%2Cmo%3A%22BMWI8%22%7D%7D; JSESSIONID=39C45128526C3F505DA65F81707252A8; AKSB=s=1421632755748&r=http%3A//www.autotrader.com/; mbox=PC#1421200608217-174727.20_07#1422843060|session#1421632470136-419372#1421635320|check#true#1421633520; ATC_BTC=28%2C50%2C25%2C1%2C2%2C3%2C5%2C11%2C12%2C16%2C6%2C10%2C61%2C53%2C35%2C64%2C65%2C210%2C211%2C232%2C233%2C239%2C268%2C270%2C333%2C354%2C600%2C942%2C943%2C994%2C995%2C1004%2C1092%2C1304%2C1320%2C1397%2C68%2C1399%2C1564%2C1571%2C1630%2C1635%2C1640%2C1644%2C1670%2C1813%2C1816%2C1817%2C1821; ATC_PID=-967510869|216077964394872532&-2001991874|216078003591561968&-1404933367|216078035518993348&502895037|216078250657971517&-56232547|216078288141853759&-1132810714|216137729962261935&-1643346277|216139080229087486&1145372692|216139124229066412&-503035519|216140255486108577&-418799101|216140289523315429&-241800070|216140453614513393&1961035435|216140495208654877&-689776064|216140529851893152&-1813249202|216140919441464478&-1168590506|216140953408067505&270835015|216143347431610633&-593653452|216143378839072993&-345506275|216324707223752636&-1585394174|216324743436754094&-267992908|216334600045278741&-1413529037|216334634676026273; ATC_SID=-967510869|216075961814887582&-2001991874|216078003761857910&-1404933367|216078003761857910&502895037|216078003761857910&-56232547|216078003761857910&-1132810714|-1&-1643346277|216139080353906583&1145372692|216139080353906583&-503035519|216140255562653936&-418799101|216140255562653936&-241800070|-1&1961035435|216140495261584192&-689776064|216140495261584192&-1813249202|216140919559374831&-1168590506|216140919559374831&270835015|216140495261584192&-593653452|216140495261584192&-345506275|-1&-1585394174|-1&-267992908|-1&-1413529037|-1; bn_u=6925490081887506969; dxatc==28,50,25,1,2,3,5,11,12,16,6,10,61,53,35,64,65,210,211,232,233,239,268,270,333,354,600,942,943,994,995,1004,1092,1304,1320,1397,68,1399,1564,1571,1630,1635,1640,1644,1670,1813,1816,1817,1821; heroTest=luxcar=true,midcar=true,conv=true,lux=true; aam_tnt_vin=atc_seg18=92498,atc_seg21=92329,atc_seg24=92330,atc_seg25=93149,atc_seg26=92959,atc_seg27=96938,atc_seg29=92981,atc_seg31=92302,atc_seg35=92331,atc_seg55=751460,atc_seg57=751464,atc_seg60=751468,atc_seg61=751469,atc_seg62=751470,atc_seg63=751471,atc_seg65=751474,atc_seg67=751477,atc_seg71=751482; gdptest=test=and; oam.Flash.RENDERMAP.TOKEN=-8bgvbwc0f'
            }
MODEL_HANDLE = '#j_id_1_ac-j_id_1_ad_1-j_id_1_ad_5-j_id_1_ad_8-j_id_1_ad_f-homepageModel'
MODEL_HANDLE2 = '.atcui-selectOneMenu-styled'
                  

mech = Mechanize.new

url = INITIAL_PAGE
test = mech.post(url, FORM_DATA, HEADERS)


binding.pry