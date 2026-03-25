import java.nio.file.*;
public class DivCount {
    public static void main(String[] args) throws Exception {
        String content = new String(Files.readAllBytes(Paths.get("src/main/webapp/WEB-INF/views/cart/checkout.jsp")), "UTF-8");
        int idx = content.indexOf("id=\"discount-drawer\"");
        int end = content.indexOf("<!-- Footer -->", idx);
        String sub = content.substring(idx, end);
        int d = sub.split("<div").length - 1;
        int ed = sub.split("</div").length - 1;
        System.out.println("Start divs: " + d);
        System.out.println("End divs: " + ed);
    }
}
