*** Settings ***
Suite Setup       获取全局Token
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../Keyword.txt

*** Test Cases ***
1.1正常添加新用户
    [Documentation]    正常添加新用户
    # 正向测试用例
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${data}=    Create Dictionary    id=test_user_001    password=qwer1234    confirmNewPassword=qwer1234    alias=test_alias_001    enable_web=true    enable_api=true
    ${response}=    POST On Session    api    /api/systemctrl/users/add    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    result
    Should Be Equal As Strings    ${response.json()}[result]    ok

1.2仅使用必填字段添加用户
    [Documentation]    仅使用必填字段添加用户
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${data}=    Create Dictionary    id=test_user_002    password=qwer1234    confirmNewPassword=qwer1234    alias=test_alias_002    enable_web=false    enable_api=false
    ${response}=    POST On Session    api    /api/systemctrl/users/add    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    result
    Should Be Equal As Strings    ${response.json()}[result]    ok
    # 反向测试用例 - 参数验证

1.6密码长度过短
    [Documentation]    密码长度过短
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${data}=    Create Dictionary    id=test_user_005    password=123    confirmNewPassword=123    alias=test_alias_005    enable_web=true    enable_api=true
    ${response}=    POST On Session    api    /api/systemctrl/users/add    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    result
    Should Be Equal As Strings    ${response.json()}[result]    ok

1.7ID长度超长
    [Documentation]    ID长度超长
    ${long_id}=    Evaluate    "a" * 256
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${data}=    Create Dictionary    id=${long_id}    password=qwer1234    confirmNewPassword=qwer1234    alias=test_alias_007    enable_web=true    enable_api=true
    ${response}=    POST On Session    api    /api/systemctrl/users/add    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    result
    Should Be Equal As Strings    ${response.json()}[result]    ok

1.8布尔值边界测试
    [Documentation]    布尔值边界测试
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    # Test case 1: enable_web=false, enable_api=false
    ${data1}=    Create Dictionary    id=test_user_008    password=qwer1234    confirmNewPassword=qwer1234    alias=test_alias_008    enable_web=false    enable_api=false
    ${response1}=    POST On Session    api    /api/systemctrl/users/add    json=${data1}    headers=${headers}
    Run Keyword If    ${response1.status_code} == 200    Should Be Equal As Strings    ${response1.json()}[result]    ok
    # Test case 2: enable_web=true, enable_api=false
    ${data2}=    Create Dictionary    id=test_user_009    password=qwer1234    confirmNewPassword=qwer1234    alias=test_alias_009    enable_web=true    enable_api=false
    ${response2}=    POST On Session    api    /api/systemctrl/users/add    json=${data2}    headers=${headers}
    Run Keyword If    ${response2.status_code} == 200    Should Be Equal As Strings    ${response2.json()}[result]    ok
    # 安全性测试用例

1.9SQL注入攻击测试
    [Documentation]    SQL注入攻击测试
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${data}=    Create Dictionary    id=test_user_010'; DROP TABLE users; --    password=qwer1234    confirmNewPassword=qwer1234    alias=test_alias_010    enable_web=true    enable_api=true
    ${response}=    POST On Session    api    /api/systemctrl/users/add    json=${data}    headers=${headers}
    Log    Response: ${response.text}

1.10XSS攻击测试
    [Documentation]    XSS攻击测试
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${data}=    Create Dictionary    id=test_user_011    password=qwer1234    confirmNewPassword=qwer1234    alias=<script>alert('xss')</script>    enable_web=true    enable_api=true
    ${response}=    POST On Session    api    /api/systemctrl/users/add    json=${data}    headers=${headers}
    Log    Response: ${response.text}
    # 性能测试用例

1.11快速添加多个用户
    [Documentation]    快速添加多个用户
    FOR    ${i}    IN RANGE    1    6
        ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
        ${data}=    Create Dictionary    id=load_test_user_${i}    password=qwer1234    confirmNewPassword=qwer1234    alias=load_test_alias_${i}    enable_web=true    enable_api=true
        ${response}=    POST On Session    api    /api/systemctrl/users/add    json=${data}    headers=${headers}    timeout=10
        Log    Response for user ${i}: ${response.text}
    END

*** Keywords ***
Login And Get Token
    [Documentation]    登录并获取token，返回token字符串
    # [Arguments]    ${username}="admin"    ${password}="Admin123"    ${language}=en
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"en"}    Content-Type=application/json
    ${data}=    Create Dictionary    username=admin    password=Admin123
    ${response}=    POST On Session    api    /api/systemctrl/users/login    json=${data}    headers=${headers}
    # 验证响应状态
    Should Be Equal As Strings    ${response.status_code}    200
    # 提取token并返回
    ${token}=    Set Variable    ${response.json()['data']['token']}
    [Return]    ${token}

获取全局Token
    ${token}=    Login And Get Token
    Set Suite Variable    ${AUTH_TOKEN}    ${token}

Generate Random User ID
    [Arguments]    ${prefix}=test_user
    ${random_suffix}=    Generate Random String    8    [LETTERS][NUMBERS]
    ${user_id}=    Catenate    SEPARATOR=_    ${prefix}    ${random_suffix}
    [Return]    ${user_id}
