from robot.libraries.Remote import Remote


class JavaRemote(Remote):
    """Handle missing special documentation in remote library metadata."""

    def get_keyword_documentation(self, name):
        try:
            return super().get_keyword_documentation(name)
        except KeyError:
            if name == "__intro__":
                return "Java Selenium keywords exposed through the remote server."
            if name == "__init__":
                return "Connect to the Java keyword server."
            raise