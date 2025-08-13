*** Settings ***
Library           ../../Python37/Lib/site-packages/RequestsLibrary/
Library           ../../Python37/Lib/site-packages/DatabaseLibrary/
Library           ../../Python37/Lib/site-packages/Selenium2Library/
Library           ../../Python37/Lib/site-packages/MyTest.py
Library           ../../Python37/Lib/site-packages/JSONLibrary/

*** Test Cases ***
5.1 HDMI和SDI反复切换
    FOR    ${var}    IN RANGE    50    #循环多少次
        ${var2}    Evaluate    ${var} * 2
        log    第${var2} 次切换---------------------------------------------------------------------------------------------------------
        视频源切换
    END

*** Keywords ***
视频源切换
    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded    Authorization=Basic YWRtaW46YWRtaW4=    Content-Type=application/json
    @{list}    set variable    hdmi    uvc
    FOR    ${var}    IN    @{list}    #切换成对应指定的视频输入源
        log    切换成${var}的视频源
        ${body}    create dictionary    source=${var}
        ${body1}    MyTest.To Json    ${body}
        ${rep}    My Post    http://192.168.43.142/api/codec/v1/vin/source    ${body1}    ${headers}
        ${result}    get_json_value    ${rep}    result
        sleep    4
        ${result}    MyTest.To Json    ${result}
        Run Keyword If    ${result}=="ok"    log    用例执行成功，已切换成${var}的视频源
        Run Keyword If    ${result}!="ok"    fail    用例执行失败，切换视频源失败：${result}
        sleep    2
    END
