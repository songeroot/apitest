*** Settings ***
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Selenium2Library
Library           MyTest.py
Library           JSONLibrary
Resource          ../../url.txt
Resource          ../../token.txt

*** Test Cases ***
7.1 反复开启关闭连接聚合
    FOR    ${var}    IN RANGE    1    #循环多少次
        ${var2}    Evaluate    ${var} * 2
        log    第${var2} 次切换---------------------------------------------------------------------------------------------------------
        开关聚合
    END

*** Keywords ***
开关聚合
    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded    Authorization=${auth_token}    Content-Type=application/json
    @{list}    set variable    True    False
    FOR    ${var}    IN    @{list}    #切换成对应指定的音频输入源
        log    聚合状态切换成${var}
        ${body}    create dictionary    enable=${var}
        ${body1}    MyTest.To Json    ${body}
        ${rep}    My Post    ${url}/api/kilolink/bonding/setting_stream    ${body1}    ${headers}
        ${result}    get_json_value    ${rep}    result
        sleep    6
        ${result}    MyTest.To Json    ${result}
        Run Keyword If    ${result}=="ok"    log    用例执行成功，聚合状态已切换成${var}
        Run Keyword If    ${result}!="ok"    fail    用例执行失败，切换聚合状态失败：${result}
        sleep    1
    END
