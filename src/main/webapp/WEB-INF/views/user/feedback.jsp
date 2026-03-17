<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
      <% if (session.getAttribute("user")==null) { response.sendRedirect(request.getContextPath() + "/login" ); return;
        } %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
          <meta charset="utf-8" />
          <meta content="width=device-width, initial-scale=1.0" name="viewport" />
          <title>Đánh giá sản phẩm | AISTHÉA</title>
          <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
          <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600&display=swap"
            rel="stylesheet" />
          <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
            rel="stylesheet" />
          <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

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

            .glass-input {
              background: rgba(255, 255, 255, 0.4);
              backdrop-filter: blur(10px);
              border: 1px solid rgba(255, 255, 255, 0.6);
              transition: all 0.3s ease;
            }

            .glass-input:focus {
              background: rgba(255, 255, 255, 0.8);
              border-color: #0056b3;
              box-shadow: 0 0 0 4px rgba(0, 86, 179, 0.1);
              outline: none;
            }

            .gold-border-glow {
              box-shadow: 0 0 0 1px #C5A059, 0 0 12px rgba(197, 160, 89, 0.4);
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
              color: #0056b3;
              font-weight: 600;
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

            details[open] summary~* {
              animation: slideDown 0.3s ease-in-out;
            }

            details[open] summary .chevron {
              transform: rotate(180deg);
            }

            @keyframes slideDown {
              0% {
                opacity: 0;
                transform: translateY(-10px);
              }

              100% {
                opacity: 1;
                transform: translateY(0);
              }
            }

            /* ── Star Rating ── */
            .star-rating span {
              transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
              cursor: pointer;
            }

            /* ── Product preview card ── */
            .product-preview-card {
              background: linear-gradient(135deg, rgba(0, 86, 179, 0.03) 0%, rgba(197, 160, 89, 0.05) 100%);
              border: 1px solid rgba(0, 86, 179, 0.08);
              border-radius: 16px;
              padding: 20px;
              transition: all 0.3s ease;
            }

            .product-preview-card:hover {
              border-color: rgba(0, 86, 179, 0.15);
              box-shadow: 0 4px 20px rgba(0, 86, 179, 0.06);
            }

            /* ── Success toast ── */
            @keyframes fadeInUp {
              from {
                opacity: 0;
                transform: translateY(20px);
              }

              to {
                opacity: 1;
                transform: translateY(0);
              }
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

          <main class="relative z-10 max-w-7xl mx-auto px-4 pb-20 mt-8">
            <div class="flex flex-col lg:flex-row gap-8">
              <!-- Sidebar -->
              <jsp:include page="/WEB-INF/views/common/user-sidebar.jsp">
                <jsp:param name="activeTab" value="order" />
              </jsp:include>

              <!-- Main Content -->
              <section class="lg:w-3/4">
                <div class="glass-island rounded-[32px] p-8 lg:p-12 min-h-[700px] relative overflow-hidden">
                  <!-- Decorative gradient -->
                  <div
                    class="absolute top-0 right-0 w-[400px] h-[400px] bg-gradient-to-b from-blue-50/80 to-transparent rounded-bl-full pointer-events-none">
                  </div>

                  <div class="relative z-10 max-w-3xl mx-auto">
                    <!-- Page Header -->
                    <header class="mb-10 border-b border-slate-200/60 pb-6">
                      <div class="flex items-center gap-2 mb-3">
                        <span class="material-symbols-outlined text-accent-gold text-[20px]"
                          style="font-variation-settings: 'FILL' 1;">rate_review</span>
                        <span class="text-[10px] font-bold text-accent-gold uppercase tracking-widest">Verified Purchase
                          Review</span>
                      </div>
                      <h1 class="font-display font-bold text-3xl text-slate-900 mb-2 tracking-tight">Đánh giá sản phẩm
                      </h1>
                      <p class="text-slate-500 font-light text-sm tracking-wide">Chia sẻ trải nghiệm của bạn để giúp
                        cộng đồng AISTHÉA lựa chọn tốt hơn</p>
                    </header>

                    <!-- Success Message -->
                    <c:if test="${not empty sessionScope.feedbackSuccess}">
                      <div
                        class="bg-emerald-50 border border-emerald-200 text-emerald-600 rounded-xl p-4 text-sm flex items-center shadow-sm mb-6"
                        style="animation: fadeInUp 0.4s ease;">
                        <span class="material-symbols-outlined mr-3 text-[20px]">check_circle</span>
                        <span class="font-medium">${sessionScope.feedbackSuccess}</span>
                      </div>
                      <c:remove var="feedbackSuccess" scope="session" />
                    </c:if>

                    <!-- Feedback Form -->
                    <form action="${pageContext.request.contextPath}/feedback" method="POST" id="feedbackForm"
                      enctype="multipart/form-data"
                      class="space-y-8">
                      <input type="hidden" name="orderId" value="${orderId}" />
                      <input type="hidden" name="rating" id="ratingValue" value="0" />
                      <input type="hidden" name="productId" id="selectedProductId" value="${orderItems[0].productId}" />

                      <%-- Product Selector Cards --%>
                        <c:if test="${not empty orderItems}">
                          <div class="space-y-3">
                            <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">
                              <c:choose>
                                <c:when test="${fn:length(orderItems) > 1}">Chọn sản phẩm cần đánh giá</c:when>
                                <c:otherwise>Sản phẩm đánh giá</c:otherwise>
                              </c:choose>
                            </label>
                            <div class="grid grid-cols-1 gap-3" id="productCards">
                              <c:forEach var="item" items="${orderItems}" varStatus="st">
                                <div
                                  class="product-card group relative flex items-center gap-4 p-4 rounded-2xl border-2 cursor-pointer transition-all duration-300
                                           ${st.index == 0 ? 'border-primary bg-primary/[0.03] shadow-sm' : 'border-transparent bg-white/40 hover:bg-white/70 hover:border-slate-200'}"
                                  data-product-id="${item.productId}" data-product-name="${item.productName}"
                                  data-product-img="${item.imageUrl}" onclick="selectProduct(this)">
                                  <!-- Check indicator -->
                                  <div
                                    class="absolute top-3 right-3 w-6 h-6 rounded-full flex items-center justify-center transition-all duration-300
                                            ${st.index == 0 ? 'bg-primary scale-100' : 'bg-slate-200 scale-75 opacity-0 group-hover:opacity-40'}">
                                    <span class="material-symbols-outlined text-white text-[16px]"
                                      style="font-variation-settings: 'FILL' 1;">check</span>
                                  </div>
                                  <!-- Product image -->
                                  <div
                                    class="w-16 h-16 rounded-xl overflow-hidden flex-shrink-0 shadow-sm border border-white/80 transition-transform duration-300 group-hover:scale-105">
                                    <img src="${item.imageUrl}" alt="${item.productName}"
                                      class="w-full h-full object-cover"
                                      onerror="this.src='https://placehold.co/64x64/f0f2f5/9ca3af?text=N/A'">
                                  </div>
                                  <!-- Product info -->
                                  <div class="flex-1 min-w-0">
                                    <h4 class="font-display font-bold text-[15px] text-slate-900 mb-1 truncate">
                                      ${item.productName}</h4>
                                    <div class="flex flex-wrap items-center gap-2">
                                      <span
                                        class="inline-flex items-center gap-1 text-[9px] font-bold text-slate-400 uppercase tracking-wider bg-white/60 px-2.5 py-0.5 rounded-full border border-slate-100">
                                        <span
                                          class="material-symbols-outlined text-[12px] text-primary">receipt_long</span>
                                        Đơn #${orderId}
                                      </span>
                                      <span
                                        class="inline-flex items-center gap-1 text-[9px] font-bold text-accent-gold uppercase tracking-wider">
                                        <span class="material-symbols-outlined text-[12px]"
                                          style="font-variation-settings: 'FILL' 1;">verified</span>
                                        Đã mua
                                      </span>
                                    </div>
                                  </div>
                                </div>
                              </c:forEach>
                            </div>
                          </div>
                        </c:if>

                        <%-- Star Rating --%>
                          <div class="space-y-3">
                            <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider ml-1">Đánh giá
                              chất lượng <span class="text-red-400">*</span></label>
                            <div class="flex items-center gap-1 star-rating" id="starContainer">
                              <c:forEach begin="1" end="5" var="i">
                                <span class="material-symbols-outlined text-4xl text-slate-300 hover:text-accent-gold"
                                  style="font-variation-settings: 'FILL' 0, 'wght' 300;" data-star="${i}">star</span>
                              </c:forEach>
                              <span class="ml-4 text-sm font-medium text-slate-400" id="ratingLabel">Chọn số sao</span>
                            </div>
                          </div>

                          <%-- Comment --%>
                            <div class="space-y-2">
                              <div class="flex justify-between items-baseline ml-1 mr-1">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Nhận xét chi
                                  tiết</label>
                                <span class="text-[10px] text-slate-400 italic">Không bắt buộc</span>
                              </div>
                              <div class="relative">
                                <textarea name="comment" rows="4"
                                  class="w-full pl-5 pr-5 py-4 glass-input rounded-xl text-slate-800 font-medium resize-none"
                                  placeholder="Chia sẻ cảm nhận của bạn về chất liệu, kiểu dáng, trải nghiệm sử dụng..."></textarea>
                              </div>
                            </div>

                            <%-- Image Upload --%>
                              <div class="space-y-2">
                                <div class="flex justify-between items-baseline ml-1 mr-1">
                                  <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Hình ảnh đính kèm</label>
                                  <span class="text-[10px] text-slate-400 italic">Tối đa 5 MB &mdash; không bắt buộc</span>
                                </div>

                                <div id="dropZone"
                                  class="relative flex flex-col items-center justify-center gap-3 p-6 rounded-2xl border-2 border-dashed border-slate-200 bg-white/40 cursor-pointer transition-all duration-300 hover:border-blue-300 hover:bg-blue-50/30"
                                  onclick="document.getElementById('feedbackImage').click()">
                                  <input type="file" id="feedbackImage" name="feedbackImage" accept="image/*" class="hidden" onchange="handleImgSelect(this)">

                                  <%-- Default state --%>
                                  <div id="dropDefault" class="flex flex-col items-center gap-2 pointer-events-none">
                                    <div class="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center">
                                      <span class="material-symbols-outlined text-primary text-[26px]" style="font-variation-settings: 'FILL' 0;">add_a_photo</span>
                                    </div>
                                    <p class="text-sm font-medium text-slate-600">Click để chọn ảnh</p>
                                    <p class="text-[11px] text-slate-400">Hoặc kéo &amp; thả vào đây &mdash; JPG, PNG, WEBP</p>
                                  </div>

                                  <%-- Preview state (hidden by default) --%>
                                  <div id="dropPreview" class="hidden w-full flex flex-col items-center gap-3 pointer-events-none">
                                    <div class="relative inline-block">
                                      <img id="previewImg" src="" alt="Preview" class="max-h-44 max-w-full rounded-xl shadow-md object-contain border border-white">
                                      <button type="button" onclick="event.stopPropagation(); clearImg()"
                                        class="pointer-events-auto absolute -top-2 -right-2 w-7 h-7 bg-red-500 hover:bg-red-600 text-white rounded-full flex items-center justify-center shadow-md transition-colors">
                                        <span class="material-symbols-outlined text-[16px]">close</span>
                                      </button>
                                    </div>
                                    <p id="previewName" class="text-xs text-slate-500 font-medium"></p>
                                  </div>
                                </div>

                                <p class="text-[10px] text-slate-400 ml-1 tracking-wide">Ảnh thực tế giúp cộng đồng tham khảo tốt hơn</p>
                              </div>

                              <%-- Submit --%>
                                <div class="pt-4 flex flex-col sm:flex-row items-center gap-4">
                                  <button type="submit" id="submitBtn"
                                    class="w-full sm:w-auto px-10 py-3.5 bg-primary text-white rounded-xl shadow-lg shadow-blue-500/20 hover:shadow-blue-500/40 hover:bg-primary-dark transition-all duration-300 transform hover:-translate-y-0.5 flex items-center justify-center gap-2">
                                    <span class="material-symbols-outlined text-[18px]">send</span>
                                    <span class="font-semibold text-sm uppercase tracking-wide">Gửi đánh giá</span>
                                  </button>
                                  <a href="${pageContext.request.contextPath}/order"
                                    class="text-sm text-slate-400 hover:text-primary transition-colors font-medium">
                                    Quay lại đơn hàng
                                  </a>
                                </div>

                                <p class="text-[10px] text-slate-400 text-center leading-relaxed mt-4">
                                  Đánh giá của bạn sẽ hiển thị trên trang sản phẩm sau khi được xét duyệt bởi đội ngũ
                                  AISTHÉA.
                                </p>
                    </form>
                  </div>
                </div>
              </section>
            </div>
          </main>

          <!-- Footer -->
          <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

          <script>
            (function () {
              var stars = document.querySelectorAll('.star-rating span[data-star]');
              var ratingInput = document.getElementById('ratingValue');
              var ratingLabel = document.getElementById('ratingLabel');
              var labels = ['', 'Rất tệ', 'Tệ', 'Bình thường', 'Tốt', 'Xuất sắc'];

              stars.forEach(function (star, idx) {
                star.addEventListener('click', function () {
                  var val = idx + 1;
                  ratingInput.value = val;
                  ratingLabel.textContent = labels[val];
                  ratingLabel.style.color = '#C5A059';
                  stars.forEach(function (s, i) {
                    s.style.fontVariationSettings = i < val ? "'FILL' 1, 'wght' 400" : "'FILL' 0, 'wght' 300";
                    s.style.color = i < val ? '#C5A059' : '#cbd5e1';
                    s.style.transform = i < val ? 'scale(1.15)' : 'scale(1)';
                  });
                });

                star.addEventListener('mouseover', function () {
                  stars.forEach(function (s, i) {
                    if (i <= idx) {
                      s.style.color = '#C5A059';
                      s.style.fontVariationSettings = "'FILL' 1, 'wght' 400";
                    }
                  });
                  ratingLabel.textContent = labels[idx + 1];
                });

                star.addEventListener('mouseout', function () {
                  var cur = parseInt(ratingInput.value) || 0;
                  stars.forEach(function (s, i) {
                    s.style.fontVariationSettings = i < cur ? "'FILL' 1, 'wght' 400" : "'FILL' 0, 'wght' 300";
                    s.style.color = i < cur ? '#C5A059' : '#cbd5e1';
                    s.style.transform = i < cur ? 'scale(1.15)' : 'scale(1)';
                  });
                  ratingLabel.textContent = cur > 0 ? labels[cur] : 'Chọn số sao';
                  ratingLabel.style.color = cur > 0 ? '#C5A059' : '#94a3b8';
                });
              });

              // Form validation
              var form = document.getElementById('feedbackForm');
              form.addEventListener('submit', function (e) {
                if (!ratingInput.value || ratingInput.value === '0') {
                  e.preventDefault();
                  // Shake effect on stars
                  var container = document.getElementById('starContainer');
                  container.style.animation = 'none';
                  container.offsetHeight; // trigger reflow
                  container.style.animation = 'shake 0.4s ease';
                  ratingLabel.textContent = 'Vui lòng chọn số sao!';
                  ratingLabel.style.color = '#ef4444';
                }
              });
            })();

            // Product card selection
            function selectProduct(card) {
              var allCards = document.querySelectorAll('.product-card');
              allCards.forEach(function (c) {
                // Reset all cards
                c.classList.remove('border-primary', 'bg-primary/[0.03]', 'shadow-sm');
                c.classList.add('border-transparent', 'bg-white/40');
                // Reset check indicators
                var check = c.querySelector('.absolute.top-3');
                if (check) {
                  check.classList.remove('bg-primary', 'scale-100');
                  check.classList.add('bg-slate-200', 'scale-75', 'opacity-0');
                }
              });
              // Activate clicked card
              card.classList.remove('border-transparent', 'bg-white/40');
              card.classList.add('border-primary', 'bg-primary/[0.03]', 'shadow-sm');
              var activeCheck = card.querySelector('.absolute.top-3');
              if (activeCheck) {
                activeCheck.classList.remove('bg-slate-200', 'scale-75', 'opacity-0');
                activeCheck.classList.add('bg-primary', 'scale-100');
              }
              // Update hidden input
              document.getElementById('selectedProductId').value = card.getAttribute('data-product-id');
            }

            // ── Image upload helpers ──
            function handleImgSelect(input) {
              if (!input.files || !input.files[0]) return;
              var file = input.files[0];
              if (file.size > 5 * 1024 * 1024) {
                alert('Ảnh quá lớn! Vui lòng chọn ảnh nhỏ hơn 5 MB.');
                input.value = '';
                return;
              }
              var reader = new FileReader();
              reader.onload = function(e) {
                document.getElementById('previewImg').src = e.target.result;
                document.getElementById('previewName').textContent = file.name + ' (' + (file.size / 1024).toFixed(0) + ' KB)';
                document.getElementById('dropDefault').classList.add('hidden');
                document.getElementById('dropPreview').classList.remove('hidden');
              };
              reader.readAsDataURL(file);
            }

            function clearImg() {
              document.getElementById('feedbackImage').value = '';
              document.getElementById('previewImg').src = '';
              document.getElementById('previewName').textContent = '';
              document.getElementById('dropDefault').classList.remove('hidden');
              document.getElementById('dropPreview').classList.add('hidden');
            }

            // Drag-and-drop
            (function() {
              var zone = document.getElementById('dropZone');
              if (!zone) return;
              zone.addEventListener('dragover', function(e) {
                e.preventDefault();
                zone.classList.add('border-blue-400', 'bg-blue-50/60');
              });
              zone.addEventListener('dragleave', function() {
                zone.classList.remove('border-blue-400', 'bg-blue-50/60');
              });
              zone.addEventListener('drop', function(e) {
                e.preventDefault();
                zone.classList.remove('border-blue-400', 'bg-blue-50/60');
                var inp = document.getElementById('feedbackImage');
                if (e.dataTransfer.files.length > 0) {
                  var dt = new DataTransfer();
                  dt.items.add(e.dataTransfer.files[0]);
                  inp.files = dt.files;
                  handleImgSelect(inp);
                }
              });
            })();

          </script>

          <style>
            @keyframes shake {

              0%,
              100% {
                transform: translateX(0);
              }

              20% {
                transform: translateX(-8px);
              }

              40% {
                transform: translateX(8px);
              }

              60% {
                transform: translateX(-4px);
              }

              80% {
                transform: translateX(4px);
              }
            }
          </style>
        </body>

        </html>