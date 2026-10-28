*** Settings ***
Library         Remote    http://127.0.0.1:8270/browser
Test Teardown   closeBrowser

*** Variables ***
${URL}          https://www.selenium.dev/selenium/web/web-form.html
${INPUT_TEXT}   Hello from Robot Framework and Java!

*** Test Cases ***
Submit Form Successfully
    openBrowser    ${URL}
    enterText    ${INPUT_TEXT}
    submitForm
    ${message}=    getConfirmationMessage
    Should Be Equal    ${message}    Received!