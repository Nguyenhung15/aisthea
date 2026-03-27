package com.aisthea.fashion.config;

/**
 * Centralized configuration for the AI Chat feature.
 * Reads dynamically from application.properties / environment variables via AppConfig.
 */
public class AIConfig {

    /** Groq API Key (priority: Env variable → application.properties → null) */
    public static String getApiKey() {
        return AppConfig.getProperty("ai.groq.api.key", "");
    }

    /** API endpoint URL */
    public static String getApiUrl() {
        return AppConfig.getProperty("ai.groq.endpoint", "https://api.groq.com/openai/v1/chat/completions");
    }

    /** AI Model (e.g., llama-3.1-8b-instant) */
    public static String getModel() {
        return AppConfig.getProperty("ai.groq.model", "llama-3.1-8b-instant");
    }

    /** Response creativity temperature (0.0 to 1.0) */
    public static double getTemperature() {
        String temp = AppConfig.getProperty("ai.groq.temperature", "0.2");
        try {
            return Double.parseDouble(temp);
        } catch (Exception e) {
            return 0.2;
        }
    }

    /** Maximum response tokens */
    public static int getMaxTokens() {
        return AppConfig.getPropertyAsInt("ai.groq.max.tokens", 2048);
    }

    // ─── HTTP Timeouts (seconds) ─────────────────────────────────────────────
    public static final int CONNECT_TIMEOUT = 30;
    public static final int READ_TIMEOUT    = 45;
    public static final int WRITE_TIMEOUT   = 30;

    // ─── System Prompt ───────────────────────────────────────────────────────
    public static final String SYSTEM_PROMPT = """
            Bạn là "AISTHÉA Assistant" của shop thời trang AISTHÉA.
            Size chuẩn: S(40-50kg), M(50-60kg), L(60-70kg), XL(70-80kg). Đổi trả 7 ngày. Freeship >500k.
            
            SẢN PHẨM HIỆN CÓ CỦA SHOP (Dữ liệu thực tế):
            %s

            QUY TẮC TỐI ƯU (BẮT BUỘC):
            1. Trả lời cực kỳ NGẮN GỌN, súc tích để tiết kiệm token. Đi thẳng vào vấn đề.
            2. QUY TẮC HIỂN THỊ ẢNH (`[product_card:ID|TÊN|GIÁ|URL_ẢNH]`):
               - CHỈ DÙNG ẢNH KHI: Khách chủ động yêu cầu "xem", "hình", hoặc hỏi "màu" cụ thể. Lấy đúng URL màu đó.
               - CẤM DÙNG ẢNH KHI: Khách chỉ hỏi "Giá bao nhiêu?", "Cái nào bán chạy?", "Đắt nhất/rẻ nhất?". (Chỉ dùng text trả lời).
            3. TƯ VẤN ĐÚNG NGỮ CẢNH:
               - Khi khách đưa thông tin thể trạng & tình huống (VD: "nam 50kg đi tập thể dục").
               - PHẢI PHÂN TÍCH: Tìm Size đúng thông số, ưu tiên Giới tính phù hợp, và chọn ĐÚNG KIỂU DÁNG cho mục đích đó (Đồ thun/quần đùi cho thể thao, không đưa đồ dự tiệc).
               - CHỈ CHỌN các sản phẩm thực sự có trong danh sách trên, TUYỆT ĐỐI KHÔNG bịa sản phẩm ngoài.
            """;

    private AIConfig() {
        // Utility class
    }
}
