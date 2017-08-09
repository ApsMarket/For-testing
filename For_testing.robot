*** Settings ***
Library           Selenium2Library
Library           String
Library           DateTime
Library           FakerLibrary

*** Test Cases ***
Создать допороговый тендер
    [Tags]    full_tender
    Close All Browsers
    Open Browser    https://test-gov.ald.in.ua    chrome
    Comment    Open Browser    http://192.168.90.169:90    chrome
    Set Window Position    0    0
    Set Window Size    1500    1000
    #Логин
    Авторизация
    #Створити
    Wait Until Element Is Enabled    id=btn_create_purchase
    Click Button    id=btn_create_purchase
    Wait Until Element Is Visible    id=url_create_purchase_1
    Click Element    id=url_create_purchase_1
    #Название
    Wait Until Element Is Enabled    id=title
    ${randomwords}=    FakerLibrary.Words    nb=3
    ${xxx}=    Generate Random String
    Input Text    id=title    ${randomwords[0]} ${randomwords[1]} ${randomwords[2]}_${xxx}
    #Валюта
    Select From List By Label    id=select_currencies    UAH
    #Бюджет
    Wait Until Element Is Visible    id=budget
    Input Text    id=budget    15973
    Wait Until Element Is Visible    id=min_step_percentage
    Input Text    id=min_step_percentage    2
    #Дата/Время
    Set DataTime    period_enquiry_start    0
    Set DataTime    period_enquiry_end    +24 hour
    Set DataTime    period_tender_start    +24 hour
    Set DataTime    period_tender_end    +168 hour
    #След шаг
    Click Element    id=createOrUpdatePurchase
    Log To Console    next step before position
    Wait Until Element Is Visible    id=next_step    15
    Wait Until Element Is Enabled    id=next_step    20
    Click Button    id=next_step
    #Добавить позицию
    Wait Until Element Is Visible    id=add_procurement_subject0    20
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=.//div[@class='page-loader animated fadeIn']    30
    Click Button    id=add_procurement_subject0
    ${randomwords1}=    FakerLibrary.Words    nb=2
    ${xxxx}=    Generate Random String
    Input Text    id=procurementSubject_description00    ${randomwords[0]} ${randomwords[1]}_${xxxx}
    Input Text    id=procurementSubject_quantity00    12
    Select From List By Label    id=select_unit00    літр
    Log To Console    add DK
    #ДК
    Wait Until Element Is Visible    id=cls_click_
    Wait Until Element Is Enabled    id=cls_click_
    Click Button    id=cls_click_
    Wait Until Element Is Visible    id=search-classifier-text
    Press Key    id=search-classifier-text    09000000-3
    Wait Until Element Is Enabled    //*[@id='tree']//li[@aria-selected="true"]    30
    Wait Until Element Is Visible    id=add-classifier
    Click Button    id=add-classifier
    Log To Console    add other DK
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
    Log To Console    next step before public
    Wait Until Element Is Visible    id=update_00
    Click Button    id=update_00
    Execute Javascript    window.scroll(-1000, -1000)
    Wait Until Element Is Enabled    id=next_step
    Click Button    id=next_step
    #опубликовать
    публикация
    [Teardown]    Close All Browsers

Загрузка главной страницы
    [Tags]    run
    Открытие главной страницы
    Close All Browsers
    [Teardown]    Close All Browsers

Отображение списка тендеров
    [Tags]    run
    Открытие главной страницы
    [Teardown]    Close All Browsers

Авторизация
    [Tags]    run
    Авторизация
    [Teardown]    Close All Browsers

Инфо до клика Наступний крок
    [Tags]    run
    [Setup]    Close All Browsers
    Открытие главной страницы
    Авторизация
    Выбор из меню створити
    Click Button    next_step

Сохранение черновика

Добавление позиции
    Открытие главной страницы
    Авторизация
    Выбор из меню створити
    Ввод текстовых данных название валюта
    Однолотовый тендер
    Ввод дат
    Click Button    next_step
    Переход на доб позиции
    Info item
    Классификаторы

*** Keywords ***
Set DataTime
    [Arguments]    ${dd}    ${delta}
    ${dt}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S    increment=${delta}
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
    Log    publish tender ${tender_UID}

Открытие главной страницы
    Open Browser    https://test-gov.ald.in.ua    chrome
    Set Window Position    0    0
    Set Window Size    1500    1000

Ввод текстовых данных название валюта
    #Название
    Wait Until Element Is Enabled    id=title
    ${xxx}=    Generate Random String
    Input Text    id=title    Testing_${xxx}
    #Валюта
    Select From List By Label    id=select_currencies    UAH

Авторизация
    Wait Until Page Contains Element    xpath=.//*[@id='liLoginNoAuthenticated']/a/i
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=.//div[@class='page-loader animated fadeIn']    30
    Click Element    xpath=.//*[@id='liLoginNoAuthenticated']/a/i
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=.//div[@class='page-loader animated fadeIn']    30
    Click Element    id=butLoginPartial
    Wait Until Element Is Visible    id=Email
    Input Text    id=Email    qa1@gmail.com
    Input Password    id=Password    qwerty123
    Click Button    id=submitLogin

Многолотовый тендер
    Log To Console    Выбор многолотовости
    Click Element    is_multilot
    Ввод дат

Ввод дат
    Log To Console    Дата/Время
    Set DataTime    period_enquiry_start    0
    Set DataTime    period_enquiry_end    +24 hour
    Set DataTime    period_tender_start    +24 hour
    Set DataTime    period_tender_end    +168 hour

Info item
    Wait Until Element Is Enabled    id=procurementSubject_description00
    ${xxx}=    Generate Random String
    Input Text    id=procurementSubject_description00    Testing_item_${xxx}
    ${random_numbers}=    Generate Random String    length=3    chars=[NUMBERS]
    Input Text    id=procurementSubject_quantity00    ${random_numbers}
    ${random_unit}=    Random Sample    ('4A', 'KWT', 'RM', 'KGM')    1
    Select From List By Value    id=select_unit00    ${random_unit[0]}
    [Teardown]    Close All Browsers

Однолотовый тендер
    Log To Console    Бюджет
    Wait Until Element Is Visible    id=budget
    Input Text    id=budget    15973
    Log To Console    Минимальный шаг
    Wait Until Element Is Visible    id=min_step_percentage
    Input Text    id=min_step_percentage    2

Классификаторы
    Comment    Full click    cls_click_
    Click Button    cls_click_
    Log To Console    after click on button

Выбор из меню створити
    Log To Console    Выбор процедуры из меню
    Click Button    btn_create_purchase
    Click Element    url_create_purchase_1

Адрес доставки

Сохранение изменений

Переход на доб позиции
    Full click    add_procurement_subject0

Full click
    [Arguments]    ${id_loc}
    Wait Until Page Contains Element    ${id_loc}
    Wait Until Element Is Enabled    ${id_loc}
    Wait Until Element Is Visible    ${id_loc}
    Click Element    ${id_loc}
