# Web Form Test Automation

Web UI automation for the [Selenium practice form](https://www.selenium.dev/selenium/web/web-form.html), using Robot Framework, Java, and Selenium WebDriver.

Scenarios use Robot Framework’s built-in Given/When/Then support. Cucumber is not required.

## Architecture

Robot Framework executes scenarios and assertions. A local Java remote server exposes browser keywords, which use Selenium WebDriver to control Chrome.

Execution flow:

1. Robot Framework reads `tests/form_test.robot`.
2. `resources/JavaRemote.py` connects to the Java server.
3. The server calls methods in `BrowserKeywords.java`.
4. Selenium interacts with Chrome.
5. Results return to Robot Framework for assertions and reporting.

The Python wrapper provides fallback documentation for missing special remote-library metadata entries, avoiding the `KeyError: '__intro__'` encountered during editor documentation discovery.

## Technology Stack

| Component                | Version |
| ------------------------ | ------- |
| Java compilation target  | 21      |
| Selenium Java            | 4.51.0  |
| Java Robot Remote Server | 4.1.1   |
| Robot Framework          | 7.5     |
| Robocop                  | 9.1.2   |
| Maven Compiler Plugin    | 3.13.0  |
| Exec Maven Plugin        | 3.5.0   |

Dependency versions are defined in `pom.xml` and `requirements.txt`.

## Prerequisites

- JDK 21 or newer
- Maven
- Python with pip and venv
- Google Chrome
- Git

The commands below use **Git Bash on Windows**.

The project was developed with JDK 22 and Python 3.13. Configure `JAVA_HOME` and ensure Java, Maven, Python, and Git are available on `PATH`.

Check your tools:

```bash
java -version
javac -version
mvn -version
python --version
git --version
```

ChromeDriver is normally managed automatically by Selenium Manager. Initial execution may require network access to download a compatible driver.

## Installation

Clone the repository:

```bash
git clone https://github.com/julianoaperes/form-test-robotframework-selenium-java.git
cd form-test-robotframework-selenium-java
```

Create and activate a Python virtual environment:

```bash
python -m venv .venv
source .venv/Scripts/activate
```

Install Python dependencies:

```bash
python -m pip install -r requirements.txt
```

Compile the Java source:

```bash
mvn compile
```

## Project Structure

| Path                                                        | Purpose                                            |
| ----------------------------------------------------------- | -------------------------------------------------- |
| `pom.xml`                                                   | Java dependencies and Maven build configuration    |
| `requirements.txt`                                          | Python dependencies                                |
| `src/main/java/com/example/automation/BrowserKeywords.java` | Selenium browser actions                           |
| `src/main/java/com/example/automation/RobotServer.java`     | Java keyword server entry point                    |
| `resources/JavaRemote.py`                                   | Remote-library documentation compatibility wrapper |
| `tests/form_test.robot`                                     | BDD-style scenarios and reusable Robot keywords    |
| `results/`                                                  | Generated execution reports and upload fixture     |
| `target/`                                                   | Generated Java build output                        |
| `.venv/`                                                    | Local Python environment                           |

Generated results, Java build output, and the virtual environment are excluded from version control.

## Running the Tests

Use two terminals opened in the project root.

### Terminal 1: Start the Java Server

```bash
mvn compile exec:java -Dexec.mainClass=com.example.automation.RobotServer
```

Wait for:

```text
Java keywords available at http://127.0.0.1:8270/browser
```

Leave this terminal running.

Restart the server after changing Java source code so the new classes are loaded.

### Terminal 2: Run Robot Framework

Activate the virtual environment:

```bash
source .venv/Scripts/activate
```

Run the complete suite:

```bash
python -m robot --outputdir results tests/form_test.robot
```

Each test opens a new Chrome session. Test teardown closes that session, including after an assertion failure.

### Run Selected Tests

Run smoke tests:

```bash
python -m robot --include smoke --outputdir results tests/form_test.robot
```

Run checkbox tests:

```bash
python -m robot --include checkbox --outputdir results tests/form_test.robot
```

Run one scenario by name:

```bash
python -m robot --test "Submit Form Successfully" --outputdir results tests/form_test.robot
```

Runs using the same output directory overwrite earlier reports.

## Headless Execution

Stop the Java server with `Ctrl + C`, then start it with:

```bash
HEADLESS=true mvn compile exec:java -Dexec.mainClass=com.example.automation.RobotServer
```

Run the Robot tests normally in the second terminal.

Headless mode is configured on the Java server process because that process creates Chrome.

## Test Coverage

| Area            | Checks                                                             |
| --------------- | ------------------------------------------------------------------ |
| Submission      | Confirmation message after submitting text                         |
| Text input      | Replacement and Unicode characters                                 |
| Password        | Entered value and password input type                              |
| Textarea        | Multiline content                                                  |
| Disabled input  | Disabled state and initial value                                   |
| Readonly input  | Attribute and resistance to typing                                 |
| Select dropdown | Default selection, options, selection by text and value            |
| Datalist        | Suggestions, suggested values, and custom text                     |
| File input      | Local file attachment and selected filename                        |
| Checkboxes      | Initial states, selection, deselection, and repeated state setting |
| Radio buttons   | Initial states and mutually exclusive selection                    |
| Color           | Default value and updated HTML control value                       |
| Date            | Calendar visibility and typed date                                 |
| Range           | Default, bounds, step, minimum, maximum, and intermediate value    |
| Hidden input    | Hidden state and input type                                        |
| Navigation      | Return-to-index link                                               |

### Coverage Limitations

- Color tests update the HTML input through JavaScript and dispatch input/change events. They do not operate the native OS color dialog.
- Datalist tests verify available suggestions and entered values. They do not operate the browser’s native suggestion popup.
- Date tests verify calendar visibility and typed input, rather than selecting a calendar day.
- The upload test verifies attachment to the file input, not server-side file storage.
- Execution targets Chrome. Cross-browser execution is not configured.
- Tests depend on the public practice page and its external assets being available.
- The Java server and Robot runner are expected to run on the same computer for local upload paths.
- The current server shares one keyword-library instance. Run the suite sequentially; parallel execution is not configured.

## Reports

Execution generates:

| File                  | Purpose                                 |
| --------------------- | --------------------------------------- |
| `results/report.html` | Execution summary                       |
| `results/log.html`    | Detailed keyword execution and failures |
| `results/output.xml`  | Machine-readable execution data         |

Open the results folder on Windows:

```bash
explorer.exe results
```

## VS Code Setup

Recommended extensions:

- RobotCode — Robot Framework Support
- Extension Pack for Java

Select the project interpreter using:

```text
Python: Select Interpreter
```

Choose the interpreter ending with:

```text
.venv\Scripts\python.exe
```

With Robocop installed, use **Shift + Alt + F** to format Robot files.

Keep the Java server running while RobotCode discovers remote keywords.

## Troubleshooting

### Connection Refused or Remote Keywords Not Found

Confirm the Java server is running at:

```text
http://127.0.0.1:8270/browser
```

List its available keywords:

```bash
python -c "from xmlrpc.client import ServerProxy; print('\n'.join(ServerProxy('http://127.0.0.1:8270/browser').get_keyword_names()))"
```

If the server exposes the keywords but VS Code still reports them as missing, run:

```text
RobotCode: Clear Cache and Restart Language Servers
```

Keep the Java server running during the refresh. Reloading the entire VS Code window may stop the server in its integrated terminal.

### Address Already in Use

Another process may already be using port `8270`.

Stop the previous keyword server before starting another instance.

### Documentation Error: KeyError '**intro**'

Ensure the suite imports the compatibility wrapper:

```robot
Library    ${CURDIR}/../resources/JavaRemote.py    http://127.0.0.1:8270/browser
```

With the server running, verify documentation generation:

```bash
python -m robot.libdoc resources/JavaRemote.py::http://127.0.0.1:8270/browser results/JavaRemote.html
```

### Maven Cannot Parse pom.xml

`pom.xml` must contain Maven XML beginning with `<project>` or an XML declaration.

Java source belongs in `.java` files, not in `pom.xml`.

### Incorrect Robot Spacing

Use at least two spaces between columns; this project uses four.

```robot
${actual}=    Get Confirmation Message
Should Be Equal    ${actual}    Received!
```

Formatting tools cannot always recover a missing separator. Review keyword names and arguments when a test fails.

### Style Warnings

Robocop reports naming, documentation, spacing, and file-size conventions. These are separate from test assertion failures.

## Development Workflow

1. Update local `main`.
2. Create a branch for the change.
3. Implement and review the changes.
4. Restart the Java server if Java code changed.
5. Execute the relevant tests.
6. Review staged changes, commit, and push.
7. Open a pull request targeting `main`.

Start from a clean working tree:

```bash
git switch main
git pull --ff-only origin main
git switch -c test/describe-your-change
```

Review changes before committing:

```bash
git status
git diff
git diff --staged
```

Use a new branch for follow-up changes after a PR has been merged.
