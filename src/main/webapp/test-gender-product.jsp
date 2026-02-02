<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Test Gender ID</title>
    <script>
        // Ki?m tra và g?i yêu c?u khi ch?n gi?i tính
        function sendGenderId() {
            const genderSelect = document.getElementById('genderid');
            const genderId = genderSelect.value;

            if (!genderId) {
                alert('Vui lòng ch?n gi?i tính.');
                return;
            }

            // In ra ?? ki?m tra giá tr? genderid
            console.log("Gi?i tính ?ã ch?n: ", genderId);

            // G?i yêu c?u v?i genderid qua fetch
            fetch(`/product?action=getParentByGender&genderid=${genderId}`)
                .then(response => response.json())  // Chuy?n d? li?u nh?n v? thành JSON
                .then(data => {
                    console.log('D? li?u nh?n ???c t? server:', data);
                    // Hi?n th? d? li?u t? server
                    if (data.error) {
                        alert('L?i t? server: ' + data.error);
                    } else {
                        alert('D? li?u danh m?c cha: ' + JSON.stringify(data));
                    }
                })
                .catch(error => {
                    console.error('L?i khi g?i yêu c?u:', error);
                    alert('Có l?i khi g?i yêu c?u!');
                });
        }
    </script>
</head>
<body>

    <h2>Ki?m tra g?i gi?i tính</h2>
    <label for="genderid">Ch?n gi?i tính:</label>
    <select id="genderid">
        <option value="">-- Ch?n gi?i tính --</option>
        <option value="1">Nam</option>
        <option value="2">N?</option>
    </select>

    <button onclick="sendGenderId()">G?i gi?i tính</button>

</body>
</html>