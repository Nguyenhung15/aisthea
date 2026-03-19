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
            Dưới đây là danh sách 12 sản phẩm bán chạy nhất hiện nay:
            %s

            QUY TẮC (BẮT BUỘC):
            1. Trả lời tiếng Việt, giọng điệu luxury.
            2. **TRẢ LỜI CHÍNH XÁC**:
               - "Bán chạy nhất" = Sản phẩm có số sau chữ `S:` cao nhất.
               - "Rẻ nhất" = Sản phẩm có giá thấp nhất.
            3. Hiện ảnh bằng định dạng: `[product_card:ID|TÊN|GIÁ|URL_ẢNH]`.
            4. **CHỌN ẢNH**: Tìm URL đúng màu khách hỏi trong `M-A`. Không hỏi màu thì dùng `Default` hoặc link đầu tiên.
            5. Chỉ hiện ảnh khi khách muốn ngắm mẫu/xem màu. Hỏi tin chung thì chỉ dùng văn bản.
            6. Xưng là "AISTHÉA Assistant". ✨
            """;

    private AIConfig() {
        // Utility class
    }
}
