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
3.1 修改流-正常场景-修改RTSP流
    [Documentation]    列表包含 rtsp 时直接取 id；否则调用创建接口并取 data.id
    # 通过RTSP 流 id修改RTSP流参数
    #添加RTSP流并获取RTSP流id
    Add RTSP
    # 验证响应格式
    Run Keyword If    ${result}=="ok" and ${msg}==""    log    用例执行成功，添加rtsp流成功
    #当rtsp流已存在时直接从流列表取rtsp流的id值
    Run Keyword If    ${result}=="error" and ${msg}=="Only 1CH RTSP streaming service supported"    Get streamer list    #当rtsp流已存在时直接从流列表取rtsp流的id值
    Run Keyword If    ${result}!="ok" and ${msg}!="Only 1CH RTSP streaming service supported"    fail    用例执行失败，添加rtsp流失败
    log    被修改的RTSP流的流ID为：${id}
    sleep    1
    #通过修改流接口修改已添加RTSP流的参数
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    log    修改RTSP流名称-----------------------------------------
    ${id2}    Evaluate    ${id}.replace('"', '')    #使用Python的replace方法去掉双引号
    ${name}    Evaluate    random.randint(1000, 9999)    random
    ${rtsp-name}    set variable    rtsp-${name}
    Comment    ${rtsp_data}    set variable    {"id":${id},"auth":"False","bindAudio":1,"bindNetwork":"auto","httpTunnelPort":8554,"multicast_addr":"239.255.0.2","multicast_enable":"True","multicast_port_max":30005,"multicast_port_min":30001,"multicast_ttl":112,"name":${rtsp-name},"port":554,"session":"ch01","type":"rtsp"}
    ${rtsp_data}    Create Dictionary     id=${id2}    auth=${False}    bindAudio=1    bindNetwork=auto    httpTunnelPort=8554    multicast_addr=239.255.0.2    multicast_enable=${False}    multicast_port_max=30005    multicast_port_min=30001    multicast_ttl=112    name=${rtsp-name}    port=554    session=ch01    type=rtsp
    ${rep}    My_Putt    ${url}/api/streamer/v1/stream/${id2}    ${rtsp_data}    ${headers}
    Log    添加流返回值: ${rep}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    Run Keyword If    "${result}"=="ok" and "${msg}"==""    log    用例执行成功,修改rtsp流名称成功，修改后的rtsp流名称为：${rtsp-name}
    Run Keyword If    "${result}"!="ok" or "${msg}"!=""    fail    用例执行失败,修改rtsp流名称失败，${rep}

*** Keywords ***
Get streamer list
    [Documentation]    列表包含 rtsp 时直接取 id；否则调用创建接口并取 data.id
    # 直接从流列表获取RTSP 流 id
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    获取流列表---------------------------------------------------
    ${rep}    My_Get    ${url}/api/streamer/v1/stream/list    ${headers}
    Log    获取返回值: ${rep}
    # 解析 JSON 响应
    ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 尝试从列表中直接取第一个 type=rtsp 的 id
    ${id}    Evaluate    next((item.get("id") for item in $json_data if item.get("type") == "rtsp"), None)
    ${id}    MyTest.To Json    ${id}
    Set Test Variable    ${id}

Add RTSP
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    # 构造rtsp流请求参数
    ${rtsp_data}    set variable    {"auth":"False","bindAudio":1,"bindNetwork":"auto","httpTunnelPort":8554,"multicast_addr":"239.255.0.2","multicast_enable":"True","multicast_port_max":30005,"multicast_port_min":30001,"multicast_ttl":112,"name":"RTSP_Test","port":554,"session":"ch01","type":"rtsp"}
    ${rep}    My Post    ${url}/api/streamer/v1/stream    ${rtsp_data}    ${headers}
    Log    添加流返回值: ${rep}
    ${result}    get_json_value    ${rep}    result
    ${msg}    get_json_value    ${rep}    msg
    ${id}    get_json_value    ${rep}    data
    ${result}    MyTest.To Json    ${result}
    ${msg}    MyTest.To Json    ${msg}
    ${id}    MyTest.To Json    ${id}
    Set Test Variable    ${result}
    Set Test Variable    ${msg}
    Set Test Variable    ${id}
