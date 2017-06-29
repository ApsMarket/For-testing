*** Settings ***
Library           Selenium2Library
Library           String
Library           DateTime

*** Test Cases ***
Создать допороговый тендер
    Close All Browsers
    Open Browser    http://93.183.211.107:90    chrome
    Comment    Open Browser    http://192.168.90.169:90    chrome
    #Логин
    Wait Until Page Contains Element    xpath=.//*[@id='liLoginNoAuthenticated']/a
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=.//div[@class='page-loader animated fadeIn']    30
    Click Element    xpath=.//*[@id='liLoginNoAuthenticated']/a
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=.//div[@class='page-loader animated fadeIn']    30
    Click Element    id=butLoginPartial
    Wait Until Element Is Visible    id=Email
    Input Text    id=Email    qa1@gmail.com
    Input Password    id=Password    qwerty123
    Click Button    id=submitLogin
    #Створити
    Wait Until Element Is Enabled    id=btn_create_purchase
    Click Button    id=btn_create_purchase
    Wait Until Element Is Visible    id=url_create_purchase_0
    Click Element    id=url_create_purchase_0
    #Название
    Wait Until Element Is Enabled    id=title
    Input Text    id=title    Testing
    #Валюта
    Select From List By Label    id=select_currencies    UAH
    #Бюджет
    Wait Until Element Is Visible    id=budget
    Input Text    id=budget    15973
    Wait Until Element Is Visible    id=min_step_percentage
    Input Text    id=min_step_percentage    2
    #Дата/Время
    Set DataTime    period_enquiry_start    0
    Set DataTime    period_enquiry_end    +48 hour
    Set DataTime    period_tender_start    +48 hour
    Set DataTime    period_tender_end    +72 hour
    #След шаг
    Click Element    id=createOrUpdatePurchase
    Wait Until Element Is Visible    id=next_step    15
    Wait Until Element Is Enabled    id=next_step    20
    Click Button    id=next_step
    #Добавить позицию
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=.//div[@class='page-loader animated fadeIn']
    Wait Until Element Is Visible    id=add_procurement_subject0    20
    Click Button    id=add_procurement_subject0
    Input Text    id=procurementSubject_description00    ТЕСТ
    Input Text    id=procurementSubject_quantity00    12
    Select From List By Label    id=select_unit00    літр
    #ДК
    Wait Until Element Is Visible    id=cls_click_
    Wait Until Element Is Enabled    id=cls_click_
    Click Button    id=cls_click_
    Wait Until Element Is Visible    id=search-classifier-text
    Press Key    id=search-classifier-text    09000000-3
    Wait Until Element Is Enabled    //*[@id='tree']//li[@aria-selected="true"]    30
    Wait Until Element Is Visible    id=add-classifier
    Click Button    id=add-classifier
    #ДК другие
    Wait Until Element Is Visible    id=btn_otherClassifier
    Click Button    id=btn_otherClassifier
    Wait Until Element Is Visible    id=search-classifier-text
    Press Key    id=search-classifier-text    000
    Wait Until Element Is Not Visible    xpath=//div[@class="modal-backdrop fade"]    5
    Wait Until Element Is Visible    id=add-classifier
    Click Button    id=add-classifier
    #Дата поставки
    Set DataTime    id=delivery_start_00    +48 hour
    Set DataTime    id=delivery_end_00    +72 hour
    #След шаг
    Wait Until Element Is Visible    id=update_00
    Click Button    id=update_00
    Wait Until Element Is Enabled    id=next_step
    Click Button    id=next_step
    #опубликовать
    публикация
    [Teardown]    Close All Browsers

*** Keywords ***
Set DataTime
    [Arguments]    ${dd}    ${delta}
    ${dt}=    Get Current Date    result_format=%Y-%m-%d %H:%M    increment=${delta}    exclude_millis=True
    Log To Console    ${dt}
    Comment    Run Keyword If    ${dt.minute}==${0}
    Comment    ${dt}=    Set Variable    ${dt.year}-${dt.month}-${dt.day} ${dt.hour}:${dt.minute}
    Log To Console    ${dt}
    ${id}    Replace String    ${dd}    id=    ${EMPTY}
    ${ddd}=    Set Variable    SetDateTimePickerValue(\'${id}\',\'${dt}\');
    Execute Javascript    ${ddd}

публикация
    Execute Javascript    window.scroll(0, -1500)
    Run Keyword And Ignore Error    Wait Until Element Is Visible    id=save_changes
    Run Keyword And Ignore Error    Click Button    id=save_changes
    Wait Until Element Is Enabled    id=movePurchaseView
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=.//div[@class='page-loader animated fadeIn']
    Click Button    id=movePurchaseView
    Wait Until Page Contains Element    id=publishPurchase    50
    Wait Until Element Is Enabled    id=publishPurchase
    ${id}=    Get Location
    Log To Console    ${id}
    sleep    2
    Click Button    id=publishPurchase
    Wait Until Page Contains Element    id=purchaseProzorroId    90
    Comment    Wait Until Element Is Visible    id=purchaseProzorroId    20
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=.//div[@class='page-loader animated fadeIn']
    ${tender_UID}=    Get Text    xpath=//span[@id='purchaseProzorroId']
    sleep    2
    Log To Console    publish tender ${tender_UID}
