package info.krzeminski.server;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.util.Calendar;

public class SimpleHttpServer {
    private static final int port = 8081;

    public static void main(String[] args) {
        try {
            HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
            server.createContext("/ping", new PingHandler());
            server.createContext("/stress", new StressHandler());
            server.createContext("/", new HelloHandler());
            server.setExecutor(null);

            server.start();

            System.out.printf("Server started on port %s. Hit [ENTER] to stop.\n", port);

            try {
                System.in.read();
            } catch (Throwable ignored) {

            }
            server.stop(0);
            System.out.println("Server stopped");

        } catch (IOException e) {
            System.out.printf("Couldn't start server: %s", e.getMessage());
        }

    }


    static class PingHandler implements HttpHandler {

        @Override
        public void handle(HttpExchange httpExchange) throws IOException {
            SimpleHttpServer.logRequest(httpExchange);
            SimpleHttpServer.setHeaders(httpExchange);
            SimpleHttpServer.setBody(httpExchange, "OK");
        }
    }

    static class StressHandler implements HttpHandler {

        private static final int[] array = new int[10 * 1000];

        static {
            for (int i = 0; i < array.length; i++) {
                array[i] = i;
            }
        }

        @Override
        public void handle(HttpExchange httpExchange) throws IOException {
            SimpleHttpServer.logRequest(httpExchange);
            SimpleHttpServer.setHeaders(httpExchange);

            int result = 0;
            for (int i = 0; i < 1000 * 1000; i++) {
                for (int j = 0; j < array.length; j++) {
                    result += array[j];
                }
                for (int j = 0; j < array.length; j++) {
                    result ^= array[j];
                }
            }

            SimpleHttpServer.setBody(httpExchange, "OK: " + result);
        }
    }

    static class HelloHandler implements HttpHandler {

        @Override
        public void handle(HttpExchange httpExchange) throws IOException {
            SimpleHttpServer.logRequest(httpExchange);

            SimpleHttpServer.setHeaders(httpExchange);
            SimpleHttpServer.setBody(httpExchange, "Try /ping or /stress");
        }
    }


    /**
     * @param httpExchange
     */
    public static void logRequest(HttpExchange httpExchange) {
        System.out.printf("[%s] %s\n", Calendar.getInstance().getTime().toString(), httpExchange.getRequestURI().getPath());
    }

    /**
     * @param httpExchange
     */
    public static void setHeaders(HttpExchange httpExchange) {
        Headers h = httpExchange.getResponseHeaders();
        h.add("Content-type", "text/plain");
    }

    /**
     * @param httpExchange
     * @param response
     * @throws IOException
     */
    public static void setBody(HttpExchange httpExchange, String response) throws IOException {
        httpExchange.sendResponseHeaders(200, response.getBytes().length);
        OutputStream os = httpExchange.getResponseBody();
        os.write(response.getBytes());
        os.close();
    }
}