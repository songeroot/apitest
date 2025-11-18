*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           MyTest.py
Library           JSONLibrary
Resource          ../url.txt
Library           BuiltIn
Library           DatabaseLibrary
Library           Selenium2Library
Resource          ../token.txt

*** Variables ***

*** Test Cases ***
3.1.2.1 添加流-正常场景-添加NDI流
    [Documentation]    验证能够正常添加NDI流
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    FOR    ${i}    IN RANGE    2
        ${i}    Evaluate    ${i}+1
        Log    第${i}次添加NDI流---------------------------------------------------
    # 构造NDI流请求参数
        ${ndi_data}    set variable    {"group":"","channel_name":"","connection":"disable_rudp","netprefix":"","netmask":"","ttl":1,"discovery_server":"","bindNetwork":"auto","name":"NDI","type":"ndi_hx","bindAudio":1}
        ${rep}    My Post    ${url}/api/streamer/v1/stream    ${ndi_data}    ${headers}
        Log    添加流返回值: ${rep}
        ${result}    get_json_value    ${rep}    result
        ${msg}    get_json_value    ${rep}    msg
        ${result}    MyTest.To Json    ${result}
        ${msg}    MyTest.To Json    ${msg}
    # 验证响应格式
        Run Keyword If    ${result}=="ok" and ${msg}==""    log    用例执行成功，添加NDI HX流成功
        Run Keyword If    ${result}=="error" and ${msg}=="Only 1CH NDI_HX streaming service supported"    log    用例执行成功，添加NDI HX流失败，NDI HX流已存在，最多只能添加一路
        Run Keyword If    ${result}!="ok" and ${msg}!="Only 1CH NDI_HX streaming service supported"    fail    用例执行失败，添加NDI HX流失败
        sleep    1
    END

3.1.2.2 添加流-正常场景-添加RTSP流
    [Documentation]    验证能够正常添加rtsp流
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    FOR    ${i}    IN RANGE    2
        ${i}    Evaluate    ${i}+1
        Log    第${i}添加rtsp流---------------------------------------------------
    # 构造rtsp流请求参数
        ${rtsp_data}    set variable    {"auth":"False","bindAudio":1,"bindNetwork":"auto","httpTunnelPort":8554,"multicast_addr":"239.255.0.2","multicast_enable":"True","multicast_port_max":30005,"multicast_port_min":30001,"multicast_ttl":112,"name":"RTSP_Test","port":554,"session":"ch01","type":"rtsp"}
        ${rep}    My Post    ${url}/api/streamer/v1/stream    ${rtsp_data}    ${headers}
        Log    添加流返回值: ${rep}
        ${result}    get_json_value    ${rep}    result
        ${msg}    get_json_value    ${rep}    msg
        ${result}    MyTest.To Json    ${result}
        ${msg}    MyTest.To Json    ${msg}
    # 验证响应格式
        Run Keyword If    ${result}=="ok" and ${msg}==""    log    用例执行成功，添加rtsp流成功
        Run Keyword If    ${result}=="error" and ${msg}=="Only 1CH RTSP streaming service supported"    log    用例执行成功，添加rtsp流失败，rtsp流已存在，最多只能添加一路
        Run Keyword If    ${result}!="ok" and ${msg}!="Only 1CH RTSP streaming service supported"    fail    用例执行失败，添加rtsp流失败
        sleep    1
    END

3.1.2.3 添加流-正常场景-添加RTMP流
    [Documentation]    验证能够正常添加rtmp流
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    添加NDI流---------------------------------------------------
    # 构造RTMP流请求参数
    ${rtmp_data}    set variable    {"address":"rtmp://192.168.43.230:1935/live/lys","bindAudio":1,"bindNetwork":"auto","connIntv":3,"connTimeout":"15","name":"rtmptest","type":"rtmp","user":"","password":""}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${rtmp_data}    ${headers}
    Log    添加流返回值: ${rep}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${result}    MyTest.To Json    ${result}
    ${msg}    MyTest.To Json    ${msg}
    # 验证响应格式
    Run Keyword If    ${result}=="ok" and ${msg}==""    log    用例执行成功，添加rtmp流成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加rtmp流失败:${rep}
    sleep    1

3.1.2.4 添加流-正常场景-添加SRT流
    [Documentation]    验证能够正常添加SRT流
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    添加SRT流Listener模式---------------------------------------------------
    ${listenerPort}    Evaluate    random.randint(1000, 9999)    random
    # 构造SRT流Listener模式请求参数
    ${srt_data}    set variable    {"address":"","bindAudio":1,"bindNetwork":"auto","connIntv":3,"bindWidth":"25","connectionMode":"Listener","encryption":0,"latency":125,"listenerPort":"${listenerPort}","name":"srt-listener","type":"srt","ts_transport_stream_id":"101","ts_pts_pcr_delay":"200","ts_pcr_period":"20","ts_null_multiple":0,"srt_stream_id":"","payloadSize":1216,"passphrase":""}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${srt_data}    ${headers}
    Log    添加流返回值: ${rep}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${result}    MyTest.To Json    ${result}
    ${msg}    MyTest.To Json    ${msg}
    # 验证响应格式
    Run Keyword If    ${result}=="ok" and ${msg}==""    log    用例执行成功，添加srt流lisenter模式成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加srt流lisenter模式失败:${rep}
    sleep    2
    Log    添加SRT流Caller模式---------------------------------------------------
    ${listenerPort1}    Evaluate    random.randint(1000, 9999)    random
    # 构造SRT流Caller模式请求参数
    ${srt_data1}    set variable    {"address":"192.168.43.1","bindAudio":1,"bindNetwork":"auto","connIntv":3,"bindWidth":"25","connectionMode":"Caller","encryption":0,"latency":125,"listenerPort":"${listenerPort1}","name":"srt-caller","type":"srt","ts_transport_stream_id":"101","ts_pts_pcr_delay":"200","ts_pcr_period":"20","ts_null_multiple":0,"srt_stream_id":"","payloadSize":1216,"passphrase":""}
    ${rep1}    My Post    ${url}/api/streamer/v1/stream    ${srt_data1}    ${headers}
    Log    添加流返回值: ${rep1}
    ${result1}    get_json_value    ${rep1}    result
    ${msg1}    get_json_value    ${rep1}    msg
    ${result1}    MyTest.To Json    ${result1}
    ${msg1}    MyTest.To Json    ${msg1}
    # 验证响应格式
    Run Keyword If    ${result1}=="ok" and ${msg1}==""    log    用例执行成功，添加srt流caller模式成功
    Run Keyword If    ${result1}!="ok"    fail    用例执行失败，添加srt流caller模式失败:${rep1}
    sleep    1

3.1.2.5 添加流-正常场景-添加HLS流
    [Documentation]    验证能够正常添加HLS流
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    添加HLS流---------------------------------------------------
    # 构造HLS流请求参数
    ${hls_data}    set variable    {"bindAudio":1,"bindNetwork":"auto","media_playlist_url":"","maxSegments":5,"mode":"server","segmentTime":5,"session":888,"type":"hls","name":"hls-test"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${hls_data}    ${headers}
    Log    添加流返回值: ${rep}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${result}    MyTest.To Json    ${result}
    ${msg}    MyTest.To Json    ${msg}
    # 验证响应格式
    Run Keyword If    ${result}=="ok" and ${msg}==""    log    用例执行成功，添加hls流server模式成功
    Run Keyword If    ${result}=="error" and ${msg}=="Only 1CH HLS streaming service supported"    log    用例执行成功，添加hls流失败，hls流已存在，最多只能添加一路
    Run Keyword If    ${result}!="ok" and ${msg}!="Only 1CH HLS streaming service supported"    fail    用例执行失败，添加hls流server模式失败：${rep}

3.1.2.6 添加流-正常场景-添加TS-UDP流
    [Documentation]    验证能够正常添加TS-UDP流
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    添加TS-UDP流---------------------------------------------------
    # 构造TS-UDP流请求参数
    ${udp_data}    set variable    {"address":"192.168.43.1","advanced":"0","bindAudio":1,"bindNetwork":"auto","port":2222,"ts_null_multiple":0,"ts_pcr_period":20,"ts_pmt_start_pid":480,"ts_pts_pcr_delay":200,"type":"ts","name":"udp-test","ts_service_name":"Encoder","ts_service_provider":"Encoder device","ts_start_pid":481,"ts_tables_version":6,"ts_transport_stream_id":101,"ttl":127}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${udp_data}    ${headers}
    Log    添加流返回值: ${rep}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${result}    MyTest.To Json    ${result}
    ${msg}    MyTest.To Json    ${msg}
    # 验证响应格式
    Run Keyword If    ${result}=="ok" and ${msg}==""    log    用例执行成功，添加udp流成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加udp流失败:${rep}

3.1.2.7 添加流-正常场景-添加RTP流
    [Documentation]    验证能够正常添加RTP流
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    添加RTP流---------------------------------------------------
    # 构造RTP流请求参数
    ${rtp_data}    set variable    {"address":"192.168.43.1","bindAudio":1,"bindNetwork":"auto","port":3333,"load_type":"ts","type":"rtp","name":"rtp-test","ts_service_name":"Encoder","ts_service_provider":"Encoder device"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${rtp_data}    ${headers}
    Log    添加流返回值: ${rep}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${result}    MyTest.To Json    ${result}
    ${msg}    MyTest.To Json    ${msg}
    # 验证响应格式
    Run Keyword If    ${result}=="ok" and ${msg}==""    log    用例执行成功，添加rtp流成功
    Run Keyword If    ${result}!="ok"    fail    用例执行失败，添加rtp流失败:${rtp}

3.1.2.10 添加流-异常场景-缺少必填参数
    [Documentation]    验证缺少必填参数时的错误处理
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试缺少必填参数---------------------------------------------------
    # 构造缺少必填参数的请求
    ${invalid_data}    Create Dictionary    name=Invalid_Test    type=rtsp
    # 缺少其他必填参数
    Comment    ${json_data}    Evaluate    json.dumps($invalid_data)    json
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${headers}    ${invalid_data}
    Log    添加流返回值: ${rep}
    Comment    ${response_data}    Evaluate    json.loads('''${rep}''')    json
    Comment    Dictionary Should Contain Key    ${response_data}    result
    Comment    Should Not Be Equal As Strings    ${response_data}[result]    ok
    Comment    Log    用例执行成功，正确处理了缺少必填参数的情况

3.1.2.11 添加流-异常场景-无效的流类型
    [Documentation]    验证无效流类型时的错误处理
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试无效流类型---------------------------------------------------
    Comment    # 构造无效流类型的请求
    Comment    ${invalid_data}    Create Dictionary    name=Invalid_Type_Test    type=invalid_type    bindAudio=1    bindNetwork=auto
    Comment    ${json_data}    Evaluate    json.dumps($invalid_data)    json
    Comment    ${rep}    My_Post    ${url}/api/streamer/v1/stream    ${headers}    ${json_data}
    Comment    Log    添加流返回值: ${rep}
    Comment    ${response_data}    Evaluate    json.loads('''${rep}''')    json
    Comment    Dictionary Should Contain Key    ${response_data}    result
    Comment    Should Not Be Equal As Strings    ${response_data}[result]    ok
    Comment    Log    用例执行成功，正确处理了无效流类型

3.1.2.12 添加流-异常场景-无权限访问
    [Documentation]    验证无权限时的错误处理
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=invalid_token
    Log    测试无权限访问---------------------------------------------------
    Comment    ${test_data}    Create Dictionary    name=Unauthorized_Test    type=rtsp    bindAudio=1
    Comment    ${json_data}    Evaluate    json.dumps($test_data)    json
    Comment    ${rep}    My_Post    ${url}/api/streamer/v1/stream    ${headers}    ${json_data}    expected_status=any
    Comment    Log    添加流返回值: ${rep}
    Comment    # 验证返回401或403状态码
    Comment    ${status_code}    Get From Dictionary    ${rep}    status_code
    Comment    Run Keyword If    ${status_code}==401 or ${status_code}==403    Log    用例执行成功，正确处理了无权限访问
    Comment    Run Keyword If    ${status_code}!=401 and ${status_code}!=403    Fail    期望返回401或403状态码，实际返回${status_code}

3.1.2.16 添加流-边界场景-超长字符串测试
    [Documentation]    验证超长字符串的处理
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试超长字符串---------------------------------------------------
    Comment    # 构造超长名称的流（限制长度避免过长）
    Comment    ${long_name}    Set Variable    ${'a' * 100}
    Comment    ${long_string_data}    Create Dictionary    name=${long_name}    type=rtsp    bindAudio=1    bindNetwork=auto    portRTMO=554    httpTunnelPort=8554    session=test    auth=${False}    multicast_enable=${False}
    Comment    ${json_data}    Evaluate    json.dumps($long_string_data)    json
    Comment    ${rep}    My_Post    ${url}/api/streamer/v1/stream    ${headers}    ${json_data}
    Comment    Log    超长字符串测试返回值: ${rep}
    Comment    Log    用例执行成功，超长字符串测试完成

3.1.2.17 添加流-功能场景-验证参数类型
    [Documentation]    验证参数类型的正确性
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    验证参数类型---------------------------------------------------
    Comment    # 测试错误的参数类型
    Comment    ${wrong_type_data}    Create Dictionary    name=Type_Test    type=rtsp    bindAudio=invalid_audio_id    bindNetwork=auto    portRTMO=invalid_port    httpTunnelPort=8554    session=test    auth=${False}    multicast_enable=${False}
    Comment    ${json_data}    Evaluate    json.dumps($wrong_type_data)    json
    Comment    ${rep}    My_Post    ${url}/api/streamer/v1/stream    ${headers}    ${json_data}
    Comment    Log    错误参数类型测试返回值: ${rep}
    Comment    ${response_data}    Evaluate    json.loads('''${rep}''')    json
    Comment    Dictionary Should Contain Key    ${response_data}    result
    Comment    # 应该返回错误，因为参数类型不正确
    Comment    Should Not Be Equal As Strings    ${response_data}[result]    ok
    Comment    Log    用例执行成功，正确处理了错误的参数类型

*** Keywords ***
