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
                  },
                  fontFamily: {
                    display: ["'Playfair Display'", "serif"],
                    body: ["'Inter'", "sans-serif"],
                  },
                  backgroundImage: {
                    'ethereal-sky': "linear-gradient(180deg, #F8FAFC 0%, #E0F2FE 100%)",
                  },
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

            .marble-texture {
              background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.05'/%3E%3C/svg%3E");
              opacity: 0.4;
              pointer-events: none;
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

            .product-review-section {
              transition: all 0.3s ease;
            }

            .star-span {
              transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
              cursor: pointer;
              user-select: none;
            }

            @keyframes fadeInUp {
              from {
                opacity: 0;
                transform: translateY(16px);
              }

              to {
                opacity: 1;
                transform: translateY(0);
              }
            }

            .fade-in {
              animation: fadeInUp 0.4s ease both;
            }

            @keyframes shake {

              0%,
              100% {
                transform: translateX(0)
              }

              20% {
                transform: translateX(-8px)
              }

              40% {
                transform: translateX(8px)
              }

              60% {
                transform: translateX(-4px)
              }

              80% {
                transform: translateX(4px)
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
                  <div
                    class="absolute top-0 right-0 w-[400px] h-[400px] bg-gradient-to-b from-blue-50/80 to-transparent rounded-bl-full pointer-events-none">
                  </div>

                  <div class="relative z-10 max-w-3xl mx-auto">
                    <!-- Page Header -->
                    <header class="mb-10 border-b border-slate-200/60 pb-6">
                      <div class="flex items-center gap-2 mb-3">
                        <span class="material-symbols-outlined text-accent-gold text-[20px]"
                          style="font-variation-settings:'FILL' 1;">rate_review</span>
                        <span class="text-[10px] font-bold text-accent-gold uppercase tracking-widest">Đơn hàng
                          #${orderId}</span>
                      </div>
                      <h1 class="font-display font-bold text-3xl text-slate-900 mb-2 tracking-tight">Đánh giá sản phẩm
                      </h1>
                      <p class="text-slate-500 font-light text-sm tracking-wide">
                        <c:choose>
                          <c:when test="${fn:length(orderItems) > 1}">Điền đánh giá cho ${fn:length(orderItems)} sản
                            phẩm bên dưới rồi nhấn Gửi một lần.</c:when>
                          <c:otherwise>Chia sẻ trải nghiệm của bạn để giúp cộng đồng AISTHÉA lựa chọn tốt hơn.
                          </c:otherwise>
                        </c:choose>
                      </p>
                    </header>

                    <!-- ONE big form for all products -->
                    <form action="${pageContext.request.contextPath}/feedback" method="POST" id="feedbackForm"
                      enctype="multipart/form-data" class="space-y-10" novalidate>
                      <input type="hidden" name="action" value="submitAll" />
                      <input type="hidden" name="orderId" value="${orderId}" />
                      <input type="hidden" name="productIds" value="${productIdsCsv}" />

                      <%-- ── One section per product ── --%>
                        <c:forEach var="item" items="${orderItems}" varStatus="st">
                          <c:set var="pid" value="${item.productId}" />
                          <c:set var="existFb" value="${existingFeedbackMap[pid]}" />

                          <div
                            class="product-review-section fade-in rounded-2xl border border-slate-100 bg-white/50 shadow-sm overflow-hidden"
                            style="animation-delay: ${st.index * 0.08}s">

                            <%-- ── Product header ── --%>
                              <div
                                class="flex items-center gap-4 p-5 border-b border-slate-100 bg-gradient-to-r from-slate-50/80 to-white/40">
                                <div
                                  class="w-14 h-14 rounded-xl overflow-hidden flex-shrink-0 shadow-sm border border-white/80">
                                  <img src="${item.imageUrl}" alt="${item.productName}"
                                    class="w-full h-full object-cover"
                                    onerror="this.src='https://placehold.co/56x56/f0f2f5/9ca3af?text=N/A'">
                                </div>
                                <div class="flex-1 min-w-0">
                                  <h3 class="font-display font-bold text-[15px] text-slate-900 truncate">
                                    ${item.productName}</h3>
                                  <div class="flex items-center gap-2 mt-1">
                                    <span
                                      class="inline-flex items-center gap-1 text-[9px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full
                                     ${not empty existFb ? 'bg-amber-50 text-amber-600' : 'bg-emerald-50 text-emerald-600'}">
                                      <span class="material-symbols-outlined text-[11px]"
                                        style="font-variation-settings:'FILL' 1;">
                                        ${not empty existFb ? 'edit' : 'star'}
                                      </span>
                                      ${not empty existFb ? 'Đã đánh giá — chỉnh sửa bên dưới' : 'Chưa đánh giá'}
                                    </span>
                                  </div>
                                </div>
                              </div>

                              <%-- ── Hidden per-product fields ── --%>
                                <c:if test="${not empty existFb}">
                                  <input type="hidden" name="feedbackId_${pid}" value="${existFb.feedbackid}" />
                                  <c:if test="${not empty existFb.imageUrl}">
                                    <input type="hidden" name="existingImageUrl_${pid}" id="existingImageUrl_${pid}"
                                      value="${existFb.imageUrl}" />
                                  </c:if>
                                </c:if>
                                <input type="hidden" name="rating_${pid}" id="ratingValue_${pid}"
                                  value="${not empty existFb ? existFb.rating : 0}" />

                                <div class="p-6 space-y-6">

                                  <%-- ── Star Rating ── --%>
                                    <div class="space-y-2">
                                      <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider">
                                        Đánh giá chất lượng <span class="text-red-400">*</span>
                                      </label>
                                      <div class="flex items-center justify-center gap-2" id="starContainer_${pid}">
                                        <c:forEach begin="1" end="5" var="i">
                                          <span class="star-span material-symbols-outlined text-4xl"
                                            style="color:#cbd5e1; font-variation-settings:'FILL' 0,'wght' 300; transform:scale(1);"
                                            data-star="${i}" data-pid="${pid}" onmouseover="hoverStar(this)"
                                            onmouseout="unhoverStar('${pid}')" onclick="clickStar(this)">star</span>
                                        </c:forEach>
                                        <span class="ml-3 text-sm font-medium text-slate-400"
                                          id="ratingLabel_${pid}">Chọn số sao</span>
                                      </div>
                                    </div>

                                    <%-- ── Comment ── --%>
                                      <div class="space-y-2">
                                        <div class="flex justify-between items-baseline">
                                          <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Nhận
                                            xét chi tiết</label>
                                          <span class="text-[10px] text-slate-400 italic">Không bắt buộc</span>
                                        </div>
                                        <textarea name="comment_${pid}" rows="3"
                                          class="w-full pl-5 pr-5 py-3 glass-input rounded-xl text-slate-800 font-medium resize-none text-sm"
                                          placeholder="Chất liệu, kiểu dáng, trải nghiệm sử dụng...">${not empty existFb ? existFb.comment : ''}</textarea>
                                      </div>

                                      <%-- ── Image Upload ── --%>
                                        <div class="space-y-2">
                                          <div class="flex justify-between items-baseline">
                                            <label
                                              class="text-xs font-bold text-slate-500 uppercase tracking-wider">Hình ảnh
                                              đính kèm</label>
                                            <span class="text-[10px] text-slate-400 italic">Tối đa 5 MB — không bắt
                                              buộc</span>
                                          </div>

                                          <div id="dropZone_${pid}"
                                            class="relative flex flex-col items-center justify-center gap-3 p-5 rounded-2xl border-2 border-dashed border-slate-200 bg-white/40 cursor-pointer transition-all duration-300 hover:border-blue-300 hover:bg-blue-50/30"
                                            onclick="document.getElementById('feedbackImage_${pid}').click()">
                                            <input type="file" id="feedbackImage_${pid}" name="feedbackImage_${pid}"
                                              accept="image/*" class="hidden"
                                              onchange="handleImgSelect(this, '${pid}')">

                                            <%-- Default state --%>
                                              <div id="dropDefault_${pid}"
                                                class="flex flex-col items-center gap-2 pointer-events-none ${not empty existFb && not empty existFb.imageUrl ? 'hidden' : ''}">
                                                <span class="material-symbols-outlined text-primary text-[24px]"
                                                  style="font-variation-settings:'FILL' 0;">add_a_photo</span>
                                                <p class="text-sm font-medium text-slate-600">Click để chọn ảnh</p>
                                              </div>

                                              <%-- Preview state --%>
                                                <div id="dropPreview_${pid}"
                                                  class="pointer-events-none w-full flex flex-col items-center gap-2 ${not empty existFb && not empty existFb.imageUrl ? '' : 'hidden'}">
                                                  <div class="relative inline-block">
                                                    <img id="previewImg_${pid}"
                                                      src="${not empty existFb && not empty existFb.imageUrl ? (fn:startsWith(existFb.imageUrl, 'http') or fn:startsWith(existFb.imageUrl, '/') ? existFb.imageUrl : pageContext.request.contextPath.concat('/uploads/').concat(existFb.imageUrl)) : ''}"
                                                      alt="Preview"
                                                      class="max-h-36 max-w-full rounded-xl shadow-md object-contain border border-white">
                                                    <button type="button"
                                                      onclick="event.stopPropagation(); clearImg('${pid}')"
                                                      class="pointer-events-auto absolute -top-2 -right-2 w-6 h-6 bg-red-500 hover:bg-red-600 text-white rounded-full flex items-center justify-center shadow-md transition-colors">
                                                      <span class="material-symbols-outlined text-[13px]">close</span>
                                                    </button>
                                                  </div>
                                                  <p id="previewName_${pid}"
                                                    class="text-[11px] text-slate-500 font-medium">
                                                    ${not empty existFb && not empty existFb.imageUrl ? 'Ảnh hiện tại' :
                                                    ''}
                                                  </p>
                                                </div>
                                          </div>
                                        </div>

                                </div><%-- /p-6 --%>
                          </div>
                        </c:forEach>

                        <%-- ── Submit bar ── --%>
                          <div class="sticky bottom-6 z-20 flex justify-end ">
                            <p class="text-[11px] text-slate-400 text-center sm:text-left"></p>
                            <div class="flex items-center gap-4">
                              <a href="${pageContext.request.contextPath}/order?action=view&id=${orderId}"
                                class="text-sm text-slate-400 hover:text-primary transition-colors font-medium whitespace-nowrap">
                                Bỏ qua
                              </a>
                              <button type="submit" id="submitBtn"
                                class="px-8 py-3 bg-primary text-white rounded-xl shadow-lg shadow-blue-500/20 hover:shadow-blue-500/40 hover:bg-primary-dark transition-all duration-300 transform hover:-translate-y-0.5 flex items-center gap-2 whitespace-nowrap">
                                <span class="material-symbols-outlined text-[18px]">send</span>
                                <span class="font-semibold text-sm uppercase tracking-wide">Gửi đánh giá</span>
                              </button>
                            </div>
                          </div>
                  </div>

                  </form>
                </div><%-- /relative z-10 --%>
            </div>
            </section>
            </div>
          </main>

          <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

          <script>
            var starLabels = ['', 'Rất tệ', 'Tệ', 'Bình thường', 'Tốt', 'Xuất sắc'];

            // ── Star interactions ──
            function clickStar(el) {
              var pid = el.getAttribute('data-pid');
              var val = parseInt(el.getAttribute('data-star'));
              document.getElementById('ratingValue_' + pid).value = val;
              renderStars(pid, val, true);
            }

            function hoverStar(el) {
              var pid = el.getAttribute('data-pid');
              var val = parseInt(el.getAttribute('data-star'));
              getStars(pid).forEach(function (s, i) {
                s.style.color = i < val ? '#C5A059' : '#cbd5e1';
                s.style.fontVariationSettings = i < val ? "'FILL' 1,'wght' 400" : "'FILL' 0,'wght' 300";
              });
              var lbl = document.getElementById('ratingLabel_' + pid);
              if (lbl) lbl.textContent = starLabels[val];
            }

            function unhoverStar(pid) {
              var cur = parseInt(document.getElementById('ratingValue_' + pid).value) || 0;
              renderStars(pid, cur, false);
            }

            function renderStars(pid, val, setScale) {
              getStars(pid).forEach(function (s, i) {
                s.style.color = i < val ? '#C5A059' : '#cbd5e1';
                s.style.fontVariationSettings = i < val ? "'FILL' 1,'wght' 400" : "'FILL' 0,'wght' 300";
                if (setScale) s.style.transform = i < val ? 'scale(1.15)' : 'scale(1)';
              });
              var lbl = document.getElementById('ratingLabel_' + pid);
              if (lbl) {
                lbl.textContent = val > 0 ? starLabels[val] : 'Chọn số sao';
                lbl.style.color = val > 0 ? '#C5A059' : '#94a3b8';
              }
            }

            function getStars(pid) {
              return Array.from(document.querySelectorAll('#starContainer_' + pid + ' .star-span'));
            }

            // ── Auto-init all product stars from server-side rating values ──
            document.addEventListener('DOMContentLoaded', function () {
              document.querySelectorAll('input[id^="ratingValue_"]').forEach(function (inp) {
                var pid = inp.id.replace('ratingValue_', '');
                var val = parseInt(inp.value) || 0;
                if (val > 0) renderStars(pid, val, true);
              });
            });

            // ── Image helpers ──
            function handleImgSelect(input, pid) {
              if (!input.files || !input.files[0]) return;
              var file = input.files[0];
              if (file.size > 5 * 1024 * 1024) {
                alert('Ảnh quá lớn! Vui lòng chọn ảnh nhỏ hơn 5 MB.');
                input.value = '';
                return;
              }
              var reader = new FileReader();
              reader.onload = function (e) {
                document.getElementById('previewImg_' + pid).src = e.target.result;
                document.getElementById('previewName_' + pid).textContent = file.name + ' (' + (file.size / 1024).toFixed(0) + ' KB)';
                document.getElementById('dropDefault_' + pid).classList.add('hidden');
                document.getElementById('dropPreview_' + pid).classList.remove('hidden');
              };
              reader.readAsDataURL(file);
            }

            function clearImg(pid) {
              document.getElementById('feedbackImage_' + pid).value = '';
              document.getElementById('previewImg_' + pid).src = '';
              document.getElementById('previewName_' + pid).textContent = '';
              document.getElementById('dropDefault_' + pid).classList.remove('hidden');
              document.getElementById('dropPreview_' + pid).classList.add('hidden');
              var ex = document.getElementById('existingImageUrl_' + pid);
              if (ex) ex.value = '';
            }

            // ── Drag & drop per zone ──
            document.querySelectorAll('[id^="dropZone_"]').forEach(function (zone) {
              zone.addEventListener('dragover', function (e) {
                e.preventDefault();
                zone.classList.add('border-blue-400', 'bg-blue-50/60');
              });
              zone.addEventListener('dragleave', function () {
                zone.classList.remove('border-blue-400', 'bg-blue-50/60');
              });
              zone.addEventListener('drop', function (e) {
                e.preventDefault();
                zone.classList.remove('border-blue-400', 'bg-blue-50/60');
                var pid = zone.id.replace('dropZone_', '');
                var inp = document.getElementById('feedbackImage_' + pid);
                if (e.dataTransfer.files.length > 0) {
                  var dt = new DataTransfer();
                  dt.items.add(e.dataTransfer.files[0]);
                  inp.files = dt.files;
                  handleImgSelect(inp, pid);
                }
              });
            });

            // ── Form validation: at least one product must have a rating ──
            document.getElementById('feedbackForm').addEventListener('submit', function (e) {
              var ratingInputs = document.querySelectorAll('input[id^="ratingValue_"]');
              var anyRated = false;
              ratingInputs.forEach(function (inp) {
                if (parseInt(inp.value) > 0) anyRated = true;
              });
              if (!anyRated) {
                e.preventDefault();
                alert('Vui lòng chọn ít nhất 1 sản phẩm để đánh giá!');
              }
            });
          </script>
        </body>

        </html>