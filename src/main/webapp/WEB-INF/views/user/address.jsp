<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Sổ địa chỉ | AISTHÉA</title>
                <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
                    rel="stylesheet" />
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
                <script>
                    tailwind.config = {
                        darkMode: "class",
                        theme: {
                            extend: {
                                colors: {
                                    primary: "#0056b3",
                                    "primary-dark": "#004494",
                                    "accent-gold": "#C5A059",
                                    "glass-light": "rgba(255, 255, 255, 0.7)",
                                    "glass-border": "rgba(255, 255, 255, 0.5)",
                                    "glass-input": "rgba(255, 255, 255, 0.4)",
                                },
                                fontFamily: {
                                    display: ["'Playfair Display'", "serif"],
                                    body: ["'Inter'", "sans-serif"],
                                },
                                backgroundImage: {
                                    'ethereal-sky': "linear-gradient(180deg, #F8FAFC 0%, #E0F2FE 100%)",
                                },
                                boxShadow: {
                                    'glass': '0 8px 32px 0 rgba(31, 38, 135, 0.07)',
                                    'glass-sm': '0 4px 16px 0 rgba(31, 38, 135, 0.05)',
                                    'glow-gold': '0 0 15px rgba(197, 160, 89, 0.3)',
                                }
                            },
                        },
                    };
                </script>
                <style>
                    .glass-island {
                        background: rgba(255, 255, 255, 0.65);
                        backdrop-filter: blur(20px);
                        -webkit-backdrop-filter: blur(20px);
                        border: 1px solid rgba(255, 255, 255, 0.8);
                        box-shadow: 0 20px 40px -10px rgba(0, 86, 179, 0.05);
                    }

                    .marble-texture {
                        background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.05'/%3E%3C/svg%3E");
                        opacity: 0.4;
                        pointer-events: none;
                    }

                    .nav-item-active {
                        color: #0056b3;
                        font-weight: 600;
                    }

                    .nav-subitem-active {
                        color: #0056b3 !important;
                        font-weight: 600 !important;
                    }

                    ::-webkit-scrollbar {
                        width: 8px;
                    }

                    ::-webkit-scrollbar-track {
                        background: transparent;
                    }

                    ::-webkit-scrollbar-thumb {
                        background: rgba(0, 86, 179, 0.2);
                        border-radius: 4px;
                    }

                    ::-webkit-scrollbar-thumb:hover {
                        background: rgba(0, 86, 179, 0.4);
                    }

                    details>summary {
                        list-style: none;
                    }

                    details>summary::-webkit-details-marker {
                        display: none;
                    }

                    .rotate-chevron {
                        transform: rotate(180deg);
                    }

                    details[open] summary .chevron {
                        transform: rotate(180deg);
                    }

                    .gold-border-glow {
                        box-shadow: 0 0 0 1px #C5A059, 0 0 12px rgba(197, 160, 89, 0.4);
                    }
                </style>
            </head>

            <body
                class="bg-ethereal-sky font-body min-h-screen text-slate-800 relative selection:bg-primary/20 selection:text-primary">
                <div class="fixed inset-0 z-0">
                    <div class="absolute inset-0 bg-gradient-to-br from-white via-sky-50 to-blue-100 opacity-80"></div>
                    <div class="absolute inset-0 marble-texture"></div>
                    <div
                        class="absolute top-0 right-0 w-[500px] h-[500px] bg-blue-200/20 rounded-full blur-3xl translate-x-1/2 -translate-y-1/2">
                    </div>
                    <div
                        class="absolute bottom-0 left-0 w-[600px] h-[600px] bg-sky-100/30 rounded-full blur-3xl -translate-x-1/4 translate-y-1/4">
                    </div>
                </div>

                <!-- Header -->
                <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                <main class="relative z-10 max-w-7xl mx-auto px-4 pb-20 pt-10">
                    <div class="flex flex-col lg:flex-row gap-8">
                        <!-- Sidebar -->
                        <jsp:include page="/WEB-INF/views/common/user-sidebar.jsp">
                            <jsp:param name="activeTab" value="address" />
                        </jsp:include>
                        <section class="lg:w-3/4">
                            <div class="glass-island rounded-[32px] p-8 lg:p-12 min-h-[700px] relative overflow-hidden">
                                <div
                                    class="absolute top-0 right-0 w-[400px] h-[400px] bg-gradient-to-b from-blue-50/80 to-transparent rounded-bl-full pointer-events-none">
                                </div>
                                <div class="relative z-10">
                                    <div
                                        class="flex flex-col md:flex-row md:items-center justify-between mb-8 pb-6 border-b border-slate-200/60 gap-4">
                                        <div>
                                            <h1 class="font-display font-bold text-3xl text-slate-900 tracking-tight">Sổ
                                                địa chỉ</h1>
                                            <p class="text-slate-500 font-light text-sm tracking-wide mt-1">Quản lý danh
                                                sách địa chỉ nhận hàng của bạn</p>
                                        </div>
                                        <button onclick="openModal('add')"
                                            class="flex items-center bg-primary text-white px-5 py-2.5 rounded-lg shadow-md hover:bg-primary-dark transition-all duration-300 group">
                                            <span
                                                class="material-symbols-outlined text-[20px] mr-2 transition-transform group-hover:rotate-90">add</span>
                                            <span class="text-sm font-semibold tracking-wide">Thêm địa chỉ mới</span>
                                        </button>
                                    </div>

                                    <c:if test="${not empty sessionScope.error}">
                                        <div
                                            class="mb-6 p-4 rounded-lg bg-red-50 border border-red-200 text-red-600 flex items-center gap-3">
                                            <span class="material-symbols-outlined">error</span>
                                            <p class="text-sm font-medium">${sessionScope.error}</p>
                                        </div>
                                        <c:remove var="error" scope="session" />
                                    </c:if>

                                    <div class="space-y-6">
                                        <c:choose>
                                            <c:when test="${empty addresses}">
                                                <div class="text-center py-10">
                                                    <span
                                                        class="material-symbols-outlined text-slate-300 text-5xl mb-3">location_off</span>
                                                    <p class="text-slate-500 font-medium">Bạn chưa lưu địa chỉ nào.</p>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="addr" items="${addresses}">
                                                    <div
                                                        class="relative bg-white/80 rounded-lg p-6 border ${addr.isDefault ? 'border-blue-200 shadow-md' : 'border-slate-100 shadow-sm hover:shadow-md hover:border-blue-100'} transition-all duration-300">
                                                        <div
                                                            class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-4">
                                                            <div class="flex items-center gap-3 mb-2 sm:mb-0">
                                                                <h3 class="font-bold text-slate-800 text-lg">
                                                                    ${addr.fullName}</h3>
                                                                <span
                                                                    class="inline-flex items-center text-slate-500 text-sm border-l border-slate-300 pl-3">${addr.phone}</span>
                                                            </div>
                                                            <div class="flex items-center gap-4 text-sm">
                                                                <button type="button" onclick="openModal(this)"
                                                                    data-id="${addr.addressId}"
                                                                    data-fullname="<c:out value='${addr.fullName}' />"
                                                                    data-phone="<c:out value='${addr.phone}' />"
                                                                    data-address="<c:out value='${addr.detailedAddress}' />"
                                                                    data-isdefault="${addr.isDefault}"
                                                                    class="text-primary hover:text-primary-dark font-medium hover:underline decoration-primary/30 underline-offset-4">Chỉnh
                                                                    sửa</button>

                                                                <!-- Delete Button -->
                                                                <button type="button"
                                                                    onclick="openDeleteModal('${addr.addressId}')"
                                                                    class="text-slate-500 hover:text-red-500 font-medium transition-colors">Xóa</button>
                                                            </div>
                                                        </div>
                                                        <div
                                                            class="flex flex-col sm:flex-row justify-between items-start gap-4">
                                                            <div
                                                                class="text-slate-600 text-sm leading-relaxed max-w-2xl">
                                                                ${addr.detailedAddress}
                                                            </div>

                                                            <c:choose>
                                                                <c:when test="${addr.isDefault}">
                                                                    <span
                                                                        class="inline-block px-3 py-1 rounded border border-accent-gold/40 bg-amber-50 text-accent-gold text-xs font-semibold uppercase tracking-wider whitespace-nowrap">Mặc
                                                                        định</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/address"
                                                                        method="POST" class="inline">
                                                                        <input type="hidden" name="action"
                                                                            value="setDefault">
                                                                        <input type="hidden" name="addressId"
                                                                            value="${addr.addressId}">
                                                                        <button type="submit"
                                                                            class="px-3 py-1 rounded border border-slate-200 text-slate-400 text-xs font-medium hover:border-primary hover:text-primary transition-colors whitespace-nowrap">Thiết
                                                                            lập mặc định</button>
                                                                    </form>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>
                </main>

                <!-- Footer -->
                <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                <!-- Address Modal -->
                <div id="addressModal" class="fixed inset-0 z-50 hidden">
                    <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" onclick="closeModal()"></div>
                    <div
                        class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[90%] max-w-lg bg-white rounded-2xl shadow-xl overflow-hidden p-8 animate-fade-in-up">
                        <div class="flex justify-between items-center mb-6">
                            <h2 id="modalTitle" class="font-display font-bold text-2xl text-slate-900">Thêm Tòa Nhà/Địa
                                Chỉ</h2>
                            <button onclick="closeModal()"
                                class="text-slate-400 hover:text-slate-600 transition-colors">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>

                        <form id="addressForm" action="${pageContext.request.contextPath}/address" method="POST"
                            class="space-y-4">
                            <input type="hidden" name="action" id="formAction" value="add">
                            <input type="hidden" name="addressId" id="modalAddressId" value="0">

                            <div class="space-y-1">
                                <label class="block text-xs font-bold text-slate-500 uppercase tracking-widest">Họ &
                                    Tên</label>
                                <input type="text" name="fullName" id="modalFullName" required
                                    class="w-full bg-slate-50 border-slate-200 rounded-lg focus:ring-primary focus:border-primary px-4 py-3 text-sm">
                            </div>

                            <div class="space-y-1">
                                <label class="block text-xs font-bold text-slate-500 uppercase tracking-widest">Số Điện
                                    Thoại</label>
                                <input type="text" name="phone" id="modalPhone" required
                                    pattern="(84|0[3|5|7|8|9])+([0-9]{8})"
                                    title="Số điện thoại không hợp lệ. Vui lòng nhập 10 số, bắt đầu bằng 0 (VD: 0912345678)"
                                    class="w-full bg-slate-50 border-slate-200 rounded-lg focus:ring-primary focus:border-primary px-4 py-3 text-sm">
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                <div class="space-y-1">
                                    <label
                                        class="block text-xs font-bold text-slate-500 uppercase tracking-widest">Tỉnh/Thành
                                        Phố</label>
                                    <select name="province" id="modalProvince" required
                                        class="w-full bg-slate-50 border-slate-200 rounded-lg focus:ring-primary focus:border-primary px-4 py-3 text-sm">
                                        <option value="">Chọn Tỉnh/Thành Phố</option>
                                    </select>
                                </div>
                                <div class="space-y-1">
                                    <label
                                        class="block text-xs font-bold text-slate-500 uppercase tracking-widest">Phường/Xã</label>
                                    <select name="ward" id="modalWard" required disabled
                                        class="w-full bg-slate-50 border-slate-200 rounded-lg focus:ring-primary focus:border-primary px-4 py-3 text-sm">
                                        <option value="">Chọn Phường/Xã</option>
                                    </select>
                                </div>
                            </div>

                            <div class="space-y-1 mt-4">
                                <label class="block text-xs font-bold text-slate-500 uppercase tracking-widest">Số Nhà,
                                    Tên Đường</label>
                                <input type="text" name="street" id="modalStreet" required
                                    class="w-full bg-slate-50 border-slate-200 rounded-lg focus:ring-primary focus:border-primary px-4 py-3 text-sm"
                                    placeholder="VD: Số 12 Đường Lê Lợi, Lô B Tòa nhà..."
                                    pattern="^(?=.*[a-zA-Z\u00C0-\u1EF9])(?=.*\d)[a-zA-Z0-9\u00C0-\u1EF9\s,.\-\/]+$"
                                    title="Vui lòng nhập định dạng có cả số nhà và tên đường (VD: 123 Lê Lợi).">
                            </div>

                            <div class="flex items-center gap-2 pt-2">
                                <input type="checkbox" name="isDefault" id="modalIsDefault"
                                    class="w-4 h-4 text-primary border-slate-300 rounded focus:ring-primary cursor-pointer">
                                <label for="modalIsDefault"
                                    class="text-sm font-medium text-slate-700 cursor-pointer">Đặt làm địa chỉ mặc
                                    định</label>
                            </div>

                            <div class="flex gap-4 pt-6">
                                <button type="button" onclick="closeModal()"
                                    class="flex-1 px-4 py-3 border border-slate-200 bg-white text-slate-600 font-semibold rounded-lg hover:bg-slate-50 transition-colors">
                                    Hủy Bỏ
                                </button>
                                <button type="submit"
                                    class="flex-1 px-4 py-3 bg-primary text-white font-semibold rounded-lg shadow hover:bg-primary-dark transition-colors">
                                    Lưu Địa Chỉ
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Delete Confirmation Modal -->
                <div id="deleteModal" class="fixed inset-0 z-[60] hidden">
                    <div class="absolute inset-0 bg-black/40 backdrop-blur-sm" onclick="closeDeleteModal()"></div>
                    <div
                        class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[90%] max-w-sm bg-white rounded-2xl shadow-xl overflow-hidden p-8 animate-fade-in-up">
                        <div class="flex flex-col items-center text-center">
                            <div class="w-16 h-16 bg-red-50 rounded-full flex items-center justify-center mb-4">
                                <span class="material-symbols-outlined text-red-500 text-3xl">warning</span>
                            </div>
                            <h2 class="font-display font-bold text-2xl text-slate-900 mb-2">Xóa Địa Chỉ</h2>
                            <p class="text-slate-500 mb-6 text-sm">Bạn có chắc chắn muốn xóa địa chỉ này không? Hành
                                động này không thể hoàn tác.</p>

                            <form action="${pageContext.request.contextPath}/address" method="POST"
                                class="w-full flex gap-4">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="addressId" id="deleteAddressId" value="0">

                                <button type="button" onclick="closeDeleteModal()"
                                    class="flex-1 px-4 py-3 border border-slate-200 bg-white text-slate-600 font-semibold rounded-lg hover:bg-slate-50 transition-colors text-sm">
                                    Hủy Bỏ
                                </button>
                                <button ~type="submit"
                                    class="flex-1 px-4 py-3 bg-red-500 text-white font-semibold rounded-lg shadow hover:bg-red-600 transition-colors text-sm">
                                    Xóa
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    let allProvincesData = [];

                    async function fetchAllData() {
                        try {
                            const response = await fetch('https://provinces.open-api.vn/api/?depth=3');
                            allProvincesData = await response.json();
                            populateProvinces();
                        } catch (error) {
                            console.error('Lỗi tải dữ liệu địa chỉ:', error);
                        }
                    }

                    function populateProvinces() {
                        const provSelect = document.getElementById('modalProvince');
                        provSelect.innerHTML = '<option value="">Chọn Tỉnh/Thành Phố</option>';
                        allProvincesData.forEach(p => {
                            const opt = document.createElement('option');
                            opt.value = p.name;
                            opt.setAttribute('data-code', p.code);
                            opt.textContent = p.name;
                            provSelect.appendChild(opt);
                        });
                    }

                    document.getElementById('modalProvince').addEventListener('change', function () {
                        const wardSelect = document.getElementById('modalWard');
                        wardSelect.innerHTML = '<option value="">Chọn Phường/Xã</option>';
                        wardSelect.disabled = true;

                        if (!this.value) return;

                        const code = parseInt(this.options[this.selectedIndex].getAttribute('data-code'));
                        const province = allProvincesData.find(p => p.code === code);
                        if (!province || !province.districts) return;

                        const allWards = [];
                        province.districts.forEach(d => {
                            if (d.wards) d.wards.forEach(w => allWards.push(w));
                        });
                        allWards.sort((a, b) => a.name.localeCompare(b.name, 'vi'));

                        allWards.forEach(w => {
                            const opt = document.createElement('option');
                            opt.value = w.name;
                            opt.textContent = w.name;
                            wardSelect.appendChild(opt);
                        });
                        wardSelect.disabled = false;
                    });

                    async function openModal(modeOrElement) {
                        const modal = document.getElementById('addressModal');
                        const title = document.getElementById('modalTitle');
                        const formAction = document.getElementById('formAction');

                        if (allProvincesData.length === 0) await fetchAllData();

                        if (modeOrElement === 'add') {
                            document.getElementById('addressForm').reset();
                            document.getElementById('modalAddressId').value = 0;
                            document.getElementById('modalWard').disabled = true;
                            title.textContent = 'Thêm Địa Chỉ Mới';
                            formAction.value = 'add';
                        } else {
                            const el = modeOrElement;
                            document.getElementById('modalAddressId').value = el.getAttribute('data-id');
                            document.getElementById('modalFullName').value = el.getAttribute('data-fullname');
                            document.getElementById('modalPhone').value = el.getAttribute('data-phone');
                            document.getElementById('modalIsDefault').checked = el.getAttribute('data-isdefault') === 'true';

                            const fullAddress = el.getAttribute('data-address');
                            if (fullAddress) {
                                const parts = fullAddress.split(',').map(s => s.trim());
                                if (parts.length >= 3) {
                                    document.getElementById('modalStreet').value = parts.slice(0, parts.length - 2).join(', ');
                                    const province = parts[parts.length - 1];
                                    const ward = parts[parts.length - 2];

                                    const provSelect = document.getElementById('modalProvince');
                                    provSelect.value = province;
                                    provSelect.dispatchEvent(new Event('change'));
                                    document.getElementById('modalWard').value = ward;
                                } else {
                                    document.getElementById('modalStreet').value = fullAddress;
                                }
                            }

                            title.textContent = 'Cập Nhật Địa Chỉ';
                            formAction.value = 'update';
                        }
                        modal.classList.remove('hidden');
                    }

                    // Pre-fetch on load
                    fetchAllData();

                    function closeModal() {
                        const modal = document.getElementById('addressModal');
                        if (modal) modal.classList.add('hidden');
                    }

                    function openDeleteModal(addressId) {
                        const modal = document.getElementById('deleteModal');
                        if (modal) {
                            document.getElementById('deleteAddressId').value = addressId;
                            modal.classList.remove('hidden');
                        }
                    }

                    function closeDeleteModal() {
                        const modal = document.getElementById('deleteModal');
                        if (modal) modal.classList.add('hidden');
                    }
                </script>

            </body>

            </html>