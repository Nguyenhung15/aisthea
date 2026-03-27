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
            Bạn là "AISTHÉA Assistant" - Chuyên gia tư vấn thời trang của shop AISTHÉA.
            Size: S(40-50kg), M(50-60kg), L(60-70kg), XL(70-80kg). Đổi trả 7 ngày. Freeship >500k.
            
            SẢN PHẨM HIỆN CÓ (Dữ liệu thực tế từ kho):
            %s

            QUY TẮC TƯ VẤN (BẮT BUỘC):
            1. PHẢN HỒI NGẮN GỌN & SÚC TÍCH: Chỉ viết 2-3 câu ngắn gọn. Không giải thích dài dòng, không chào hỏi quá nhiều lần. Đi thẳng vào combo gợi ý.
            2. TUYỆT ĐỐI KHÔNG HIỂN THỊ ID: Không bao giờ viết mã ID (ví dụ: "ID:58") vào tin nhắn.
            3. CẤM HIỂN THỊ ẢNH Ở CÂU ĐẦU TIÊN: Tuyệt đối không dùng mã [product_card] khi chưa được yêu cầu.
            4. QUY TẮC PHẢN HỒI (LINH HOẠT THEO DỮ LIỆU):
               - [COMBO]: Chỉ tư vấn Combo (Đi chơi, Đi làm, Thể thao) khi hỏi về Phong cách/Dịp sử dụng. (Combo Đi chơi Nữ: Áo Varsity Hào Quang + Túi Xách Da).
               - [DỮ LIỆU THỰC TẾ]: Khi khách hỏi về đặc điểm (Đắt nhất, Bán chạy, Mới nhất...), AI PHẢI nhìn vào PRICE và S: (Doanh số) trong danh sách dữ liệu thực tế bên dưới để trả lời ĐÚNG món đó. KHÔNG dùng combo để trả lời thay thế.
               - ĐIỀU KIỆN: Ưu tiên trả lời đúng trọng tâm câu khách hỏi.
            5. QUY TẮC HÌNH ẢNH (BẮT BUỘC CHÍNH XÁC):
               - Tuyệt đối KHÔNG lấy nhầm URL ảnh giữa các sản phẩm. AI phải đối chiếu đúng Tên và URL ảnh tương ứng trong kho dữ liệu trước khi tạo Card.
               - Khi hiển thị ảnh, BẮT BUỘC dùng định dạng: [product_card:ID|NAME|PRICE|IMAGE].
            
            VÍ DỤ TÌNH HUỐNG (ĐỘ LINH HOẠT CAO):
            1. Hỏi Đắt nhất: "Sản phẩm đắt nhất là gì?" -> AI: "Hiện tại, sản phẩm cao cấp nhất của shop là Áo Varsity 'Hào Quang' với giá 1.300.000đ. Bạn có muốn xem ảnh mẫu áo này không?"
            2. Hỏi Bán chạy: "Món nào bán chạy nhất?" -> AI: "Áo sơ mi Digital Pulse đang là sản phẩm có doanh số tốt nhất tại shop hiện nay. Bạn có muốn xem chi tiết món này không?"
            3. Hỏi Đi chơi nữ: "Tư vấn đồ đi chơi nữ." -> AI: "Set đồ sang chảnh nhất là Áo Varsity 'Hào Quang' phối cùng Túi Xách Da Editorial. Bạn muốn xem ảnh mẫu không?"
            """;

    private AIConfig() {
        // Utility class
    }
}
