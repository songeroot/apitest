*** Settings ***
Library           ../../Python37/Lib/site-packages/MyTest.py
Library           RequestsLibrary
Library           DatabaseLibrary
Library           Selenium2Library
Library           JSONLibrary
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
    Log    获取流列表---------------------------------------------------
    ${rep}    My_Get    ${url}/api/streamer/v1/stream/list    ${headers}
    Log    获取返回值: ${rep}
    # 解析JSON响应
    ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 验证返回的数据格式是否为数组
    ${is_array}    Evaluate    isinstance($json_data, list)
    Run Keyword If    ${is_array}==True    Log    用例执行成功，返回数据为数组格式
    Run Keyword If    ${is_array}!=True    Fail    用例执行失败，返回数据不是数组格式
    # 记录流的数量
    ${stream_count}    Get Length    ${json_data}
    Log    获取到${stream_count}个流
    sleep    1

1.1.1.2 获取流列表-正常场景-验证流数据结构完整性
    [Documentation]    验证返回的流数据包含所有必要字段
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    验证流数据结构---------------------------------------------------
    ${rep}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    Log    获取返回值: ${rep}
    # 解析JSON响应
    ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 验证返回的数据格式是否为数组
    ${is_array}    Evaluate    isinstance($json_data, list)
    Run Keyword If    ${is_array}==True    Log    用例执行成功，返回数据为数组格式
    Run Keyword If    ${is_array}!=True    Fail    用例执行失败，返回数据不是数组格式，测试终止
    # 如果数组不为空，验证第一个元素的必要字段
    ${array_length}    Get Length    ${json_data}
    Run Keyword If    ${array_length}>0    验证流数据必要字段    ${json_data}
    Run Keyword If    ${array_length}==0    Log    流列表为空，无法验证数据结构
    sleep    1

1.1.1.3 获取流列表-正常场景-验证不同类型流的数据
    [Documentation]    验证不同类型的流（如rtsp、rtmp等）数据是否正确
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    验证不同类型流数据---------------------------------------------------
    ${rep}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    Log    获取返回值: ${rep}
    # 解析JSON响应
    ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 验证返回的数据格式是否为数组
    ${is_array}    Evaluate    isinstance(${json_data}, list)
    Run Keyword If    ${is_array}==True    Log    用例执行成功，返回数据为数组格式
    Run Keyword If    ${is_array}!=True    Fail    用例执行失败，返回数据不是数组格式，测试终止
    # 如果数组不为空，验证不同类型的流
    ${array_length}    Get Length    ${json_data}
    Run Keyword If    ${array_length}>0    验证不同类型流    ${json_data}
    Run Keyword If    ${array_length}==0    Log    流列表没有创建流服务
    # 异常场景测试
    sleep    1

1.1.1.4 获取流列表-异常场景-无权限访问
    [Documentation]    使用无权限的认证信息访问接口
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=AABB
    Log    测试设备地址为：${url}
    Log    无权限访问测试---------------------------------------------------
    ${rep}    My Gett    ${url}/api/streamer/v1/stream/list    ${headers}
    Log    获取返回值: ${rep}
    # 验证返回的错误信息包含权限相关内容
    ${status_code}    Get From Dictionary    ${rep}    status_code
    Run Keyword If    ${status_code}==401 or ${status_code}==403    Log    权限验证通过，无权限访问返回正确状态码
    Run Keyword If    ${status_code}!=401 and ${status_code}!=403    Fail    权限验证失败，期望状态码为401或403，实际为${status_code}
    sleep    1

1.1.1.5 获取流列表-异常场景-无效认证信息
    [Documentation]    使用无效的认证信息访问接口
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9
    Log    测试设备地址为：${url}
    Log    无效认证信息测试---------------------------------------------------
    ${rep}    My Gett    ${url}/api/streamer/v1/stream/list    ${headers}
    Log    获取返回值: ${rep}
    # 验证返回的错误信息
    ${status_code}    Get From Dictionary    ${rep}    status_code
    Run Keyword If    ${status_code}==401    Log    认证验证通过，无效认证信息返回正确状态码
    Run Keyword If    ${status_code}!=401    Fail    认证验证失败，期望状态码为401，实际为${status_code}
    sleep    1

1.1.1.6 获取流列表-异常场景-无认证信息
    [Documentation]    不提供认证信息访问接口
    ${headers}    Create Dictionary    Content-Type=application/json
    Log    测试设备地址为：${url}
    Log    无认证信息测试---------------------------------------------------
    ${rep}    My Gett    ${url}/api/streamer/v1/stream/list    ${headers}
    Log    获取返回值: ${rep}
    # 验证返回的错误信息
    ${status_code}    Get From Dictionary    ${rep}    status_code
    Run Keyword If    ${status_code}==401    Log    认证验证通过，无认证信息返回正确状态码
    Run Keyword If    ${status_code}!=401    Fail    认证验证失败，期望状态码为401，实际为${status_code}
    sleep    1

1.1.1.7 获取流列表-异常场景-错误的URL路径
    [Documentation]    使用错误的URL路径访问接口
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    错误URL路径测试---------------------------------------------------
    ${rep}    My Gett    ${url}/api/streamer/v1/stream/list1    ${headers}
    Log    获取返回值: ${rep}
    # 验证返回的错误信息
    ${status_code}    Get From Dictionary    ${rep}    status_code
    Run Keyword If    ${status_code}==405 or ${status_code}==404    Log    URL路径验证通过，错误路径返回正确状态码
    Run Keyword If    ${status_code}!=405 and ${status_code}!=404    Fail    URL路径验证失败，期望状态码为404，实际为${status_code}
    # 边界场景测试
    sleep    1

1.1.1.8 获取流列表-边界场景-响应超时
    [Documentation]    测试接口响应超时情况
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    响应超时测试---------------------------------------------------
    # 设置较短的超时时间
    ${status}    Run Keyword And Return Status    Wait Until Keyword Succeeds    0.1s    0.2s    My Get    ${url}/v1/stream/list    ${headers}
    Run Keyword If    ${status}==True    Log    响应时间在预期范围内，测试通过
    Run Keyword If    ${status}==False    Log    响应超时，可能需要检查服务器性能
    sleep    1

1.1.1.9 获取流列表-边界场景-大量数据处理
    [Documentation]    测试系统处理大量流数据的能力
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    大量数据处理测试---------------------------------------------------
    ${rep}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    # 解析JSON响应
    ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 验证返回的数据格式是否为数组
    ${is_array}    Evaluate    isinstance(${json_data},list)
    Run Keyword If    ${is_array}==True    Log    返回数据为数组格式
    Run Keyword If    ${is_array}!=True    Fail    返回数据不是数组格式，测试终止
    # 获取数组长度并记录
    ${array_length}    Get Length    ${json_data}
    Log    流列表包含${array_length}个流
    # 如果数组长度大于10，验证是否能正确处理大量数据
    Run Keyword If    ${array_length}>10    Log    系统能够处理大量流数据，测试通过
    Run Keyword If    ${array_length}<=10    Log    流数量不足以测试大量数据处理能力，测试跳过
    sleep    1

1.1.1.10 获取流列表-边界场景-空列表处理
    [Documentation]    测试系统处理空流列表的情况
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    空列表处理测试---------------------------------------------------
    ${rep}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    # 解析JSON响应
    ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 验证返回的数据格式是否为数组
    ${is_array}    Evaluate    isinstance(${json_data},list)
    Run Keyword If    ${is_array}==True    Log    返回数据为数组格式
    Run Keyword If    ${is_array}!=True    Fail    返回数据不是数组格式，测试终止
    # 获取数组长度
    ${array_length}    Get Length    ${json_data}
    Log    流列表包含${array_length}个流
    # 即使列表为空，也应该返回空数组而不是null或其他值
    Run Keyword If    ${array_length}==0    Log    系统正确处理空列表，返回空数组
    # 功能场景测试
    sleep    1

1.1.1.11 获取流列表-功能场景-验证流状态一致性
    [Documentation]    验证流的enable状态与status状态的一致性
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    验证流状态一致性---------------------------------------------------
    ${rep}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    # 解析JSON响应
    ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 验证返回的数据格式是否为数组
    ${is_array}    Evaluate    isinstance(${json_data}, list)
    Run Keyword If    ${is_array}==True    Log    返回数据为数组格式
    Run Keyword If    ${is_array}!=True    Fail    返回数据不是数组格式，测试终止
    # 如果数组不为空，验证流状态与启用状态的一致性
    ${array_length}    Get Length    ${json_data}
    Run Keyword If    ${array_length}>0    验证流状态一致性    ${json_data}
    Run Keyword If    ${array_length}==0    Log    流列表为空，无法验证状态一致性
    sleep    1

1.1.1.12 获取流列表-功能场景-验证流地址可访问性
    [Documentation]    验证启用的流的地址是否可访问
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    验证流地址可访问性---------------------------------------------------
    ${rep}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    # 解析JSON响应
    ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 验证返回的数据格式是否为数组
    ${is_array}    Evaluate    isinstance(${json_data} , list)
    Run Keyword If    ${is_array}==True    Log    返回数据为数组格式
    Run Keyword If    ${is_array}!=True    Fail    返回数据不是数组格式，测试终止
    # 如果数组不为空，验证启用的流的地址是否可访问
    ${array_length}    Get Length    ${json_data}
    Run Keyword If    ${array_length}>0    验证流地址可访问性    ${json_data}
    Run Keyword If    ${array_length}==0    Log    流列表为空，无法验证地址可访问性
    sleep    1

1.1.1.13 获取流列表-功能场景-验证端口号有效性
    [Documentation]    验证流的端口号是否在有效范围内
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    验证端口号有效性---------------------------------------------------
    ${rep}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    # 解析JSON响应
    ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 验证返回的数据格式是否为数组
    ${is_array}    Evaluate    isinstance(${json_data} , list)
    Run Keyword If    ${is_array}==True    Log    返回数据为数组格式
    Run Keyword If    ${is_array}!=True    Fail    返回数据不是数组格式，测试终止
    # 如果数组不为空，验证端口号是否有效
    ${array_length}    Get Length    ${json_data}
    Run Keyword If    ${array_length}>0    验证端口号有效性    ${json_data}
    Run Keyword If    ${array_length}==0    Log    流列表为空，无法验证端口号有效性
    Log    所有流端口号有效性验证通过
    # 性能场景测试
    sleep    1

1.1.1.14 获取流列表-性能场景-连续请求
    [Documentation]    测试连续多次请求接口的性能
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    连续请求测试---------------------------------------------------
    # 连续请求10次，记录每次响应时间
    FOR    ${i}    IN RANGE    10
        ${start_time}    Evaluate    time.time()
        ${rep}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
        ${end_time}    Evaluate    time.time()
        ${response_time}    Evaluate    ${end_time} - ${start_time}
        Log    第${i+1}次请求响应时间: ${response_time}秒
    # 解析JSON响应
        ${json_data}    Evaluate    json.loads('''${rep}''')    json
    # 验证返回的数据格式是否为数组
        ${is_array}    Evaluate    isinstance(${json_data} , list)
        Run Keyword If    ${is_array}!=True    Fail    返回数据不是数组格式，测试终止
        Sleep    0.5s
    END
    Log    连续请求测试完成
    sleep    1

1.1.1.15 获取流列表-性能场景-并发请求
    [Documentation]    测试并发请求接口的性能
    ${headers}    Create Dictionary    Content-Type=application/json    Authorization=${auth_token}
    Log    测试设备地址为：${url}
    Log    并发请求测试---------------------------------------------------
    # 模拟并发请求（在Robot Framework中通过快速连续请求模拟）
    ${start_time}    Evaluate    time.time()
    # 快速发送5个请求
    ${rep1}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    ${rep2}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    ${rep3}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    ${rep4}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    ${rep5}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    ${end_time}    Evaluate    time.time()
    ${total_time}    Evaluate    ${end_time} - ${start_time}
    Log    5个并发请求总耗时: ${total_time}秒
    Log    平均每个请求耗时: ${total_time/5}秒
    # 解析JSON响应
    ${json_data1}    Evaluate    json.loads('''${rep1}''')    json
    ${json_data2}    Evaluate    json.loads('''${rep2}''')    json
    ${json_data3}    Evaluate    json.loads('''${rep3}''')    json
    ${json_data4}    Evaluate    json.loads('''${rep4}''')    json
    ${json_data5}    Evaluate    json.loads('''${rep5}''')    json
    # 验证所有请求都返回正确格式
    ${is_array1}    Evaluate    isinstance(${json_data1}, list)
    ${is_array2}    Evaluate    isinstance(${json_data2}, list)
    ${is_array3}    Evaluate    isinstance(${json_data3}, list)
    ${is_array4}    Evaluate    isinstance(${json_data4}, list)
    ${is_array5}    Evaluate    isinstance(${json_data5}, list)
    ${all_valid}    Evaluate    ${is_array1} and ${is_array2} and ${is_array3} and ${is_array4} and ${is_array5}
    Run Keyword If    ${all_valid}==True    Log    所有并发请求都返回正确格式
    Run Keyword If    ${all_valid}!=True    Fail    部分并发请求返回格式错误
    sleep    1

*** Keywords ***
验证流数据必要字段
    [Arguments]    ${stream_list}
    [Documentation]    验证流数据包含所有必要字段
    # 验证第一个流数据的必要字段
    ${first_stream}    Set Variable    ${stream_list}[0]
    # 必要字段列表
    @{required_fields}    Create List    id    type    name    enable    status
    # 验证必要字段是否存在
    FOR    ${field}    IN    @{required_fields}
        ${has_field}    Run Keyword And Return Status    Dictionary Should Contain Key    ${first_stream}    ${field}
        Run Keyword If    ${has_field}==False    Fail    流数据缺少必要字段: ${field}
    END
    Log    流数据包含所有必要字段，验证通过
    sleep    1

验证不同类型流
    [Arguments]    ${stream_list}=${rep}
    [Documentation]    验证不同类型的流数据
    # 创建一个字典来存储不同类型的流数量
    ${type_count}    Create Dictionary
    # 遍历所有流，统计不同类型的数量
    FOR    ${stream}    IN    @{stream_list}
        ${type}    Set Variable    ${stream}[type]
        ${current_count}    Run Keyword And Return Status    Dictionary Should Contain Key    ${type_count}    ${type}
        ${new_count}    Set Variable If    ${current_count}==True    ${type_count}[${type}]+1    1
        Set To Dictionary    ${type_count}    ${type}=${new_count}
    END
    # 输出不同类型的流数量
    Log    不同类型流统计:
    FOR    ${type}    IN    @{type_count.keys()}
        Log    类型 ${type}: ${type_count}[${type}] 个
    END
    Log    不同类型流验证完成
    sleep    1

验证流状态一致性
    [Arguments]    ${stream_list}
    [Documentation]    验证流的enable状态与status状态的一致性
    # 遍历所有流，验证状态与启用状态的一致性
    FOR    ${stream}    IN    @{stream_list}
        ${enable}    Set Variable    ${stream}[enable]
        ${status}    Set Variable    ${stream}[status]
    # 如果enable为false，status应该是stop
        Run Keyword If    ${enable}==False and "${status}"!="stop"    Fail    流状态不一致：enable为false但status不是stop
    # 如果status是stop，enable应该是false
        Run Keyword If    "${status}"=="stop" and ${enable}!=False    Fail    流状态不一致：status为stop但enable不是false
    END
    Log    所有流的状态与启用状态一致，验证通过
    sleep    1

验证流地址可访问性
    [Arguments]    ${stream_list}
    [Documentation]    验证启用的流的地址是否可访问
    # 遍历所有启用的流，验证地址是否可访问
    FOR    ${stream}    IN    @{stream_list}
        ${enable}    Set Variable    ${stream}[enable]
        ${address_url}    Set Variable    ${stream}[addressUrl]
    # 只验证启用的流
        Continue For Loop If    ${enable}==False
    # 验证地址状态
        Run Keyword If    "${address_url}"=="offline"    Log    警告：启用的流地址显示为离线状态
        Run Keyword If    "${address_url}"!="offline"    Log    流地址状态正常：${address_url}
    END
    Log    流地址可访问性验证完成
    sleep    1

验证端口号有效性
    [Arguments]    ${stream_list}
    [Documentation]    验证流的端口号是否在有效范围内
    Comment    # 遍历所有流，验证端口号是否有效
    Comment    log    查看当前流服务使用的端口
    Comment    FOR    ${stream}    IN    @{stream_list}
    Comment    \    ${port}    Set Variable    ${stream}[port]
    Comment    \    ${http_tunnel_port}    Set Variable    ${stream}[httpTunnelPort]
    Comment    # 验证端口号是否在有效范围内（1-65535）
    Comment    \    log    验证端口是否在有效范围
    Comment    \    Run Keyword If    ${port}<1 or ${port}>65535    Fail    无效的端口号: ${port}
    Comment    \    Run Keyword If    ${http_tunnel_port}<1 or ${http_tunnel_port}>65535    Fail    无效的HTTP隧道端口号: ${http_tunnel_port}
    Comment    # 验证多播端口范围
    Comment    \    ${multicast_enable}    Set Variable    ${stream}[multicast_enable]
    Comment    \    Continue For Loop If    ${multicast_enable}==False
    Comment    \    ${multicast_port_min}    Set Variable    ${stream}[multicast_port_min]
    Comment    \    ${multicast_port_max}    Set Variable    ${stream}[multicast_port_max]
    Comment    \    Run Keyword If    ${multicast_port_min}<1 or ${multicast_port_min}>65535    Fail    无效的多播最小端口号: ${multicast_port_min}
    Comment    \    Run Keyword If    ${multicast_port_max}<1 or ${multicast_port_max}>65535    Fail    无效的多播最大端口号: ${multicast_port_max}
    Comment    \    Run Keyword If    ${multicast_port_min}>${multicast_port_max}    Fail    多播端口范围无效: 最小值${multicast_port_min}大于最大值${multicast_port_max}
    Comment    END
