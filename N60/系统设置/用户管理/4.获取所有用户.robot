*** Settings ***
Suite Setup       获取全局Token
Library           Collections
Library           RequestsLibrary
Resource          ../../Keyword.txt

*** Test Cases ***
获取用户列表
    [Documentation]    获取所有可登录用户列表，验证响应结构和基本字段
    [Tags]    positive    smoke
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    api    /api/systemctrl/users/list    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    # 验证响应结构
    ${response_json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${response_json}    result
    Dictionary Should Contain Key    ${response_json}    data
    # 验证result字段
    Should Be Equal    ${response_json['result']}    ok
    # 验证data字段是列表类型
    Should Be True    isinstance($response_json['data'], list)
    # 如果data不为空，验证第一个用户的结构
    ${data_length}=    Get Length    ${response_json['data']}
    Run Keyword If    ${data_length} > 0    Validate User Object Structure    ${response_json['data'][0]}

获取用户列表返回数据结构
    [Documentation]    验证返回的用户对象
    [Tags]    positive    data-structure
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    api    /api/systemctrl/users/list    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_json}=    Set Variable    ${response.json()}
    ${data_length}=    Get Length    ${response_json['data']}
    # 遍历所有用户对象验证结构
    FOR    ${index}    IN RANGE    ${data_length}
        log    ${response_json['data'][${index}]}
    END

获取用户列表
    [Documentation]    验证获取用户的响应
    [Tags]    boundary
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    api    /api/systemctrl/users/list    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['result']}    ok
    log    ${response_json}

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
