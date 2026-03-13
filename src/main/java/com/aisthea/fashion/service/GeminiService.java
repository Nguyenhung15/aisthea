package com.aisthea.fashion.service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

import java.io.IOException;
import java.util.concurrent.TimeUnit;
import java.util.List;
import java.util.Map;

/**
 * Service for calling Google Gemini API.
 * Uses OkHttp (already in pom.xml) for HTTP requests and Gson for JSON.
 */
public class GeminiService {

    private static final String API_URL = "https://api.groq.com/openai/v1/chat/completions";

    private static final MediaType JSON_MEDIA = MediaType.parse("application/json; charset=utf-8");

    private static final String SYSTEM_PROMPT = """
            Bạn là **AISTHÉA Assistant** — trợ lý AI chính thức của thương hiệu thời trang cao cấp AISTHÉA.

            ## Về AISTHÉA
            - Thương hiệu thời trang luxury, phong cách hiện đại, sang trọng
            - Sản phẩm: áo, quần, váy, đầm, áo khoác, phụ kiện cho cả Nam và Nữ
            - Website: AISTHÉA Fashion Store

            ## Chính sách cửa hàng
            - **Đổi trả**: Trong vòng 7 ngày kể từ khi nhận hàng, sản phẩm còn nguyên tag
            - **Vận chuyển**: Giao hàng toàn quốc, miễn phí cho đơn từ 500.000đ
            - **Thanh toán**: Hỗ trợ thanh toán trực tuyến qua PayOS và thanh toán khi nhận hàng (COD)
            - **Voucher/Khuyến mãi**: Có chương trình khách hàng thân thiết theo tier (Bronze, Silver, Gold, Platinum)

            ## Hướng dẫn Size (tham khảo)
            - **S**: 40-50kg, cao 150-160cm
            - **M**: 50-60kg, cao 155-165cm
            - **L**: 60-70kg, cao 160-170cm
            - **XL**: 70-80kg, cao 165-175cm

            ## Quy tắc trả lời
            1. Luôn trả lời bằng tiếng Việt (trừ khi khách hỏi bằng tiếng Anh)
            2. Giọng điệu: thân thiện, chuyên nghiệp, sang trọng — không quá suồng sã
            3. Trả lời chính xác và đầy đủ. Chỉ chào hỏi khi khách nhắn tin đầu tiên.
            4. **SẢN PHẨM BÁN CHẠY & GỢI Ý**:
               - "Sản phẩm bán chạy" là những sản phẩm có **Số lượng đã bán** cao nhất trong danh sách dữ liệu.
               - Khi khách hỏi về sản phẩm hot, bán chạy, hãy dựa vào số liệu "Số lượng đã bán" để giới thiệu (vd: "Đây là mẫu áo được săn đón nhất với hơn ... lượt mua").
               - Nếu các sản phẩm đều có số lượng bán bằng 0, hãy gợi ý các sản phẩm mới nhất hoặc cao cấp nhất dựa trên giá tiền.
               - Hãy giới thiệu một cách tự nhiên, chuyên nghiệp và thuyết phục.
            5. **QUY TẮC VỀ MÀU SẮC & HÌNH ẢNH (BẮT BUỘC)**:
               - **TUYỆT ĐỐI KHÔNG** gửi đường link URL thô (ví dụ: https://...).
               - **PHẢI LUÔN** đóng gói hình ảnh vào thẻ sản phẩm theo định dạng: `[product_card:ID|TÊN - MÀU|GIÁ|URL_ẢNH]`.
               - Khi khách muốn xem màu cụ thể:
                 + Tìm đúng URL ảnh của màu đó.
                 + Trả về: `[product_card:ID|Tên Sản Phẩm - Màu|Giá|URL_Ảnh]`.
               - Nếu khách hỏi chung chung về sản phẩm, hãy dùng ảnh mặc định (Default) và cũng phải để trong thẻ `product_card`.
               - LUÔN luôn ưu tiên hiển thị hình ảnh để khách hàng dễ hình dung.
            6. KHÔNG trả lời các câu hỏi không liên quan đến thời trang — lịch sự từ chối
            7. Sử dụng emoji phù hợp một cách tiết chế ✨
            8. Khi chào hỏi, xưng là "AISTHÉA Assistant"
            """;

    private final String apiKey;
    private final OkHttpClient httpClient;
    private final Gson gson;

    public GeminiService(String apiKey) {
        this.apiKey = apiKey;
        this.httpClient = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .build();
        this.gson = new Gson();
    }

    /**
     * Send a chat message with history to Groq (Llama 3) and get a reply.
     */
    public String chat(String userMessage, List<Map<String, String>> history, String productContext)
            throws IOException {

        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("model", "llama-3.1-8b-instant"); // Model nhanh, hạn mức cao, ổn định cho chat bán hàng

        JsonArray messages = new JsonArray();

        // 1. Add System Message
        String finalSystemPrompt = SYSTEM_PROMPT;
        if (productContext != null && !productContext.isBlank()) {
            finalSystemPrompt += "\n\n## Dữ liệu sản phẩm thực tế từ cửa hàng:\n" + productContext;
        }
        JsonObject systemMsg = new JsonObject();
        systemMsg.addProperty("role", "system");
        systemMsg.addProperty("content", finalSystemPrompt);
        messages.add(systemMsg);

        // 2. Add History
        if (history != null) {
            for (Map<String, String> msg : history) {
                JsonObject m = new JsonObject();
                // Chuyển role từ Gemini (model) sang chuẩn OpenAI (assistant)
                String role = "model".equalsIgnoreCase(msg.get("role")) ? "assistant" : "user";
                m.addProperty("role", role);
                m.addProperty("content", msg.get("text"));
                messages.add(m);
            }
        }

        // 3. Add Current Message
        JsonObject userMsg = new JsonObject();
        userMsg.addProperty("role", "user");
        userMsg.addProperty("content", userMessage);
        messages.add(userMsg);

        requestBody.add("messages", messages);
        requestBody.addProperty("temperature", 0.2);
        requestBody.addProperty("max_tokens", 2048);

        // Make API call
        System.out.println("[GroqService] Calling API: " + API_URL + " with Llama 3");
        RequestBody body = RequestBody.create(gson.toJson(requestBody), JSON_MEDIA);
        Request request = new Request.Builder()
                .url(API_URL)
                .addHeader("Authorization", "Bearer " + apiKey)
                .post(body)
                .build();

        try (Response response = httpClient.newCall(request).execute()) {
            String responseBody = response.body() != null ? response.body().string() : "";

            if (!response.isSuccessful()) {
                String errorMsg = "Groq API error " + response.code() + ": " + responseBody;
                System.err.println("[GroqService] " + errorMsg);
                throw new IOException(errorMsg);
            }

            JsonObject jsonResponse = gson.fromJson(responseBody, JsonObject.class);

            if (jsonResponse.has("choices") && jsonResponse.getAsJsonArray("choices").size() > 0) {
                JsonObject choice = jsonResponse.getAsJsonArray("choices").get(0).getAsJsonObject();
                if (choice.has("message") && choice.getAsJsonObject("message").has("content")) {
                    return choice.getAsJsonObject("message").get("content").getAsString();
                }
            }

            return "Xin lỗi, tôi gặp chút trục trặc khi xử lý câu trả lời. Bạn thử lại nhé!";
        } catch (Exception e) {
            System.err.println("[GroqService] Error: " + e.getMessage());
            throw e;
        }
    }
}
