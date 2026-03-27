<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<% if (session.getAttribute("user") == null) { response.sendRedirect(request.getContextPath() + "/login"); return; } %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Đánh giá của tôi | AISTHÉA</title>
  <script src="https://cdn.tailwindcss.com?plugins=forms,typography"></script>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
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
        },
      },
    };
  </script>
  <style>
    .glass-island {
      background: rgba(255,255,255,0.65);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border: 1px solid rgba(255,255,255,0.8);
      box-shadow: 0 20px 40px -10px rgba(0,86,179,0.05);
    }
    .glass-input {
      background: rgba(255,255,255,0.4);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255,255,255,0.6);
      transition: all 0.3s ease;
    }
    .glass-input:focus {
      background: rgba(255,255,255,0.8);
      border-color: #0056b3;
      box-shadow: 0 0 0 4px rgba(0,86,179,0.1);
      outline: none;
    }
    .marble-texture {
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.05'/%3E%3C/svg%3E");
      opacity: 0.4;
      pointer-events: none;
    }
    /* Star rating editor */
    .edit-star { cursor: pointer; transition: all 0.2s; }
    /* Modal */
    #editModal { transition: opacity 0.25s ease; }
    @keyframes fadeInUp {
      from { opacity:0; transform:translateY(20px); }
      to   { opacity:1; transform:translateY(0); }
    }
    .toast-anim { animation: fadeInUp 0.35s ease; }
    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrollbar-track { background: transparent; }
    ::-webkit-scrollbar-thumb { background: rgba(0,86,179,0.2); border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: rgba(0,86,179,0.4); }
  </style>
</head>
<body class="bg-gradient-to-br from-white via-sky-50 to-blue-100 font-body min-h-screen text-slate-800">
  <div class="fixed inset-0 z-0">
    <div class="absolute inset-0 bg-gradient-to-br from-white via-sky-50 to-blue-100 opacity-80"></div>
    <div class="absolute inset-0 marble-texture"></div>
  </div>

  <jsp:include page="/WEB-INF/views/product/product-list-header.jsp" />

  <main class="relative z-10 max-w-7xl mx-auto px-4 pb-20 mt-8">
    <div class="flex flex-col lg:flex-row gap-8">
      <!-- Sidebar -->
      <jsp:include page="/WEB-INF/views/common/user-sidebar.jsp">
        <jsp:param name="activeTab" value="my-feedbacks" />
      </jsp:include>

      <!-- Main Content -->
      <section class="lg:w-3/4">
        <div class="glass-island rounded-[32px] p-8 lg:p-12 min-h-[600px] relative overflow-hidden">
          <div class="absolute top-0 right-0 w-[400px] h-[400px] bg-gradient-to-b from-blue-50/80 to-transparent rounded-bl-full pointer-events-none"></div>

          <div class="relative z-10">
            <!-- Header -->
            <header class="mb-8 border-b border-slate-200/60 pb-6 flex items-center justify-between flex-wrap gap-4">
              <div>
                <div class="flex items-center gap-2 mb-2">
                  <span class="material-symbols-outlined text-accent-gold text-[20px]" style="font-variation-settings:'FILL' 1;">rate_review</span>
                  <span class="text-[10px] font-bold text-accent-gold uppercase tracking-widest">Quản lý đánh giá</span>
                </div>
                <h1 class="font-display font-bold text-3xl text-slate-900 tracking-tight">Đánh giá của tôi</h1>
                <p class="text-slate-500 font-light text-sm mt-1">Xem, chỉnh sửa hoặc xóa các đánh giá bạn đã gửi</p>
              </div>
              <span class="inline-flex items-center gap-1.5 bg-primary/10 text-primary text-xs font-bold px-3 py-1.5 rounded-full">
                <span class="material-symbols-outlined text-[14px]">reviews</span>
                ${fn:length(myFeedbacks)} đánh giá
              </span>
            </header>

            <%-- Toast success --%>
            <c:if test="${param.updated == '1'}">
              <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 rounded-xl p-4 text-sm flex items-center gap-3 mb-6 toast-anim">
                <span class="material-symbols-outlined text-[20px]">check_circle</span>
                <span class="font-medium">Đánh giá đã được cập nhật thành công!</span>
              </div>
            </c:if>

            <%-- Empty state --%>
            <c:if test="${empty myFeedbacks}">
              <div class="flex flex-col items-center justify-center py-24 text-center">
                <div class="w-20 h-20 rounded-full bg-slate-100 flex items-center justify-center mb-5">
                  <span class="material-symbols-outlined text-slate-400 text-4xl">reviews</span>
                </div>
                <p class="text-slate-700 font-semibold text-lg">Bạn chưa có đánh giá nào</p>
                <p class="text-slate-400 text-sm mt-1">Mua sản phẩm và chia sẻ cảm nhận của bạn nhé!</p>
                <a href="${pageContext.request.contextPath}/product" class="mt-6 inline-flex items-center gap-2 bg-primary text-white px-6 py-2.5 rounded-xl text-sm font-semibold hover:bg-primary-dark transition-colors">
                  <span class="material-symbols-outlined text-[16px]">storefront</span>
                  Khám phá sản phẩm
                </a>
              </div>
            </c:if>

            <%-- Feedback list --%>
            <c:if test="${not empty myFeedbacks}">
              <div class="space-y-4">
                <c:forEach var="fb" items="${myFeedbacks}">
                  <div class="group bg-white/60 border border-slate-100 rounded-2xl p-5 hover:shadow-md hover:border-primary/20 transition-all duration-300"
                       id="fb-card-${fb.feedbackid}">
                    <div class="flex items-start justify-between gap-4 flex-wrap">
                      <!-- Product info + stars -->
                      <div class="flex-1 min-w-0">
                        <div class="flex items-center gap-2 mb-2 flex-wrap">
                          <span class="font-display font-bold text-slate-800 text-[15px] truncate">
                            <c:choose>
                              <c:when test="${not empty fb.productName}">${fb.productName}</c:when>
                              <c:otherwise>Sản phẩm #${fb.productid}</c:otherwise>
                            </c:choose>
                          </span>
                          <span class="text-[9px] uppercase tracking-widest font-bold px-2 py-0.5 rounded-full
                            ${fb.status == 'Visible' ? 'bg-emerald-100 text-emerald-700' : 'bg-amber-100 text-amber-700'}">
                            ${fb.status == 'Visible' ? 'Hiển thị' : fb.status}
                          </span>
                        </div>

                        <!-- Stars display -->
                        <div class="flex items-center gap-0.5 mb-3">
                          <c:forEach begin="1" end="5" var="s">
                            <span class="material-symbols-outlined text-[18px] ${s <= fb.rating ? 'text-accent-gold' : 'text-slate-200'}"
                                  style="font-variation-settings: '${s <= fb.rating ? 'FILL' : 'FILL'} ${s <= fb.rating ? '1' : '0'}', 'wght' 400;">star</span>
                          </c:forEach>
                          <span class="text-xs text-slate-400 ml-2 font-medium">${fb.rating}/5</span>
                        </div>

                        <!-- Comment -->
                        <p class="text-sm text-slate-600 leading-relaxed line-clamp-3 fb-comment-${fb.feedbackid}">
                          <c:choose>
                            <c:when test="${not empty fb.comment}">${fb.comment}</c:when>
                            <c:otherwise><em class="text-slate-400">Không có nhận xét</em></c:otherwise>
                          </c:choose>
                        </p>

                        <!-- Images -->
                        <c:if test="${not empty fb.imageUrl}">
                          <div class="mt-3 overflow-hidden rounded-xl border border-slate-100 inline-block group/img">
                            <c:set var="fbImgUrl" value="${fb.imageUrl}" />
                            <c:if test="${not fn:startsWith(fbImgUrl, 'http') and not fn:startsWith(fbImgUrl, '/')}">
                                <c:set var="fbImgUrl" value="${pageContext.request.contextPath}/uploads/${fbImgUrl}" />
                            </c:if>
                            <img src="${fbImgUrl}" alt="Feedback image" 
                                 class="max-w-[100px] h-20 object-cover hover:scale-105 transition-transform cursor-pointer"
                                 onclick="window.open('${fbImgUrl}', '_blank')"
                                 onerror="this.parentElement.style.display='none'"/>
                          </div>
                        </c:if>

                        <!-- Date -->
                        <p class="text-[11px] text-slate-400 mt-2 flex items-center gap-1">
                          <span class="material-symbols-outlined text-[13px]">schedule</span>
                          <fmt:formatDate value="${fb.createdat}" pattern="dd/MM/yyyy HH:mm" />
                          <c:if test="${fb.updatedat != null && fb.updatedat != fb.createdat}">
                            &nbsp;·&nbsp;<span class="italic">đã sửa <fmt:formatDate value="${fb.updatedat}" pattern="dd/MM/yyyy" /></span>
                          </c:if>
                        </p>
                      </div>

                      <!-- Action buttons -->
                      <div class="flex items-center gap-2 flex-shrink-0">
                        <!-- Edit -->
                        <button type="button"
                          data-fb-id="${fb.feedbackid}"
                          data-fb-rating="${fb.rating}"
                          data-fb-comment="${fn:replace(fb.comment, '&quot;', '&amp;quot;')}"
                          data-fb-product="${fn:escapeXml(fb.productName)}"
                          onclick="openEditModalFromBtn(this)"
                          class="flex items-center gap-1.5 px-3 py-2 rounded-lg text-sm font-semibold text-primary bg-primary/10 hover:bg-primary hover:text-white transition-all duration-200">
                          <span class="material-symbols-outlined text-[16px]">edit</span>
                          <span class="hidden sm:inline">Sửa</span>
                        </button>
                        <!-- Delete -->
                        <button type="button"
                          onclick="confirmDelete(${fb.feedbackid})"
                          class="flex items-center gap-1.5 px-3 py-2 rounded-lg text-sm font-semibold text-red-500 bg-red-50 hover:bg-red-500 hover:text-white transition-all duration-200">
                          <span class="material-symbols-outlined text-[16px]">delete</span>
                          <span class="hidden sm:inline">Xóa</span>
                        </button>
                      </div>
                    </div>

                    <!-- Admin reply (if any) -->
                    <c:if test="${not empty fb.adminReply}">
                      <div class="mt-3 p-3 bg-blue-50/60 border border-blue-100 rounded-xl text-xs">
                        <p class="font-bold text-primary flex items-center gap-1 mb-1">
                          <span class="material-symbols-outlined text-[14px]">support_agent</span>
                          Phản hồi từ AISTHÉA
                        </p>
                        <p class="text-slate-600">${fb.adminReply}</p>
                      </div>
                    </c:if>
                  </div>
                </c:forEach>
              </div>
            </c:if>
          </div>
        </div>
      </section>
    </div>
  </main>

  <!-- ══ Edit Modal ══ -->
  <div id="editModal" class="fixed inset-0 z-50 hidden flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-black/30 backdrop-blur-sm" onclick="closeEditModal()"></div>
    <div class="relative w-full max-w-lg glass-island rounded-3xl p-8 shadow-2xl" style="animation: fadeInUp 0.3s ease;">
      <button onclick="closeEditModal()" class="absolute top-4 right-4 w-8 h-8 flex items-center justify-center rounded-full bg-slate-100 hover:bg-slate-200 transition-colors">
        <span class="material-symbols-outlined text-[18px] text-slate-500">close</span>
      </button>

      <div class="flex items-center gap-2 mb-1">
        <span class="material-symbols-outlined text-primary text-[20px]" style="font-variation-settings:'FILL' 1;">edit_note</span>
        <span class="text-[10px] font-bold text-primary uppercase tracking-widest">Chỉnh sửa</span>
      </div>
      <h2 class="font-display font-bold text-2xl text-slate-900 mb-1">Sửa đánh giá</h2>
      <p id="editProductName" class="text-sm text-slate-500 mb-6"></p>

      <form id="editForm" method="POST" action="${pageContext.request.contextPath}/feedback" enctype="multipart/form-data">
        <input type="hidden" name="action" value="update" />
        <input type="hidden" name="feedbackId" id="editFeedbackId" />
        <input type="hidden" name="rating" id="editRatingValue" value="0" />
        <input type="hidden" name="existingImageUrl" id="editExistingImageUrl" />

        <!-- Image Preview -->
        <div class="mb-5 flex justify-center">
          <div class="relative group inline-block">
            <img id="editImagePreview" src="" alt="Preview" class="w-24 h-24 object-cover rounded-xl border border-slate-200 hidden" />
            <div id="editImagePlaceholder" class="w-24 h-24 bg-slate-100 rounded-xl flex items-center justify-center border border-dashed border-slate-300">
               <span class="material-symbols-outlined text-slate-400">add_a_photo</span>
            </div>
            <button type="button" id="editRemoveBtn" onclick="clearEditImg()" class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center hidden">
              <span class="material-symbols-outlined text-[12px]">close</span>
            </button>
          </div>
        </div>

        <div class="mb-5">
           <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Đổi ảnh (không bắt buộc)</label>
           <input type="file" name="feedbackImage" id="editImageInput" accept="image/*" class="w-full text-xs text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-primary/10 file:text-primary hover:file:bg-primary/20" onchange="previewEditImage(this)"/>
        </div>

        <!-- Stars editor -->
        <div class="mb-5">
          <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-3">Số sao <span class="text-red-400">*</span></label>
          <div class="flex items-center gap-1" id="editStarContainer">
            <c:forEach begin="1" end="5" var="i">
              <span class="edit-star material-symbols-outlined text-4xl text-slate-300"
                    style="font-variation-settings: 'FILL' 0, 'wght' 300;" data-val="${i}">star</span>
            </c:forEach>
            <span id="editRatingLabel" class="ml-3 text-sm font-medium text-slate-400">Chọn số sao</span>
          </div>
        </div>

        <!-- Comment -->
        <div class="mb-6">
          <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Nhận xét</label>
          <textarea name="comment" id="editComment" rows="4"
            class="w-full px-4 py-3 glass-input rounded-xl text-slate-800 font-medium resize-none"
            placeholder="Chia sẻ cảm nhận của bạn..."></textarea>
        </div>

        <div class="flex gap-3">
          <button type="submit"
            class="flex-1 py-3 bg-primary text-white rounded-xl font-semibold text-sm hover:bg-primary-dark transition-colors flex items-center justify-center gap-2">
            <span class="material-symbols-outlined text-[18px]">save</span>
            Lưu thay đổi
          </button>
          <button type="button" onclick="closeEditModal()"
            class="px-5 py-3 border border-slate-200 text-slate-600 rounded-xl font-semibold text-sm hover:bg-slate-50 transition-colors">
            Huỷ
          </button>
        </div>
      </form>
    </div>
  </div>

  <!-- ══ Delete Confirm Modal ══ -->
  <div id="deleteModal" class="fixed inset-0 z-50 hidden flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-black/30 backdrop-blur-sm" onclick="closeDeleteModal()"></div>
    <div class="relative w-full max-w-sm glass-island rounded-3xl p-8 text-center shadow-2xl" style="animation: fadeInUp 0.3s ease;">
      <div class="w-16 h-16 rounded-full bg-red-100 flex items-center justify-center mx-auto mb-4">
        <span class="material-symbols-outlined text-red-500 text-3xl" style="font-variation-settings:'FILL' 1;">delete_forever</span>
      </div>
      <h3 class="font-display font-bold text-xl text-slate-800 mb-2">Xóa đánh giá?</h3>
      <p class="text-slate-500 text-sm mb-6">Hành động này không thể hoàn tác. Đánh giá của bạn sẽ bị xóa vĩnh viễn.</p>
      <form id="deleteForm" method="POST" action="${pageContext.request.contextPath}/feedback">
        <input type="hidden" name="action" value="delete" />
        <input type="hidden" name="feedbackId" id="deleteFeedbackId" />
        <div class="flex gap-3">
          <button type="submit"
            class="flex-1 py-3 bg-red-500 text-white rounded-xl font-semibold text-sm hover:bg-red-600 transition-colors">
            Xóa
          </button>
          <button type="button" onclick="closeDeleteModal()"
            class="flex-1 py-3 border border-slate-200 text-slate-600 rounded-xl font-semibold text-sm hover:bg-slate-50 transition-colors">
            Huỷ
          </button>
        </div>
      </form>
    </div>
  </div>

  <jsp:include page="/WEB-INF/views/common/footer-luxury.jsp" />

  <script>
    const starLabels = ['', 'Rất tệ', 'Tệ', 'Bình thường', 'Tốt', 'Xuất sắc'];

    // ── Edit Modal ──
    function openEditModalFromBtn(btn) {
      const id = btn.getAttribute('data-fb-id');
      const rating = parseInt(btn.getAttribute('data-fb-rating')) || 0;
      const comment = btn.getAttribute('data-fb-comment') || '';
      const product = btn.getAttribute('data-fb-product') || '';
      const imageUrl = btn.getAttribute('data-fb-image') || '';
      openEditModal(id, rating, comment, product, imageUrl);
    }

    function openEditModal(id, rating, comment, productName, imageUrl) {
      document.getElementById('editFeedbackId').value = id;
      document.getElementById('editComment').value = comment;
      document.getElementById('editProductName').textContent = productName || 'Sản phẩm #' + id;
      document.getElementById('editExistingImageUrl').value = imageUrl || '';
      
      const preview = document.getElementById('editImagePreview');
      const placeholder = document.getElementById('editImagePlaceholder');
      const removeBtn = document.getElementById('editRemoveBtn');
      document.getElementById('editImageInput').value = '';

      if (imageUrl && imageUrl.trim() !== '') {
          let finalUrl = imageUrl;
          if (!finalUrl.startsWith('http') && !finalUrl.startsWith('/')) {
              finalUrl = '${pageContext.request.contextPath}/uploads/' + finalUrl;
          }
          preview.src = finalUrl;
          preview.classList.remove('hidden');
          placeholder.classList.add('hidden');
          removeBtn.classList.remove('hidden');
      } else {
          preview.src = '';
          preview.classList.add('hidden');
          placeholder.classList.remove('hidden');
          removeBtn.classList.add('hidden');
      }

      setEditStars(rating);
      document.getElementById('editModal').classList.remove('hidden');
      document.body.style.overflow = 'hidden';
    }

    function previewEditImage(input) {
      if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
          document.getElementById('editImagePreview').src = e.target.result;
          document.getElementById('editImagePreview').classList.remove('hidden');
          document.getElementById('editImagePlaceholder').classList.add('hidden');
          document.getElementById('editRemoveBtn').classList.remove('hidden');
        };
        reader.readAsDataURL(input.files[0]);
      }
    }

    function clearEditImg() {
      document.getElementById('editImageInput').value = '';
      document.getElementById('editImagePreview').src = '';
      document.getElementById('editImagePreview').classList.add('hidden');
      document.getElementById('editImagePlaceholder').classList.remove('hidden');
      document.getElementById('editRemoveBtn').classList.add('hidden');
      document.getElementById('editExistingImageUrl').value = '';
    }

    function closeEditModal() {
      document.getElementById('editModal').classList.add('hidden');
      document.body.style.overflow = '';
    }

    function setEditStars(val) {
      document.getElementById('editRatingValue').value = val;
      const label = document.getElementById('editRatingLabel');
      label.textContent = val > 0 ? starLabels[val] : 'Chọn số sao';
      label.style.color = val > 0 ? '#C5A059' : '#94a3b8';
      document.querySelectorAll('#editStarContainer .edit-star').forEach((s, i) => {
        const filled = i < val;
        s.style.fontVariationSettings = filled ? "'FILL' 1, 'wght' 400" : "'FILL' 0, 'wght' 300";
        s.style.color = filled ? '#C5A059' : '#cbd5e1';
        s.style.transform = filled ? 'scale(1.15)' : 'scale(1)';
      });
    }

    document.querySelectorAll('#editStarContainer .edit-star').forEach((star, idx) => {
      star.addEventListener('click', () => setEditStars(idx + 1));
      star.addEventListener('mouseover', () => {
        document.querySelectorAll('#editStarContainer .edit-star').forEach((s, i) => {
          s.style.color = i <= idx ? '#C5A059' : '#cbd5e1';
          s.style.fontVariationSettings = i <= idx ? "'FILL' 1, 'wght' 400" : "'FILL' 0, 'wght' 300";
        });
      });
      star.addEventListener('mouseout', () => {
        setEditStars(parseInt(document.getElementById('editRatingValue').value) || 0);
      });
    });

    document.getElementById('editForm').addEventListener('submit', function(e) {
      if (!document.getElementById('editRatingValue').value || document.getElementById('editRatingValue').value === '0') {
        e.preventDefault();
        document.getElementById('editRatingLabel').textContent = 'Vui lòng chọn số sao!';
        document.getElementById('editRatingLabel').style.color = '#ef4444';
      }
    });

    // ── Delete Modal ──
    function confirmDelete(id) {
      document.getElementById('deleteFeedbackId').value = id;
      document.getElementById('deleteModal').classList.remove('hidden');
      document.body.style.overflow = 'hidden';
    }
    function closeDeleteModal() {
      document.getElementById('deleteModal').classList.add('hidden');
      document.body.style.overflow = '';
    }

    // Close modals on Escape
    document.addEventListener('keydown', e => {
      if (e.key === 'Escape') { closeEditModal(); closeDeleteModal(); }
    });
  </script>
</body>
</html>
