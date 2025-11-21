*** Settings ***
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Selenium2Library
Library           MyTest.py
Library           JSONLibrary
Resource          ../../url.txt
Resource          ../../token.txt

*** Test Cases ***
4.1 H.265和H.264反复切换
    FOR    ${var}    IN RANGE    1    #循环多少次
        ${var2}    Evaluate    ${var} * 2
        log    第${var2} 次切换---------------------------------------------------------------------------------------------------------
        编码参数修改
    END

*** Keywords ***
编码参数修改
    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded    Authorization=${auth_token}    Content-Type=application/json
    @{list}    set variable    H264    H265
    FOR    ${var}    IN    @{list}    #切换成对应指定的编码
        log    切换成${var}编码
        ${body}    set variable    {"codec":"${var}","grey":false,"profile":0,"picHeight":1,"picWidth":1,"mode":"CBR","gop":60,"fps":60,"bitrate":6000,"maxBitrate":6000,"minQp":24,"maxQp":51,"minIQp":24}
        ${rep}    My Post    ${url}/api/codec/v1/venc/settings    ${body}    ${headers}
        ${result}    get_json_value    ${rep}    result
        sleep    4
        ${result}    MyTest.To Json    ${result}
        Run Keyword If    ${result}=="ok"    log    用例执行成功，已切换成${var}编码
        Run Keyword If    ${result}!="ok"    fail    用例执行失败，切换成${var}编码失败：${result}
        sleep    2
    END
