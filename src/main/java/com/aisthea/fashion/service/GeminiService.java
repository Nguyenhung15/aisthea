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

    private static final String API_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent";

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
            3. Trả lời chính xác và đầy đủ (Tên + Giá). Chỉ chào hỏi khi khách nhắn tin đầu tiên ("Xin chào", v.v.). Nếu đang trong cuộc nói chuyện, không cần chào lại.
            4. **QUAN TRỌNG**: Bạn được cung cấp danh sách sản phẩm thực tế ("Dữ liệu sản phẩm thực tế từ cửa hàng"). Khi trả lời, hãy trích dẫn **Đúng Tên Đầy Đủ** và **Giá Niêm Yết** từ danh sách này.
            5. KHÔNG trả lời các câu hỏi không liên quan đến thời trang, mua sắm, hoặc AISTHÉA — lịch sự từ chối
            6. Sử dụng emoji phù hợp một cách tiết chế ✨
            7. Khi chào hỏi, xưng là "AISTHÉA Assistant"
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
     * Send a chat message with history to Gemini and get a reply.
     *
     * @param userMessage    The current user message
     * @param history        List of previous messages
     * @param productContext Optional text containing actual product data from DB
     * @return AI reply text
     */
    public String chat(String userMessage, List<Map<String, String>> history, String productContext) throws IOException {

        JsonObject requestBody = new JsonObject();

        // System Instruction (v1beta support)
        String finalSystemPrompt = SYSTEM_PROMPT;
        if (productContext != null && !productContext.isBlank()) {
            finalSystemPrompt += "\n\n## Dữ liệu sản phẩm thực tế từ cửa hàng:\n" + productContext;
        }

        JsonObject systemInstruction = new JsonObject();
        JsonArray siParts = new JsonArray();
        JsonObject siPart = new JsonObject();
        siPart.addProperty("text", finalSystemPrompt);
        System.out.println("[GeminiService] Final System Prompt Length: " + finalSystemPrompt.length());
        siParts.add(siPart);
        systemInstruction.add("parts", siParts);
        requestBody.add("system_instruction", systemInstruction);

        // Build contents array (conversation history + current message)
        JsonArray contents = new JsonArray();

        // Add history
        if (history != null) {
            for (Map<String, String> msg : history) {
                JsonObject content = new JsonObject();
                content.addProperty("role", msg.get("role")); // "user" or "model"
                JsonArray parts = new JsonArray();
                JsonObject part = new JsonObject();
                part.addProperty("text", msg.get("text"));
                parts.add(part);
                content.add("parts", parts);
                contents.add(content);
            }
        }

        // Add current user message (Clean message, instructions are in system_instruction)
        JsonObject userContent = new JsonObject();
        userContent.addProperty("role", "user");
        JsonArray userParts = new JsonArray();
        JsonObject userPart = new JsonObject();
        userPart.addProperty("text", userMessage);
        userParts.add(userPart);
        userContent.add("parts", userParts);
        contents.add(userContent);

        requestBody.add("contents", contents);

        // Generation config
        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.4); 
        generationConfig.addProperty("maxOutputTokens", 2048); // Increased from 1024
        requestBody.add("generationConfig", generationConfig);

        // Make API call
        System.out.println("[GeminiService] Calling API: " + API_URL + " (v1beta latest fix)");
        String url = API_URL + "?key=" + apiKey;
        RequestBody body = RequestBody.create(gson.toJson(requestBody), JSON_MEDIA);
        Request request = new Request.Builder()
                .url(url)
                .post(body)
                .build();

        try (Response response = httpClient.newCall(request).execute()) {
            String responseBody = response.body() != null ? response.body().string() : "";
            
            if (!response.isSuccessful()) {
                System.err.println("[GeminiService] API Failed: " + responseBody);
                throw new IOException("Gemini API error " + response.code() + ": " + responseBody);
            }

            JsonObject jsonResponse = gson.fromJson(responseBody, JsonObject.class);

            // Extract text from response (Handle multiple parts)
            if (jsonResponse.has("candidates") && jsonResponse.getAsJsonArray("candidates").size() > 0) {
                JsonObject candidate = jsonResponse.getAsJsonArray("candidates").get(0).getAsJsonObject();
                
                // Debug finish reason
                if (candidate.has("finishReason")) {
                    System.out.println("[GeminiService] Finish Reason: " + candidate.get("finishReason").getAsString());
                }

                if (candidate.has("content") && candidate.getAsJsonObject("content").has("parts")) {
                    JsonArray parts = candidate.getAsJsonObject("content").getAsJsonArray("parts");
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < parts.size(); i++) {
                        sb.append(parts.get(i).getAsJsonObject().get("text").getAsString());
                    }
                    return sb.toString();
                }
            }
            
            if (jsonResponse.has("promptFeedback")) {
                return "Xin lỗi, câu hỏi của bạn vi phạm quy tắc an toàn của AI. Vui lòng hỏi câu khác! 🙏";
            } else {
                return "Xin lỗi, tôi gặp chút trục trặc khi xử lý câu trả lời. Bạn thử lại nhé!";
            }
        } catch (Exception e) {
            System.err.println("[GeminiService] Error: " + e.getMessage());
            throw e;
        }
    }
}
