*** Settings ***
Library           ../../Python37/Lib/site-packages/MyTest.py
Library           ../../Python37/Lib/site-packages/RequestsLibrary/
Library           ../../Python37/Lib/site-packages/DatabaseLibrary/
Library           ../../Python37/Lib/site-packages/Selenium2Library/
Library           ../../Python37/Lib/site-packages/JSONLibrary/
Resource          ../url.txt
Library           Collections
Resource          ../token.txt

*** Variables ***

*** Test Cases ***
1.1.1.1 获取流列表-正常场景-获取所有流
    [Documentation]    验证能够正常获取所有流列表
    # 正常场景测试
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
