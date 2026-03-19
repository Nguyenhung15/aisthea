package com.aisthea.fashion.service;

import com.aisthea.fashion.config.AIConfig;
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
 * Service for calling the AI API (Groq/Llama).
 * Configuration is dynamically served by {@link AIConfig}.
 */
public class GeminiService {

    private static final MediaType JSON_MEDIA = MediaType.parse("application/json; charset=utf-8");

    private final String apiKey;
    private final OkHttpClient httpClient;
    private final Gson gson;

    public GeminiService() {
        // Automatically uses key from AIConfig (which checks env vars/properties)
        this.apiKey = AIConfig.getApiKey();
        this.httpClient = new OkHttpClient.Builder()
                .connectTimeout(AIConfig.CONNECT_TIMEOUT, TimeUnit.SECONDS)
                .readTimeout(AIConfig.READ_TIMEOUT,       TimeUnit.SECONDS)
                .writeTimeout(AIConfig.WRITE_TIMEOUT,     TimeUnit.SECONDS)
                .build();
        this.gson = new Gson();
    }

    /**
     * Send a chat message with history to the AI.
     */
    public String chat(String userMessage, List<Map<String, String>> history, String productContext)
            throws IOException {

        // Build system prompt
        String systemPromptContent = String.format(
                AIConfig.SYSTEM_PROMPT,
                productContext != null && !productContext.isBlank() ? productContext : "(Chưa có dữ liệu sản phẩm)"
        );

        JsonArray messages = new JsonArray();

        // 1. System message
        JsonObject systemMsg = new JsonObject();
        systemMsg.addProperty("role", "system");
        systemMsg.addProperty("content", systemPromptContent);
        messages.add(systemMsg);

        // 2. History
        if (history != null) {
            for (Map<String, String> msg : history) {
                String role = "model".equalsIgnoreCase(msg.get("role")) ? "assistant" : "user";
                JsonObject m = new JsonObject();
                m.addProperty("role", role);
                m.addProperty("content", msg.get("text"));
                messages.add(m);
            }
        }

        // 3. User message
        JsonObject userMsg = new JsonObject();
        userMsg.addProperty("role", "user");
        userMsg.addProperty("content", userMessage);
        messages.add(userMsg);

        // API Request Body
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("model",       AIConfig.getModel());
        requestBody.addProperty("temperature", AIConfig.getTemperature());
        requestBody.addProperty("max_tokens",  AIConfig.getMaxTokens());
        requestBody.add("messages", messages);

        RequestBody body = RequestBody.create(gson.toJson(requestBody), JSON_MEDIA);
        Request request = new Request.Builder()
                .url(AIConfig.getApiUrl())
                .addHeader("Authorization", "Bearer " + apiKey)
                .post(body)
                .build();

        try (Response response = httpClient.newCall(request).execute()) {
            String responseBodyStr = response.body() != null ? response.body().string() : "";

            if (!response.isSuccessful()) {
                throw new IOException("AI API error " + response.code() + ": " + responseBodyStr);
            }

            JsonObject jsonResponse = gson.fromJson(responseBodyStr, JsonObject.class);
            if (jsonResponse.has("choices") && jsonResponse.getAsJsonArray("choices").size() > 0) {
                return jsonResponse.getAsJsonArray("choices").get(0).getAsJsonObject()
                        .getAsJsonObject("message").get("content").getAsString();
            }
            return "Xin lỗi, tôi gặp chút trục trặc khi xử lý câu trả lời.";
        }
    }
}
