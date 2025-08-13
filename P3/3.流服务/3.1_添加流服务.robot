*** Settings ***
Library           ../../Python37/Lib/site-packages/RequestsLibrary/
Library           ../../Python37/Lib/site-packages/DatabaseLibrary/
Library           ../../Python37/Lib/site-packages/Selenium2Library/
Library           ../../Python37/Lib/site-packages/MyTest.py
Library           ../../Python37/Lib/site-packages/JSONLibrary/

*** Variables ***
${url}            http://192.168.43.190

*** Test Cases ***
3.1.1 添加RTSP流服务
    ${headers}    create dictionary    Content-Type=application/json
    Comment    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded
    log    测试设备地址为：
    log    ${url}
    log    当没有RTSP流时进行RTSP流服务添加
    ${body_json}    set variable    {"port":"554","httpTunnelPort":8554,"session":"ch01","auth":false,"multicast_enable":false,"multicast_addr":"224.0.0.1","multicast_ttl":127,"multicast_port_min":31000,"multicast_port_max":31004,"name":"111","type":"rtsp","bindAudio":1,"bindNetwork": "eth0"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${body_json}    ${headers}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${msg}    MyTest.To Json    ${msg}
    ${result}    MyTest.To Json    ${result}
    Run Keyword If    ${result}=="ok"    log    用例执行成功，添加RTSP流服务成功
    Run Keyword If    ${result}=="error" and ${msg}=="Only 1CH RTSP streaming service supported"    log    用例执行成功，添加RTSP流服务失败，只能添加一路RTSP流服务
    Run Keyword If    ${result}!="ok" and ${msg}!="Only 1CH RTSP streaming service supported"    fail    用例执行失败，添加RTSP流服务失败：${rep}
    sleep    1
    log    当已存在RTSP流时进行RTSP流服务添加
    ${body_json}    set variable    {"port":"554","httpTunnelPort":8554,"session":"ch01","auth":false,"multicast_enable":false,"multicast_addr":"224.0.0.1","multicast_ttl":127,"multicast_port_min":31000,"multicast_port_max":31004,"name":"111","type":"rtsp","bindAudio":1,"bindNetwork": "eth0"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${body_json}    ${headers}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${msg}    MyTest.To Json    ${msg}
    ${result}    MyTest.To Json    ${result}
    Run Keyword If    ${result}=="error" and ${msg}=="Only 1CH RTSP streaming service supported"    log    用例执行成功，添加RTSP流服务失败，只能添加一路RTSP流服务
    Run Keyword If    ${result}!="ok" and ${msg}!="Only 1CH RTSP streaming service supported"    fail    用例执行失败，添加RTSP流服务失败：${rep}

3.1.2 添加RTMP流服务
    ${headers}    create dictionary    Content-Type=application/json
    Comment    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded
    log    测试设备地址为：
    log    ${url}
    log    添加RTMP流服务
    ${body_json}    set variable    {"address":"rtmp://192.168.0.38/live/222","user":"","password":"","connTimeout":15,"connIntv":3,"name":"222","type":"rtmp","bindAudio":1,"bindNetwork": "eth0"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${body_json}    ${headers}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${msg}    MyTest.To Json    ${msg}
    ${result}    MyTest.To Json    ${result}
    Run Keyword If    ${result}=="ok"    log    用例执行成功，添加RTMP流服务成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加RTMP流服务失败：${rep}

3.1.3 添加SRT流服务
    ${headers}    create dictionary    Content-Type=application/json
    Comment    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded
    log    测试设备地址为：
    log    ${url}
    log    添加SRT流服务
    ${body_json}    set variable    {"connectionMode":"Listener","address":"","listenerPort":1025,"latency":125,"encryption":"0","passphrase":"","bandwidth":25,"payloadSize":1316,"srt_stream_id":"","ts_transport_stream_id":101,"ts_pts_pcr_delay":200,"ts_null_multiple":0,"ts_pcr_period":20,"name":"333","type":"srt","bindAudio":1,"bindNetwork": "eth0"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${body_json}    ${headers}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${msg}    MyTest.To Json    ${msg}
    ${result}    MyTest.To Json    ${result}
    Run Keyword If    ${result}=="ok"    log    用例执行成功，添加SRT流服务成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加SRT流服务失败：${rep}

3.1.4 添加HLS流服务
    ${headers}    create dictionary    Content-Type=application/json
    Comment    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded
    log    测试设备地址为：
    log    ${url}
    log    添加HLS流服务
    ${body_json}    set variable    {"mode":"server","session":"444","segmentTime":5,"maxSegments":5,"media_playlist_url":"","name":"444","type":"hls","bindAudio":1,"bindNetwork": "eth0"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${body_json}    ${headers}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${msg}    MyTest.To Json    ${msg}
    ${result}    MyTest.To Json    ${result}
    Run Keyword If    ${result}=="ok"    log    用例执行成功，添加HLS流服务成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加HLS流服务失败：${rep}

3.1.5 添加TS-UDP流服务
    ${headers}    create dictionary    Content-Type=application/json
    Comment    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded
    log    测试设备地址为：
    log    ${url}
    log    添加UDP流服务
    ${body_json}    set variable    {"advanced":"0","address":"192.168.35.74","port":1,"ttl":127,"ts_transport_stream_id":101,"ts_pts_pcr_delay":200,"ts_pmt_start_pid":480,"ts_start_pid":481,"ts_tables_version":6,"ts_null_multiple":0,"ts_pcr_period":20,"ts_service_name":"Encoder","ts_service_provider":"Encoderdevice","name":"555","type":"ts","bindAudio":1,"bindNetwork": "eth0"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${body_json}    ${headers}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${msg}    MyTest.To Json    ${msg}
    ${result}    MyTest.To Json    ${result}
    Run Keyword If    ${result}=="ok"    log    用例执行成功，添加UDP流服务成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加UDP流服务失败：${rep}

3.1.6 添加RTP流服务
    ${headers}    create dictionary    Content-Type=application/json
    Comment    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded
    log    测试设备地址为：
    log    ${url}
    log    添加RTP流服务
    ${body_json}    set variable    {"address":"192.168.35.74","port":1026,"load_type":"ts","ts_service_name":"Encoder","ts_service_provider":"Encoderdevice","name":"666","type":"rtp","bindAudio":1,"bindNetwork": "eth0"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${body_json}    ${headers}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${msg}    MyTest.To Json    ${msg}
    ${result}    MyTest.To Json    ${result}
    Run Keyword If    ${result}=="ok"    log    用例执行成功，添加RMP流服务成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加RMP流服务失败：${rep}

3.1.7 添加NDI-HX流服务
    ${headers}    create dictionary    Content-Type=application/json
    Comment    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded
    log    测试设备地址为：
    log    ${url}
    log    添加NDI-HX流服务
    ${body_json}    set variable    {"group":"","channel_name":"channel-hdmi","connection":"disable_rudp","netprefix":"239.255.0.0","netmask":"255.255.0.0","ttl":1,"discovery_server":"","name":"NDI-HX","type":"ndi_hx","bindAudio":1,"bindNetwork": "eth0"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${body_json}    ${headers}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${msg}    MyTest.To Json    ${msg}
    ${result}    MyTest.To Json    ${result}
    Run Keyword If    ${result}=="ok"    log    用例执行成功，添加NDI-HX流服务成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加NDI-HX流服务失败：${rep}
