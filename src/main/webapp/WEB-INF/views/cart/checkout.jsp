<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>

            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Checkout | AISTHÉA</title>
                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;500;600&amp;family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&amp;display=swap"
                    rel="stylesheet" />
                <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                    rel="stylesheet" />
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script id="tailwind-config">        tailwind.config = {
                        darkMode: "class",
                        theme: {
                            extend: {
                                colors: {
                                    "primary": "#024acf",
                                    "accent-blue": "#0288D1",
                                    "background-light": "#f8f6f6",
                                    "background-dark": "#221610",
                                    "sky-subtle": "#E1F5FE",
                                },
                                fontFamily: {
                                    "display": ["Manrope", "sans-serif"],
                                    "serif": ["Playfair Display", "serif"]
                                },
                                borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
                            },
                        },
                    }</script>
                <style>
                    .glass-card {
                        background: rgba(255, 255, 255, 0.7);
                        backdrop-filter: blur(12px);
                        -webkit-backdrop-filter: blur(12px);
                        border: 1px solid rgba(2, 136, 209, 0.1);
                    }

                    .bg-ombre {
                        background: linear-gradient(135deg, #ffffff 0%, #E1F5FE 100%);
                    }

                    .custom-scrollbar::-webkit-scrollbar {
                        width: 4px;
                    }

                    .custom-scrollbar::-webkit-scrollbar-track {
                        background: transparent;
                    }

                    .custom-scrollbar::-webkit-scrollbar-thumb {
                        background: #e2e8f0;
                        border-radius: 10px;
                    }

                    /* Unify Header/Footer with Checkout Style */
                    #pl-nav {
                        background: rgba(255, 255, 255, 0.8) !important;
                        backdrop-filter: blur(12px);
                        -webkit-backdrop-filter: blur(12px);
                        border-bottom: 1px solid rgba(186, 230, 253, 0.5);
                    }

                    footer.bg-white {
                        background: rgba(255, 255, 255, 0.4) !important;
                        backdrop-filter: blur(8px);
                        border-top: 1px solid rgba(186, 230, 253, 0.5);
                    }
                </style>
            </head>

            <body class="font-display bg-ombre text-slate-900 min-h-screen">
                <!-- Navigation Header -->
                <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

                <main class="max-w-7xl mx-auto px-6 py-12">
                    <!-- Breadcrumbs -->
                    <nav class="flex items-center gap-2 text-xs uppercase tracking-widest text-slate-400 mb-10">
                        <a class="hover:text-accent-blue" href="${pageContext.request.contextPath}/cart">Cart</a>
                        <span class="material-icons-outlined text-sm">chevron_right</span>
                        <span class="text-slate-900 font-medium">Checkout</span>
                        <span class="material-icons-outlined text-sm">chevron_right</span>
                        <span>Confirmation</span>
                    </nav>

                    <form action="${pageContext.request.contextPath}/order" method="POST" id="checkoutForm">
                        <input type="hidden" name="action" value="placeorder">
                        <input type="hidden" name="voucherId" id="voucherIdInput"
                            value="${not empty sessionScope.appliedVoucher ? sessionScope.appliedVoucher.voucherId : ''}">
                        <input type="hidden" name="discountAmount" id="discountAmountInput"
                            value="${not empty sessionScope.appliedDiscount ? sessionScope.appliedDiscount : '0'}">

                        <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-start">
                            <!-- Left Section: Shipping & Payment -->
                            <div class="lg:col-span-7 space-y-8">

                                <c:if test="${not empty sessionScope.error}">
                                    <div
                                        class="bg-red-50 border-l-4 border-red-500 text-red-700 px-4 py-3 rounded shadow-sm mb-6 flex items-center gap-3">
                                        <span class="material-icons-outlined text-lg">error_outline</span>
                                        <span>${sessionScope.error}</span>
                                    </div>
                                    <c:remove var="error" scope="session" />
                                </c:if>

                                <!-- Shipping Address Section -->
                                <section>
                                    <h2 class="font-serif mb-6 text-slate-800 tracking-wide font-semibold text-3xl">
                                        Shipping Details</h2>
                                    <div class="glass-card rounded-xl p-8 space-y-6">
                                        <!-- Address Book (Collapsible Dropdown) -->
                                        <style>
                                            #addressDropdownList {
                                                max-height: 0;
                                                overflow: hidden;
                                                transition: max-height 0.35s cubic-bezier(0.4, 0, 0.2, 1);
                                            }

                                            #addressDropdownList.addr-open {
                                                max-height: 700px;
                                            }

                                            #addressChevron {
                                                transition: transform 0.3s ease;
                                            }

                                            #addressChevron.rotated {
                                                transform: rotate(180deg);
                                            }
                                        </style>

                                        <!-- Identify the default address to display initially -->
                                        <c:set var="defaultAddr" value="${null}" />
                                        <c:if test="${not empty userAddresses}">
                                            <c:forEach var="a" items="${userAddresses}">
                                                <c:if test="${a.isDefault && empty defaultAddr}">
                                                    <c:set var="defaultAddr" value="${a}" />
                                                </c:if>
                                            </c:forEach>
                                            <%-- Fallback: If no default marked, pick the first one from address book --%>
                                            <c:if test="${empty defaultAddr}">
                                                <c:set var="defaultAddr" value="${userAddresses[0]}" />
                                            </c:if>
                                        </c:if>

                                        <!-- Preview card (always visible, click to open list) -->
                                        <div id="selectedAddressPreview"
                                            class="flex items-center justify-between gap-3 px-4 py-3 rounded-xl border-2 border-accent-blue bg-white/50 cursor-pointer hover:bg-white/70 transition-all select-none"
                                            onclick="toggleAddressDropdown()">
                                            <div class="flex items-center gap-3 flex-1 min-w-0">
                                                <span
                                                    class="material-icons-outlined text-accent-blue text-xl flex-shrink-0">location_on</span>
                                                <div class="min-w-0">
                                                    <p id="previewName"
                                                        class="font-bold text-sm text-slate-800 truncate">
                                                        <c:choose>
                                                            <c:when test="${not empty defaultAddr}">
                                                                ${defaultAddr.fullName}
                                                                <span class="font-normal text-slate-500 ml-1">| ${defaultAddr.phone}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${sessionScope.user.fullname}
                                                                <span class="font-normal text-slate-500 ml-1">| ${sessionScope.user.phone}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                    <p id="previewAddress"
                                                        class="text-xs text-slate-500 mt-0.5 truncate">
                                                        <c:choose>
                                                            <c:when test="${not empty defaultAddr}">
                                                                ${defaultAddr.detailedAddress}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-amber-500 font-medium italic">Chưa có địa chỉ. Vui lòng thêm mới.</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="flex items-center gap-1.5 flex-shrink-0 text-accent-blue">
                                                <span
                                                    class="text-[10px] font-bold uppercase tracking-wider hidden sm:block">Thay
                                                    đổi</span>
                                                <span id="addressChevron"
                                                    class="material-icons-outlined text-xl">expand_more</span>
                                            </div>
                                        </div>

                                        <!-- Collapsible address list -->
                                        <div id="addressDropdownList">
                                            <div class="space-y-2 pt-2" id="addressSelectionContainer">
                                                <c:choose>
                                                    <c:when test="${not empty userAddresses}">
                                                        <c:forEach var="addr" items="${userAddresses}">
                                                            <label
                                                                class="address-option relative flex p-3.5 rounded-lg border-2 cursor-pointer transition-all ${addr.addressId == defaultAddr.addressId ? 'border-accent-blue bg-white/50' : 'border-slate-200 bg-white/20'}"
                                                                data-addr-name="${addr.fullName}"
                                                                data-addr-phone="${addr.phone}"
                                                                data-addr-address="${addr.detailedAddress}"
                                                                onclick="selectAddressFromLabel(this)">
                                                                <div class="flex items-center gap-3 w-full">
                                                                    <input type="radio" name="addressSelection"
                                                                        value="${addr.addressId}"
                                                                        class="flex-shrink-0 text-accent-blue focus:ring-accent-blue"
                                                                        ${addr.addressId == defaultAddr.addressId ? 'checked' : '' } />
                                                                    <div class="flex flex-col flex-1 min-w-0">
                                                                        <div class="flex items-center gap-2 flex-wrap">
                                                                            <span
                                                                                class="font-bold text-sm text-slate-800">${addr.fullName}</span>
                                                                            <span
                                                                                class="text-slate-400 text-xs">|</span>
                                                                            <span
                                                                                class="text-xs text-slate-500">${addr.phone}</span>
                                                                            <c:if test="${addr.isDefault}">
                                                                                <span
                                                                                    class="text-[9px] uppercase tracking-widest bg-accent-blue text-white px-1.5 py-0.5 rounded-full">Default</span>
                                                                            </c:if>
                                                                        </div>
                                                                        <span
                                                                            class="text-xs text-slate-500 mt-0.5 truncate">${addr.detailedAddress}</span>
                                                                    </div>
                                                                </div>
                                                            </label>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="p-4 text-center text-sm text-slate-500 italic bg-white/50 rounded-lg border border-dashed border-slate-300">
                                                            Bạn chưa có địa chỉ nhận hàng nào được lưu. Vui lòng chọn "Thêm địa chỉ giao hàng khác".
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>

                                                <!-- Add New Address -->
                                                <label
                                                    class="address-option relative flex p-3.5 rounded-lg border-2 border-dashed border-slate-300 bg-white/10 cursor-pointer hover:border-accent-blue hover:bg-white/20 transition-all"
                                                    onclick="toggleNewAddressForm(this)">
                                                    <div class="flex items-center gap-3 w-full">
                                                        <input type="radio" name="addressSelection" value="new"
                                                            class="flex-shrink-0 text-accent-blue focus:ring-accent-blue"
                                                            id="newAddressRadio" />
                                                        <span
                                                            class="font-semibold text-sm text-slate-600 flex items-center gap-1.5">
                                                            <span
                                                                class="material-icons-outlined text-base">add_circle_outline</span>
                                                            Thêm địa chỉ mới
                                                        </span>
                                                    </div>
                                                </label>
                                            </div>
                                        </div>

                                        <!-- Hidden New Address Form -->
                                        <div id="newAddressForm"
                                            class="hidden mt-4 p-5 border border-sky-100 bg-slate-50 rounded-xl space-y-4">
                                            <p class="text-sm font-semibold text-slate-800">New Address Details</p>
                                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                                <div class="space-y-1">
                                                    <label
                                                        class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold ml-1">Full
                                                        Name</label>
                                                    <input id="newFullName"
                                                        class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm placeholder:text-slate-400"
                                                        type="text" placeholder="John Doe"
                                                        oninput="updateHiddenFieldsFromNew()" />
                                                </div>
                                                <div class="space-y-1">
                                                    <label
                                                        class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold ml-1">Phone
                                                        Number</label>
                                                    <input id="newPhone"
                                                        class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm placeholder:text-slate-400"
                                                        type="tel" placeholder="0912345678"
                                                        oninput="updateHiddenFieldsFromNew()" />
                                                </div>
                                            </div>
                                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                                <div class="space-y-1">
                                                    <label
                                                        class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold ml-1">Tỉnh/Thành
                                                        Phố</label>
                                                    <select id="newProvince" onchange="updateHiddenFieldsFromNew()"
                                                        class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm">
                                                        <option value="">Chọn Tỉnh/Thành Phố</option>
                                                    </select>
                                                </div>
                                                <div class="space-y-1">
                                                    <label
                                                        class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold ml-1">Phường/Xã</label>
                                                    <select id="newWard" disabled onchange="updateHiddenFieldsFromNew()"
                                                        class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm">
                                                        <option value="">Chọn Phường/Xã</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="space-y-1">
                                                <label
                                                    class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold ml-1">Số
                                                    Nhà, Tên Đường</label>
                                                <input id="newDetailedAddress" oninput="updateHiddenFieldsFromNew()"
                                                    class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm placeholder:text-slate-400"
                                                    type="text" placeholder="VD: Số 12 Đường Lê Lợi, Lô B Tòa nhà..." />
                                            </div>
                                            <div class="flex items-center gap-2 mt-2">
                                                <input
                                                    class="w-4 h-4 text-accent-blue border-slate-300 rounded focus:ring-accent-blue"
                                                    id="saveNewAddress" name="saveNewAddress" type="checkbox"
                                                    value="true" />
                                                <label class="text-xs text-slate-600 font-medium"
                                                    for="saveNewAddress">Lưu địa chỉ này vào sổ địa chỉ</label>
                                            </div>
                                        </div>

                                        <!-- Hidden identity fields (default = địa chỉ mặc định từ DB, fallback về profile) -->
                                        <input type="hidden" name="fullname" id="hiddenFullname"
                                            value="<c:choose><c:when test='${not empty defaultAddr}'>${defaultAddr.fullName}</c:when><c:otherwise>${sessionScope.user.fullname}</c:otherwise></c:choose>">
                                        <input type="hidden" name="phone" id="hiddenPhone"
                                            value="<c:choose><c:when test='${not empty defaultAddr}'>${defaultAddr.phone}</c:when><c:otherwise>${sessionScope.user.phone}</c:otherwise></c:choose>">
                                        <input type="hidden" name="address" id="hiddenAddress"
                                            value="<c:choose><c:when test='${not empty defaultAddr}'>${defaultAddr.detailedAddress}</c:when><c:otherwise></c:otherwise></c:choose>">

                                        <script>
                                            function toggleAddressDropdown() {
                                                document.getElementById('addressDropdownList').classList.toggle('addr-open');
                                                document.getElementById('addressChevron').classList.toggle('rotated');
                                            }

                                            function selectAddress(name, phone, address, element) {
                                                document.getElementById('hiddenFullname').value = name;
                                                document.getElementById('hiddenPhone').value = phone;
                                                document.getElementById('hiddenAddress').value = address;

                                                const formContainer = document.getElementById('newAddressForm');
                                                formContainer.classList.add('hidden');
                                                formContainer.querySelectorAll('input, select, textarea').forEach(inp => {
                                                    inp.required = false;
                                                    inp.setCustomValidity("");
                                                });

                                                document.querySelectorAll('.address-option').forEach(el => {
                                                    el.classList.remove('border-accent-blue', 'bg-white/50');
                                                    el.classList.add('border-slate-200', 'bg-white/20');
                                                });
                                                element.classList.add('border-accent-blue', 'bg-white/50');
                                                element.classList.remove('border-slate-200', 'bg-white/20');

                                                // Update preview
                                                document.getElementById('previewName').innerHTML =
                                                    '<strong>' + name + '</strong> <span class="font-normal text-slate-500 ml-1">| ' + phone + '</span>';
                                                document.getElementById('previewAddress').textContent = address;

                                                // Close dropdown
                                                document.getElementById('addressDropdownList').classList.remove('addr-open');
                                                document.getElementById('addressChevron').classList.remove('rotated');
                                            }

                                            // Wrapper: đọc data attributes từ label rồi gọi selectAddress
                                            function selectAddressFromLabel(labelEl) {
                                                const name = labelEl.getAttribute('data-addr-name') || '';
                                                const phone = labelEl.getAttribute('data-addr-phone') || '';
                                                const address = labelEl.getAttribute('data-addr-address') || '';
                                                selectAddress(name, phone, address, labelEl);
                                            }

                                            function toggleNewAddressForm(element) {
                                                const formContainer = document.getElementById('newAddressForm');
                                                formContainer.classList.remove('hidden');
                                                formContainer.querySelectorAll('input, select, textarea').forEach(inp => {
                                                    if (inp.id !== 'saveNewAddress') inp.required = true;
                                                });
                                                updateHiddenFieldsFromNew();

                                                document.querySelectorAll('.address-option').forEach(el => {
                                                    el.classList.remove('border-accent-blue', 'bg-white/50');
                                                    el.classList.add('border-slate-200', 'bg-white/20');
                                                });
                                                element.classList.add('border-accent-blue', 'bg-white/50');
                                                element.classList.remove('border-slate-200', 'bg-white/20');

                                                document.getElementById('previewName').innerHTML = '<strong>Địa chỉ mới</strong>';
                                                document.getElementById('previewAddress').textContent = 'Điền thông tin bên dưới...';
                                                document.getElementById('addressDropdownList').classList.remove('addr-open');
                                                document.getElementById('addressChevron').classList.remove('rotated');
                                            }

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
                                                const provSelect = document.getElementById('newProvince');
                                                if (!provSelect) return;
                                                provSelect.innerHTML = '<option value="">Chọn Tỉnh/Thành Phố</option>';
                                                allProvincesData.forEach(p => {
                                                    const opt = document.createElement('option');
                                                    opt.value = p.name;
                                                    opt.setAttribute('data-code', p.code);
                                                    opt.textContent = p.name;
                                                    provSelect.appendChild(opt);
                                                });
                                            }

                                            document.getElementById('newProvince').addEventListener('change', function () {
                                                const wardSelect = document.getElementById('newWard');
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
                                                updateHiddenFieldsFromNew();
                                            });

                                            function updateHiddenFieldsFromNew() {
                                                if (document.getElementById('newAddressRadio').checked) {
                                                    document.getElementById('hiddenFullname').value = document.getElementById('newFullName').value;
                                                    document.getElementById('hiddenPhone').value = document.getElementById('newPhone').value;
                                                    let street = document.getElementById('newDetailedAddress').value;
                                                    let ward = document.getElementById('newWard').value;
                                                    let province = document.getElementById('newProvince').value;
                                                    let customAddress = street;
                                                    if (ward && ward.trim() !== '') customAddress += ", " + ward;
                                                    if (province && province.trim() !== '') customAddress += ", " + province;
                                                    document.getElementById('hiddenAddress').value = customAddress;
                                                }
                                            }

                                            window.addEventListener('DOMContentLoaded', () => {
                                                fetchAllData();

                                                // ── Populate hidden fields từ địa chỉ được check (mặc định từ DB) khi trang load ──
                                                const checkedAddr = document.querySelector('input[name="addressSelection"]:checked');
                                                if (checkedAddr && checkedAddr.value !== 'new') {
                                                    const label = checkedAddr.closest('.address-option');
                                                    if (label && label.hasAttribute('data-addr-name')) {
                                                        const addrName    = label.getAttribute('data-addr-name')    || '';
                                                        const addrPhone   = label.getAttribute('data-addr-phone')   || '';
                                                        const addrAddress = label.getAttribute('data-addr-address') || '';

                                                        if (addrName || addrAddress) {
                                                            document.getElementById('hiddenFullname').value = addrName;
                                                            document.getElementById('hiddenPhone').value   = addrPhone;
                                                            document.getElementById('hiddenAddress').value = addrAddress;

                                                            // Cập nhật lại preview card cho chắc
                                                            document.getElementById('previewName').innerHTML =
                                                                '<strong>' + addrName + '</strong>' +
                                                                (addrPhone ? ' <span class="font-normal text-slate-500 ml-1">| ' + addrPhone + '</span>' : '');
                                                            document.getElementById('previewAddress').textContent = addrAddress;
                                                        }
                                                    }
                                                }
                                            });
                                        </script>
                                    </div>
                                </section>
                                <!-- Shipping Method Section -->
                                <section>
                                    <h2 class="font-serif mb-6 text-slate-800 tracking-wide font-semibold text-3xl">
                                        Shipping Method</h2>
                                    <div class="glass-card rounded-xl overflow-hidden border border-sky-100">
                                        <div class="divide-y divide-sky-100">
                                            <label
                                                class="flex items-center justify-between p-6 hover:bg-white/40 cursor-pointer">
                                                <div class="flex items-center gap-4">
                                                    <input checked="" class="text-accent-blue focus:ring-accent-blue"
                                                        name="shipping" type="radio" value="Express Courier" />
                                                    <div>
                                                        <p class="font-medium">Express Courier</p>
                                                        <p class="text-xs text-slate-500 italic">2-3 Business Days •
                                                            Carbon Neutral</p>
                                                    </div>
                                                </div>
                                                <span class="font-medium">Free</span>
                                            </label>
                                            <label
                                                class="flex items-center justify-between p-6 hover:bg-white/40 cursor-pointer">
                                                <div class="flex items-center gap-4">
                                                    <input class="text-accent-blue focus:ring-accent-blue"
                                                        name="shipping" type="radio" value="Standard Delivery" />
                                                    <div>
                                                        <p class="font-medium">Standard Delivery</p>
                                                        <p class="text-xs text-slate-500 italic">5-7 Business Days</p>
                                                    </div>
                                                </div>
                                                <span class="font-medium text-emerald-600">Complimentary</span>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="mt-4 flex items-center gap-2 px-4">
                                        <span
                                            class="material-symbols-outlined text-slate-400 text-sm">calendar_today</span>
                                        <p class="text-sm text-slate-600">Estimated Delivery: <span
                                                class="font-medium text-slate-900">Thursday, March 5th, 2026</span></p>
                                    </div>
                                </section>
                                <!-- Payment Methods Section -->
                                <section>
                                    <h2 class="font-serif mb-6 text-slate-800 tracking-wide font-semibold text-3xl">
                                        Payment Selection</h2>
                                    <div class="glass-card rounded-xl p-8 space-y-8">
                                        <div class="space-y-4">
                                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                                <label
                                                    class="relative flex flex-col items-center justify-center p-6 rounded-xl border-2 border-accent-blue bg-white/80 cursor-pointer text-center group transition-all"
                                                    id="label-card">
                                                    <input checked="" class="sr-only" name="paymentMethod" value="Card"
                                                        type="radio" />
                                                    <span
                                                        class="material-symbols-outlined text-accent-blue mb-3 text-3xl">credit_card</span>
                                                    <span class="text-xs font-semibold uppercase tracking-wider">Credit
                                                        Card</span>
                                                </label>
                                                <label
                                                    class="relative flex flex-col items-center justify-center p-6 rounded-xl border border-slate-200 bg-white/40 hover:bg-white/60 cursor-pointer text-center group transition-all"
                                                    id="label-qr">
                                                    <input class="sr-only" name="paymentMethod" value="QR"
                                                        type="radio" />
                                                    <span
                                                        class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 mb-3 text-3xl">qr_code_2</span>
                                                    <span class="text-xs font-semibold uppercase tracking-wider">QR
                                                        Pay</span>
                                                </label>
                                                <label
                                                    class="relative flex flex-col items-center justify-center p-6 rounded-xl border border-slate-200 bg-white/40 hover:bg-white/60 cursor-pointer text-center group transition-all"
                                                    id="label-cod">
                                                    <input class="sr-only" name="paymentMethod" value="COD"
                                                        type="radio" />
                                                    <span
                                                        class="material-symbols-outlined text-slate-400 group-hover:text-slate-600 mb-3 text-3xl">payments</span>
                                                    <span class="text-xs font-semibold uppercase tracking-wider">Cash on
                                                        Delivery</span>
                                                </label>
                                            </div>
                                            <div class="mt-8 pt-8 border-t border-slate-100">
                                                <div id="cardSection" class="max-w-md space-y-4">
                                                    <div class="space-y-1">
                                                        <label
                                                            class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold">Card
                                                            Number</label>
                                                        <input name="cardNumber"
                                                            class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm tracking-widest"
                                                            placeholder="XXXX XXXX XXXX XXXX" type="text" />
                                                    </div>
                                                    <div class="grid grid-cols-2 gap-4">
                                                        <div class="space-y-1">
                                                            <label
                                                                class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold">Expiry
                                                                Date</label>
                                                            <input name="expiryDate"
                                                                class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm"
                                                                placeholder="MM / YY" type="text" />
                                                        </div>
                                                        <div class="space-y-1">
                                                            <label
                                                                class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold">CVV</label>
                                                            <input name="cvv"
                                                                class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm"
                                                                placeholder="***" type="password" />
                                                        </div>
                                                    </div>
                                                    <div class="space-y-1">
                                                        <label
                                                            class="text-[10px] uppercase tracking-widest text-slate-500 font-semibold">Card
                                                            Name</label>
                                                        <input name="cardName"
                                                            class="w-full bg-white border-slate-200 rounded-lg focus:ring-accent-blue focus:border-accent-blue text-sm"
                                                            placeholder="NAME ON CARD" type="text" />
                                                    </div>
                                                </div>

                                                <!-- QR Section -->
                                                <div id="qrSection"
                                                    class="hidden border border-sky-100 rounded-xl p-6 text-center animate-fade-in">
                                                    <div class="mb-4">
                                                        <span
                                                            class="material-symbols-outlined text-accent-blue text-5xl animate-pulse">qr_code_scanner</span>
                                                    </div>
                                                    <p class="text-sm text-slate-600 mb-2 font-medium">Professional QR
                                                        Payment</p>
                                                    <p class="text-xs text-slate-500">You will be securely redirected to
                                                        PayOS to scan and pay with any Banking App.</p>
                                                </div>

                                                <!-- COD Section -->
                                                <div id="codSection" class="hidden text-center p-6">
                                                    <p class="text-sm text-slate-600">Pay directly with cash upon
                                                        delivery.</p>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
                                </section>
                            </div>
                            <!-- Right Section: Order Summary (Sticky) -->
                            <div class="lg:col-span-5">
                                <div class="sticky top-32 glass-card rounded-xl p-8 border border-slate-200 shadow-sm">
                                    <h2 class="font-serif mb-8 text-slate-800 tracking-wide font-semibold text-3xl">Your
                                        Order</h2>
                                    <!-- Item List -->
                                    <div class="space-y-6 mb-8 max-h-[400px] overflow-y-auto pr-2 custom-scrollbar">
                                        <c:forEach var="item" items="${sessionScope.checkoutCart.items}">
                                            <div class="flex gap-4">
                                                <div
                                                    class="w-20 h-24 flex-shrink-0 rounded-lg bg-slate-100 overflow-hidden">
                                                    <c:set var="checkoutImg" value="${item.productImageUrl}" />
                                                    <c:if test="${not empty checkoutImg and not fn:startsWith(checkoutImg, 'http') and not fn:startsWith(checkoutImg, '/')}">
                                                        <c:set var="checkoutImg" value="${pageContext.request.contextPath}/uploads/${checkoutImg}" />
                                                    </c:if>
                                                    <img class="w-full h-full object-cover"
                                                        src="${checkoutImg}" alt="${item.productName}" />
                                                </div>
                                                <div class="flex-grow">
                                                    <div class="flex justify-between items-start">
                                                        <h3 class="text-sm font-medium text-slate-900">
                                                            ${item.productName}</h3>
                                                        <span class="text-sm font-medium">
                                                            <fmt:formatNumber value="${item.subtotal}" type="currency"
                                                                currencyCode="VND" maxFractionDigits="0" />
                                                        </span>
                                                    </div>
                                                    <p class="text-xs text-slate-500 mt-1 italic">${item.color} / Size
                                                        ${item.size}</p>
                                                    <div
                                                        class="flex items-center gap-1 mt-2 text-[10px] text-slate-400">
                                                        <span>Quantity: ${item.quantity}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <!-- Promo Code -->
                                    <!-- Totals -->
                                    <div class="py-3 border-y border-slate-100 my-3">
                                        <button type="button"
                                            onclick="document.getElementById('discount-drawer').classList.remove('hidden')"
                                            class="group flex items-center gap-2 text-xs font-semibold uppercase tracking-widest text-slate-800 hover:text-accent-blue transition-colors outline-none cursor-pointer">
                                            <span class="material-symbols-outlined text-lg">add_circle</span>
                                            <span
                                                class="border-b border-transparent group-hover:border-accent-blue transition-all">Add
                                                Promotion</span>
                                        </button>
                                    </div>
                                    <div class="space-y-3">
                                        <div class="flex justify-between text-sm">
                                            <span class="text-slate-500">Subtotal</span>
                                            <span class="text-slate-900" id="subtotalDisplay">
                                                <fmt:formatNumber value="${sessionScope.checkoutCart.totalPrice}"
                                                    type="currency" currencyCode="VND" maxFractionDigits="0" />
                                            </span>
                                        </div>
                                        <div class="flex justify-between text-sm">
                                            <span class="text-slate-500">Shipping (Express)</span>
                                            <span class="text-slate-900">Free</span>
                                        </div>
                                        <%-- Voucher discount row --%>
                                            <c:if test="${not empty sessionScope.appliedVoucher}">
                                                <div class="flex justify-between text-sm" id="discountRow">
                                                    <span class="text-emerald-600 font-medium">🎟️
                                                        ${sessionScope.appliedVoucher.code}</span>
                                                    <span class="text-emerald-600 font-medium" id="discountDisplay">
                                                        -
                                                        <fmt:formatNumber value="${sessionScope.appliedDiscount}"
                                                            type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                    </span>
                                                </div>
                                            </c:if>
                                            <c:if test="${empty sessionScope.appliedVoucher}">
                                                <div class="flex justify-between text-sm hidden" id="discountRow">
                                                    <span class="text-emerald-600 font-medium" id="discountCode"></span>
                                                    <span class="text-emerald-600 font-medium"
                                                        id="discountDisplay"></span>
                                                </div>
                                            </c:if>
                                            <div class="flex justify-between pt-4 border-t border-sky-100">
                                                <span class="text-xl font-bold text-slate-900">Total</span>
                                                <span class="text-xl font-bold text-slate-900" id="totalDisplay">
                                                    <fmt:formatNumber
                                                        value="${not empty sessionScope.appliedDiscount ? sessionScope.checkoutCart.totalPrice - sessionScope.appliedDiscount : sessionScope.checkoutCart.totalPrice}"
                                                        type="currency" currencyCode="VND" maxFractionDigits="0" />
                                                </span>
                                            </div>
                                    </div>
                                    <!-- CTA -->
                                    <button type="submit"
                                        class="w-full mt-10 bg-accent-blue text-white py-5 rounded-lg text-xs uppercase tracking-[0.3em] font-bold transition-all flex items-center justify-center gap-3 hover:bg-[#0277bd] tracking-[0.2em]">
                                        Place Order
                                        <span class="material-icons-outlined text-sm">lock</span>
                                    </button>
                                    <p class="text-center text-[10px] text-slate-400 mt-4 leading-relaxed">
                                        By clicking Place Order, you agree to our <br /> <a class="underline"
                                            href="#">Terms of Service</a> and <a class="underline" href="#">Privacy
                                            Policy</a>.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </form>
                </main>

                <!-- Footer -->
                <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

                <!-- Side Drawer for Discounts -->
                <div class="fixed inset-0 z-[100] hidden" id="discount-drawer">
                    <!-- Backdrop -->
                    <div class="absolute inset-0 bg-black/20 backdrop-blur-sm transition-opacity"
                        onclick="document.getElementById('discount-drawer').classList.add('hidden')"></div>
                    <!-- Drawer Panel -->
                    <div
                        class="absolute right-0 top-0 h-full w-full md:w-[380px] bg-white/90 backdrop-blur-xl border-l border-[#E3F2FD] shadow-[0_0_50px_rgba(0,0,0,0.1)]">
                        <div class="flex flex-col h-full">
                            <!-- Header -->
                            <div class="p-6 border-b border-slate-100 flex items-center justify-between">
                                <h2 class="text-2xl font-bold text-slate-900 tracking-tight">Mã Giảm Giá</h2>
                                <button type="button"
                                    onclick="document.getElementById('discount-drawer').classList.add('hidden')"
                                    class="material-symbols-outlined text-slate-400 hover:text-slate-900 transition-colors p-1">close</button>
                            </div>
                            <!-- Content -->
                            <div class="flex-1 overflow-y-auto p-6 space-y-6 custom-scrollbar">
                                <!-- Input promo code -->
                                <div class="space-y-3">
                                    <label class="text-[10px] uppercase tracking-[0.2em] text-slate-400 font-bold">Nhập
                                        mã</label>
                                    <div class="flex items-center gap-3">
                                        <input id="voucherCodeInput"
                                            class="flex-1 border-0 border-b border-slate-200 focus:ring-0 focus:border-primary text-sm py-3 px-1 bg-transparent uppercase tracking-widest"
                                            placeholder="VD: WELCOME10" type="text" />
                                        <button type="button" onclick="applyVoucherCode()"
                                            class="text-[10px] uppercase tracking-[0.2em] font-bold text-primary hover:opacity-70 transition-opacity underline">Áp
                                            dụng</button>
                                    </div>
                                    <p id="voucherMsg" class="text-xs mt-1 hidden"></p>
                                </div>

                                <!-- Applied voucher display -->
                                <div id="appliedVoucherBox"
                                    class="${not empty sessionScope.appliedVoucher ? '' : 'hidden'} p-4 bg-emerald-50 border border-emerald-200 rounded-lg flex items-center justify-between">
                                    <div>
                                        <p class="text-xs font-bold text-emerald-700 uppercase tracking-widest">${not
                                            empty sessionScope.appliedVoucher ? sessionScope.appliedVoucher.code : ''}
                                        </p>
                                        <p class="text-xs text-emerald-600" id="appliedDiscountText"></p>
                                    </div>
                                    <button type="button" onclick="removeVoucher()"
                                        class="text-slate-400 hover:text-red-500 transition-colors">
                                        <span class="material-symbols-outlined text-lg">close</span>
                                    </button>
                                </div>

                                <%-- ── Available Vouchers list ────────────────────── --%>
                                    <div class="space-y-3 pt-2">
                                        <p class="text-[10px] uppercase tracking-[0.2em] text-slate-400 font-bold">
                                            Voucher khả dụng</p>

                                        <c:choose>
                                            <c:when test="${empty activeVouchers}">
                                                <div class="text-center py-8 text-slate-400 text-xs">
                                                    <span
                                                        class="material-symbols-outlined text-3xl block mb-2 opacity-40">confirmation_number</span>
                                                    Hiện chưa có voucher nào
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="vc" items="${activeVouchers}">
                                                    <c:set var="canUse"
                                                        value="${empty vc.minOrderValue or sessionScope.checkoutCart.totalPrice >= vc.minOrderValue}" />
                                                    <div class="voucher-pick-card relative overflow-hidden rounded-xl border-2 transition-all duration-200 ${canUse ? 'cursor-pointer opacity-100 border-slate-200 bg-gradient-to-br from-white to-blue-50/30' : 'cursor-not-allowed opacity-60 border-slate-100 bg-slate-50'}"
                                                        onclick="${canUse ? 'pickVoucher(this)' : 'void(0)'}"
                                                        data-code="${vc.code}">
                                                        <%-- decorative notches --%>
                                                            <div
                                                                style="position:absolute;left:-10px;top:50%;transform:translateY(-50%);width:20px;height:20px;border-radius:50%;background:#f1f5f9;border:2px solid #e2e8f0;">
                                                            </div>
                                                            <div
                                                                style="position:absolute;right:-10px;top:50%;transform:translateY(-50%);width:20px;height:20px;border-radius:50%;background:#f1f5f9;border:2px solid #e2e8f0;">
                                                            </div>

                                                            <div
                                                                style="padding:14px 24px;display:flex;align-items:center;gap:14px;">
                                                                <%-- icon --%>
                                                                    <div
                                                                        class="flex-shrink-0 w-[42px] h-[42px] rounded-xl flex items-center justify-center ${vc.discountType eq 'PERCENT' ? 'bg-blue-100 text-blue-700' : 'bg-emerald-100 text-emerald-700'}">
                                                                        <span class="material-symbols-outlined text-lg">${vc.discountType
                                                                            eq 'PERCENT' ? 'percent' :
                                                                            'payments'}</span>
                                                                    </div>
                                                                    <%-- info --%>
                                                                        <div style="flex:1;min-width:0;">
                                                                            <p
                                                                                style="font-size:0.82rem;font-weight:800;letter-spacing:2px;color:#1e293b;font-family:monospace;">
                                                                                ${vc.code}</p>
                                                                            <p
                                                                                style="font-size:0.72rem;color:#64748b;margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty vc.description}">
                                                                                        ${vc.description}</c:when>
                                                                                    <c:otherwise>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${vc.discountType eq 'PERCENT'}">
                                                                                                Giảm
                                                                                                ${vc.discountValue}%
                                                                                                <c:if
                                                                                                    test="${not empty vc.maxDiscountAmount}">
                                                                                                    tối đa
                                                                                                    <fmt:formatNumber
                                                                                                        value="${vc.maxDiscountAmount}"
                                                                                                        type="currency"
                                                                                                        currencyCode="VND"
                                                                                                        maxFractionDigits="0" />
                                                                                                </c:if>
                                                                                            </c:when>
                                                                                            <c:otherwise>Giảm
                                                                                                <fmt:formatNumber
                                                                                                    value="${vc.discountValue}"
                                                                                                    type="currency"
                                                                                                    currencyCode="VND"
                                                                                                    maxFractionDigits="0" />
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </p>
                                                                            <div
                                                                                style="display:flex;gap:8px;margin-top:5px;flex-wrap:wrap;">
                                                                                <c:if
                                                                                    test="${not empty vc.minOrderValue}">
                                                                                    <span
                                                                                        style="font-size:0.66rem;color:#94a3b8;">Đơn
                                                                                        từ
                                                                                        <fmt:formatNumber
                                                                                            value="${vc.minOrderValue}"
                                                                                            type="currency"
                                                                                            currencyCode="VND"
                                                                                            maxFractionDigits="0" />
                                                                                    </span>
                                                                                </c:if>
                                                                                <c:if test="${not empty vc.endDate}">
                                                                                    <span
                                                                                        style="font-size:0.66rem;color:#94a3b8;">HSD:
                                                                                        <fmt:formatDate
                                                                                            value="${vc.endDate}"
                                                                                            pattern="dd/MM/yyyy" />
                                                                                    </span>
                                                                                </c:if>
                                                                                <c:if test="${vc.usageLimit > 0}">
                                                                                    <span
                                                                                        style="font-size:0.66rem;color:#94a3b8;">Còn
                                                                                        ${vc.usageLimit - vc.usedCount}
                                                                                        lượt</span>
                                                                                </c:if>
                                                                            </div>
                                                                            <c:if
                                                                                test="${!canUse and not empty vc.minOrderValue}">
                                                                                <p
                                                                                    style="font-size:0.66rem;color:#ef4444;margin-top:4px;">
                                                                                    ⚠ Cần mua thêm
                                                                                    <fmt:formatNumber
                                                                                        value="${vc.minOrderValue - sessionScope.checkoutCart.totalPrice}"
                                                                                        type="currency"
                                                                                        currencyCode="VND"
                                                                                        maxFractionDigits="0" /> để dùng
                                                                                    mã này
                                                                                </p>
                                                                            </c:if>
                                                                        </div>
                                                                        <%-- discount badge --%>
                                                                            <div style="flex-shrink:0;">
                                                                                <span
                                                                                    class="inline-block px-2.5 py-1.5 rounded-lg text-sm font-extrabold ${vc.discountType eq 'PERCENT' ? 'bg-blue-50 text-blue-700' : 'bg-emerald-50 text-emerald-700'}">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${vc.discountType eq 'PERCENT'}">
                                                                                            ${vc.discountValue}%
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <fmt:formatNumber
                                                                                                value="${vc.discountValue}"
                                                                                                type="number"
                                                                                                maxFractionDigits="0" />
                                                                                            ₫
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </span>
                                                                            </div>
                                                            </div>
                                                    </div>
                                    </div>
                            </div>
                        </div>
                        </c:forEach>
                        </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <!-- Footer -->
                <div class="p-6 border-t border-slate-100">
                    <button type="button" onclick="document.getElementById('discount-drawer').classList.add('hidden')"
                        class="w-full py-4 border border-slate-900 text-slate-900 text-[10px] uppercase tracking-[0.3em] font-bold rounded-lg hover:bg-slate-900 hover:text-white transition-all duration-300">
                        Trở lại Checkout
                    </button>
                </div>
                </div>
                </div>
                </div>

                <script>
                    const radios = document.querySelectorAll('input[name="paymentMethod"]');
                    const qrSection = document.getElementById('qrSection');
                    const cardSection = document.getElementById('cardSection');
                    const codSection = document.getElementById('codSection');

                    const labelCard = document.getElementById('label-card');
                    const labelQr = document.getElementById('label-qr');
                    const labelCod = document.getElementById('label-cod');

                    function updateSelection(value) {
                        if (qrSection) qrSection.classList.add('hidden');
                        if (cardSection) cardSection.classList.add('hidden');
                        if (codSection) codSection.classList.add('hidden');

                        // Reset classes
                        [labelCard, labelQr, labelCod].forEach(l => {
                            if (l) {
                                l.classList.remove('border-accent-blue', 'border-2');
                                l.classList.add('border-slate-200');
                                const icon = l.querySelector('span:first-of-type');
                                if (icon) {
                                    icon.classList.remove('text-accent-blue');
                                    icon.classList.add('text-slate-400');
                                }
                            }
                        });

                        if (value === 'QR' && qrSection) {
                            qrSection.classList.remove('hidden');
                            labelQr.classList.add('border-accent-blue', 'border-2');
                            labelQr.classList.remove('border-slate-200');
                            labelQr.querySelector('span:first-of-type').classList.add('text-accent-blue');
                        } else if (value === 'Card' && cardSection) {
                            cardSection.classList.remove('hidden');
                            labelCard.classList.add('border-accent-blue', 'border-2');
                            labelCard.classList.remove('border-slate-200');
                            labelCard.querySelector('span:first-of-type').classList.add('text-accent-blue');
                        } else if (value === 'COD' && codSection) {
                            codSection.classList.remove('hidden');
                            labelCod.classList.add('border-accent-blue', 'border-2');
                            labelCod.classList.remove('border-slate-200');
                            labelCod.querySelector('span:first-of-type').classList.add('text-accent-blue');
                        }
                    }

                    radios.forEach(radio => {
                        radio.addEventListener('change', (e) => {
                            updateSelection(e.target.value);
                        });
                    });

                    // Initialize with default check
                    updateSelection('Card');

                    // ── Voucher AJAX ──────────────────────────────────────
                    const cartTotal = ${ sessionScope.checkoutCart.totalPrice };

                    async function applyVoucherCode() {
                        const code = document.getElementById('voucherCodeInput').value.trim();
                        const msg = document.getElementById('voucherMsg');
                        if (!code) { showMsg(msg, 'Vui lòng nhập mã voucher.', false); return; }

                        try {
                            const res = await fetch('${pageContext.request.contextPath}/voucher?action=apply', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'code=' + encodeURIComponent(code) + '&orderTotal=' + cartTotal
                            });
                            const data = await res.json();
                            if (data.ok) {
                                showMsg(msg, '✅ ' + data.message, true);
                                applyDiscountToUI(code.toUpperCase(), data.discount);
                                document.getElementById('voucherIdInput').value = data.voucherId;
                                document.getElementById('discountAmountInput').value = data.discount;
                            } else {
                                showMsg(msg, '❌ ' + data.message, false);
                            }
                        } catch (e) {
                            showMsg(msg, '❌ Lỗi kết nối. Thử lại.', false);
                        }
                    }

                    function applyDiscountToUI(code, discountAmt) {
                        const discountRow = document.getElementById('discountRow');
                        const discountDisplay = document.getElementById('discountDisplay');
                        const discountCode = document.getElementById('discountCode');
                        const totalDisplay = document.getElementById('totalDisplay');
                        const appliedBox = document.getElementById('appliedVoucherBox');

                        if (discountCode) discountCode.textContent = '🎟️ ' + code;
                        if (discountDisplay) discountDisplay.textContent = '-' + formatVND(discountAmt);
                        if (discountRow) discountRow.classList.remove('hidden');

                        const newTotal = Math.max(0, cartTotal - discountAmt);
                        if (totalDisplay) totalDisplay.textContent = formatVND(newTotal);
                        if (appliedBox) {
                            appliedBox.classList.remove('hidden');
                            const appliedText = document.getElementById('appliedDiscountText');
                            if (appliedText) appliedText.textContent = 'Giảm ' + formatVND(discountAmt);
                        }
                    }

                    function removeVoucher() {
                        fetch('${pageContext.request.contextPath}/voucher?action=remove', { method: 'POST' })
                            .then(() => location.reload());
                    }

                    /** Click on a voucher card → auto-fill code + apply */
                    function pickVoucher(card) {
                        const code = card.getAttribute('data-code');
                        if (!code) return;

                        // Highlight selected card
                        document.querySelectorAll('.voucher-pick-card').forEach(c => {
                            c.style.borderColor = '#e2e8f0';
                            c.style.boxShadow = 'none';
                        });
                        card.style.borderColor = '#1d4ed8';
                        card.style.boxShadow = '0 0 0 3px rgba(29,78,216,0.12)';

                        // Fill the input field
                        const input = document.getElementById('voucherCodeInput');
                        if (input) {
                            input.value = code;
                            input.dispatchEvent(new Event('input'));
                        }

                        // Scroll to input so user sees the feedback message
                        const msg = document.getElementById('voucherMsg');
                        if (msg) msg.classList.add('hidden');

                        // Trigger apply
                        applyVoucherCode();
                    }

                    // Add hover style to voucher pick cards (inline style approach for Tailwind compat)
                    document.addEventListener('DOMContentLoaded', function () {
                        document.querySelectorAll('.voucher-pick-card[data-code]').forEach(card => {
                            if (card.style.cursor === 'pointer') {
                                card.addEventListener('mouseenter', () => {
                                    if (card.style.borderColor !== 'rgb(29, 78, 216)') {
                                        card.style.borderColor = '#94a3b8';
                                        card.style.boxShadow = '0 4px 12px rgba(0,0,0,0.08)';
                                    }
                                });
                                card.addEventListener('mouseleave', () => {
                                    if (card.style.borderColor !== 'rgb(29, 78, 216)') {
                                        card.style.borderColor = '#e2e8f0';
                                        card.style.boxShadow = 'none';
                                    }
                                });
                            }
                        });
                    });

                    function showMsg(el, text, ok) {
                        if (!el) return;
                        el.textContent = text;
                        el.className = 'text-xs mt-1 ' + (ok ? 'text-emerald-600' : 'text-red-500');
                        el.classList.remove('hidden');
                    }

                    function formatVND(amount) {
                        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(amount);
                    }

                    // Allow Enter key on voucher input
                    const voucherInput = document.getElementById('voucherCodeInput');
                    if (voucherInput) {
                        voucherInput.addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); applyVoucherCode(); } });
                    }

                    // Validation logic
                    const form = document.getElementById('checkoutForm');
                    if (form) {
                        form.addEventListener('submit', function (e) {
                            // ── 1. Validate địa chỉ giao hàng ──────────────────────────────
                            const hiddenAddr = document.getElementById('hiddenAddress');
                            const hiddenName = document.getElementById('hiddenFullname');
                            const hiddenPhone = document.getElementById('hiddenPhone');
                            if (!hiddenAddr || !hiddenAddr.value.trim() ||
                                !hiddenName || !hiddenName.value.trim() ||
                                !hiddenPhone || !hiddenPhone.value.trim()) {
                                e.preventDefault();
                                alert('Vui lòng chọn hoặc nhập địa chỉ giao hàng hợp lệ trước khi đặt hàng.');
                                return;
                            }

                            // ── 2. Validate nếu chọn "Thêm địa chỉ mới" mà chưa điền đủ ──
                            const newAddrRadio = document.getElementById('newAddressRadio');
                            if (newAddrRadio && newAddrRadio.checked) {
                                const newName = document.getElementById('newFullName').value.trim();
                                const newPhone = document.getElementById('newPhone').value.trim();
                                const newDetail = document.getElementById('newDetailedAddress').value.trim();
                                if (!newName || !newPhone || !newDetail) {
                                    e.preventDefault();
                                    alert('Vui lòng điền đầy đủ thông tin địa chỉ mới (Họ tên, Số điện thoại, Số nhà/Đường).');
                                    return;
                                }
                            }

                            // ── 3. Validate thông tin thẻ nếu chọn Card ─────────────────────
                            const checkedRadio = document.querySelector('input[name="paymentMethod"]:checked');
                            if (!checkedRadio) return;
                            const selected = checkedRadio.value;

                            if (selected === 'QR' || selected === 'COD') {
                                return; // Không cần validate thêm
                            }

                            if (selected === 'Card') {
                                const cardNumberInput = document.querySelector('input[name="cardNumber"]');
                                const expiryDateInput = document.querySelector('input[name="expiryDate"]');
                                const cvvInput = document.querySelector('input[name="cvv"]');

                                if (cardNumberInput && expiryDateInput && cvvInput) {
                                    const cardNumber = cardNumberInput.value.trim();
                                    const expiryDate = expiryDateInput.value.trim();
                                    const cvv = cvvInput.value.trim();

                                    // Nếu chưa nhập gì cả, yêu cầu nhập
                                    if (!cardNumber && !expiryDate && !cvv) {
                                        e.preventDefault();
                                        alert('Vui lòng nhập thông tin thẻ tín dụng (Số thẻ, Ngày hết hạn, CVV).');
                                        cardNumberInput.focus();
                                        return;
                                    }

                                    if (!/^\d{4}(\s\d{4}){3}$|^\d{16}$/.test(cardNumber.replace(/\s/g, ''))) {
                                        e.preventDefault();
                                        alert('Số thẻ không hợp lệ (cần 16 chữ số).');
                                        cardNumberInput.focus();
                                        return;
                                    }
                                    if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiryDate)) {
                                        e.preventDefault();
                                        alert('Ngày hết hạn không hợp lệ (định dạng MM/YY).');
                                        expiryDateInput.focus();
                                        return;
                                    }
                                    if (!/^\d{3}$/.test(cvv)) {
                                        e.preventDefault();
                                        alert('CVV không hợp lệ (cần 3 chữ số).');
                                        cvvInput.focus();
                                        return;
                                    }
                                }
                            }
                        });
                    }

                </script>
            </body>

            </html>