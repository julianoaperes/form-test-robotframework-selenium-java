package com.example.automation;

import org.robotframework.remoteserver.RemoteServer;

public class RobotServer {

    public static void main(String[] args) throws Exception {
        RemoteServer.configureLogging();

        RemoteServer server = new RemoteServer(
            "127.0.0.1",
            8270
        );

        server.putLibrary(
            "/browser",
            new BrowserKeywords()
        );

        server.start();

        System.out.println(
            "Java keywords available at "
                + "http://127.0.0.1:8270/browser"
        );
    }
}