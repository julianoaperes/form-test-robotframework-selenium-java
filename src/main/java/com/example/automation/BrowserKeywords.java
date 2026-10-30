package com.example.automation;

import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.List;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;

public class BrowserKeywords {

    private WebDriver driver;
    private WebDriverWait wait;

    public void openBrowser(String url) {
        closeBrowser();

        ChromeOptions options = new ChromeOptions();
        options.addArguments("--window-size=1440,1000");

        if (Boolean.parseBoolean(System.getenv("HEADLESS"))) {
            options.addArguments("--headless=new");
        }

        driver = new ChromeDriver(options);
        wait = new WebDriverWait(driver, Duration.ofSeconds(15));

        driver.get(url);
        visible(By.name("my-text"));
    }

    private WebElement visible(By locator) {
        return wait.until(
            ExpectedConditions.visibilityOfElementLocated(locator)
        );
    }

    public void fillField(String name, String text) {
        WebElement field = visible(By.name(name));
        field.clear();
        field.sendKeys(text);
    }

    public void enterText(String text) {
        fillField("my-text", text);
    }

    public String getFieldValue(String name) {
        return driver.findElement(By.name(name))
            .getDomProperty("value");
    }

    public String getFieldAttribute(String name, String attribute) {
        String value = driver.findElement(By.name(name))
            .getDomAttribute(attribute);

        return value == null ? "" : value;
    }

    public boolean isFieldEnabled(String name) {
        return driver.findElement(By.name(name)).isEnabled();
    }

    public boolean isFieldDisplayed(String name) {
        return driver.findElement(By.name(name)).isDisplayed();
    }

    public void attemptToTypeIntoField(String name, String text) {
        visible(By.name(name)).sendKeys(text);
    }

    public void submitForm() {
        wait.until(
            ExpectedConditions.elementToBeClickable(
                By.cssSelector("button[type='submit']")
            )
        ).click();
    }

    public String getConfirmationMessage() {
        return visible(By.id("message")).getText();
    }

    public void selectDropdownOption(String optionText) {
        Select dropdown = new Select(
            visible(By.name("my-select"))
        );

        dropdown.selectByVisibleText(optionText);
    }

    public void selectDropdownValue(String value) {
        Select dropdown = new Select(
            visible(By.name("my-select"))
        );

        dropdown.selectByValue(value);
    }

    public String getSelectedDropdownOption() {
        Select dropdown = new Select(
            visible(By.name("my-select"))
        );

        return dropdown.getFirstSelectedOption().getText();
    }

    public List<String> getDropdownOptions() {
        Select dropdown = new Select(
            visible(By.name("my-select"))
        );

        return dropdown.getOptions()
            .stream()
            .map(WebElement::getText)
            .toList();
    }

    public List<String> getDatalistOptions() {
        return driver.findElements(
            By.cssSelector("#my-options option")
        ).stream()
            .map(option -> option.getDomProperty("value"))
            .toList();
    }

    public void setCheckbox(String id, boolean selected) {
        WebElement checkbox = wait.until(
            ExpectedConditions.elementToBeClickable(By.id(id))
        );

        if (checkbox.isSelected() != selected) {
            checkbox.click();
        }
    }

    public boolean isControlSelected(String id) {
        return visible(By.id(id)).isSelected();
    }

    public void selectRadio(String id) {
        wait.until(
            ExpectedConditions.elementToBeClickable(By.id(id))
        ).click();
    }

    public void uploadFile(String filePath) {
        Path file = Path.of(filePath).toAbsolutePath().normalize();

        if (!Files.isRegularFile(file)) {
            throw new IllegalArgumentException(
                "Upload file does not exist: " + file
            );
        }

        driver.findElement(By.name("my-file"))
            .sendKeys(file.toString());
    }

    public String getUploadedFileName() {
        return (String) ((JavascriptExecutor) driver).executeScript(
            "return arguments[0].files.length "
                + "? arguments[0].files[0].name : '';",
            driver.findElement(By.name("my-file"))
        );
    }

    public void setColor(String color) {
        if (!color.matches("#[0-9a-fA-F]{6}")) {
            throw new IllegalArgumentException(
                "Color must use the format #RRGGBB"
            );
        }

        // Set the HTML control's value without opening the OS dialog.
        ((JavascriptExecutor) driver).executeScript(
            "arguments[0].value = arguments[1];"
                + "arguments[0].dispatchEvent("
                + "new Event('input', {bubbles: true}));"
                + "arguments[0].dispatchEvent("
                + "new Event('change', {bubbles: true}));",
            visible(By.name("my-colors")),
            color
        );
    }

    public void openDatePicker() {
        visible(By.name("my-date")).click();
    }

    public boolean isDatePickerDisplayed() {
        return visible(
            By.cssSelector(".datepicker-dropdown")
        ).isDisplayed();
    }

    public void enterDate(String date) {
        fillField("my-date", date);
        visible(By.name("my-date")).sendKeys(Keys.TAB);
    }

    public void setRange(int value) {
        if (value < 0 || value > 10) {
            throw new IllegalArgumentException(
                "Range value must be between 0 and 10"
            );
        }

        WebElement range = visible(By.name("my-range"));

        range.sendKeys(Keys.HOME);

        for (int index = 0; index < value; index++) {
            range.sendKeys(Keys.ARROW_RIGHT);
        }
    }

    public void returnToIndex() {
        wait.until(
            ExpectedConditions.elementToBeClickable(
                By.linkText("Return to index")
            )
        ).click();

        wait.until(
            ExpectedConditions.urlMatches(
                ".*/index\\.html(?:[?#].*)?$"
            )
        );
    }

    public String getCurrentUrl() {
        return driver.getCurrentUrl();
    }

    public void closeBrowser() {
        if (driver != null) {
            try {
                driver.quit();
            } finally {
                driver = null;
                wait = null;
            }
        }
    }
}