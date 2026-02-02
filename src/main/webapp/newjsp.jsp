<%@ page import="com.aisthea.fashion.service.CategoryService" %>
<%@ page import="com.aisthea.fashion.model.Category" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Test Gender và Category</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <h2 class="mt-4">Test Gender và Category</h2>
            <form action="${pageContext.request.contextPath}/product?action=insert" method="post">
                <!-- Thông tin cơ bản -->
                <div class="mb-3">
                    <label for="genderId" class="form-label">Giới tính</label>
                    <select id="genderId" name="genderId" class="form-select" required>
                        <option value="">-- Chọn giới tính --</option>
                        <option value="1">Nam</option>
                        <option value="2">Nữ</option>
                    </select>
                </div>

                <!-- Danh mục cha -->
                <div class="mb-3">
                    <label for="parentCategory" class="form-label">Danh mục cha</label>
                    <select id="parentCategory" name="parentCategory" class="form-select" required>
                        <option value="">-- Chọn danh mục cha --</option>
                    </select>
                </div>

                <!-- Danh mục con -->
                <div class="mb-3">
                    <label for="subCategory" class="form-label">Danh mục con</label>
                    <select id="subCategory" name="categoryid" class="form-select" required>
                        <option value="">-- Chọn danh mục con --</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Lưu sản phẩm</button>
            </form>
        </div>

        <script>
            // Khi người dùng chọn giới tính
document.getElementById('genderId').addEventListener('change', function () {
    const genderId = this.value;  // Lấy giá trị của genderId từ select
    console.log("Giới tính đã chọn: ", genderId);  // Kiểm tra xem genderId có giá trị hợp lệ không
    const parentSelect = document.getElementById('parentCategory');
    const subSelect = document.getElementById('subCategory');
    parentSelect.innerHTML = '<option value="">-- Chọn danh mục cha --</option>';
    subSelect.innerHTML = '<option value="">-- Chọn danh mục con --</option>';
    
    // Nếu không chọn giới tính thì không làm gì
    if (!genderId) return;

    // Kiểm tra URL và mã hóa tham số
    const url = `/AistheaFashion/product?action=getParentByGender&genderid=${genderId}`;
    console.log("URL gọi AJAX:", url);  // Kiểm tra URL

    // Gửi yêu cầu AJAX để lấy danh mục cha theo genderid
    fetch(url)
        .then(response => response.json())
        .then(data => {
            if (Array.isArray(data) && data.length > 0) {
                data.forEach(category => {
                    const option = document.createElement("option");
                    option.value = category.categoryid;
                    option.textContent = category.name;
                    parentSelect.appendChild(option);
                });
            } else {
                console.error("Không có danh mục cha.");
            }
        })
        .catch(error => {
            console.error('Lỗi khi lấy danh mục cha:', error);
            alert('Không thể lấy danh mục cha!');
        });
});
            // Khi người dùng chọn danh mục cha
            document.getElementById('parentCategory').addEventListener('change', function () {
                const parentId = this.value;
                const subSelect = document.getElementById('subCategory');
                subSelect.innerHTML = '<option value="">-- Chọn danh mục con --</option>';

                // Nếu không chọn danh mục cha thì không làm gì
                if (!parentId)
                    return;

                // Gửi yêu cầu AJAX để lấy danh mục con theo parentId
                fetch(`/AistheaFashion/product?action=getChildren&parentid=${parentId}`)
                        .then(response => response.json())
                        .then(data => {
                            if (Array.isArray(data) && data.length > 0) {
                                // Thêm danh mục con vào dropdown
                                data.forEach(category => {
                                    const option = document.createElement("option");
                                    option.value = category.categoryid;
                                    option.textContent = category.name;
                                    subSelect.appendChild(option);
                                });
                            } else {
                                console.error("Không có danh mục con.");
                            }
                        })
                        .catch(error => {
                            console.error('Lỗi khi lấy danh mục con:', error);
                            alert('Không thể lấy danh mục con!');
                        });
            });
        </script>

    </body>
</html>