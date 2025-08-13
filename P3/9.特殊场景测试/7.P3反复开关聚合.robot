*** Settings ***
Library           ../../Python37/Lib/site-packages/RequestsLibrary/
Library           ../../Python37/Lib/site-packages/DatabaseLibrary/
Library           ../../Python37/Lib/site-packages/Selenium2Library/
Library           ../../Python37/Lib/site-packages/MyTest.py
Library           ../../Python37/Lib/site-packages/JSONLibrary/

*** Test Cases ***
7.1 反复开启关闭连接聚合
    FOR    ${var}    IN RANGE    50    #循环多少次
        ${var2}    Evaluate    ${var} * 2
        log    第${var2} 次切换---------------------------------------------------------------------------------------------------------
        开关聚合
    END

*** Keywords ***
开关聚合
    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded    Authorization=Basic YWRtaW46YWRtaW4=    Content-Type=application/json
    @{list}    set variable    True    False
    FOR    ${var}    IN    @{list}    #切换成对应指定的音频输入源
        log    聚合状态切换成${var}
        ${body}    create dictionary    enable=${var}
        ${body1}    MyTest.To Json    ${body}
        ${rep}    My Post    http://192.168.43.195/api/kilolink/bonding/setting_stream    ${body1}    ${headers}
        ${result}    get_json_value    ${rep}    result
        sleep    6
        ${result}    MyTest.To Json    ${result}
        Run Keyword If    ${result}=="ok"    log    用例执行成功，聚合状态已切换成${var}
        Run Keyword If    ${result}!="ok"    fail    用例执行失败，切换聚合状态失败：${result}
        sleep    1
    END
