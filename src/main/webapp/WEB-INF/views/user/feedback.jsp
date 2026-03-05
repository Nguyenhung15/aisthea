<%@ page contentType="text/html;charset=UTF-8" language="java" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
      <!DOCTYPE html>
      <html lang="en">

      <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link
          href="https://fonts.googleapis.com/css2?family=Manrope:wght@200;300;400;500;600;700;800&amp;family=Playfair+Display:italic,wght@400;700&amp;display=swap"
          rel="stylesheet" />
        <link
          href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet" />
        <script id="tailwind-config">
          tailwind.config = {
            darkMode: "class",
            theme: {
              extend: {
                colors: {
                  "primary": "#2b8cee",
                  "background-light": "#f6f7f8",
                  "background-dark": "#101922",
                },
                fontFamily: {
                  "display": ["Manrope", "sans-serif"],
                  "serif": ["Playfair Display", "serif"]
                },
                borderRadius: { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" },
              },
            },
          }
        </script>
        <style type="text/tailwindcss">
          .gradient-bg {
            background: linear-gradient(to right, #ffffff, #e0f2fe);
        }
        .star-rating:hover span {
            color: #2b8cee;
        }
        .star-rating span:hover ~ span {
            color: #cbd5e1;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #2b8cee;
            box-shadow: none;
        }
    </style>
        <title>AISTHÉA | Individual Review Submission</title>
      </head>

      <body class="bg-background-light dark:bg-background-dark font-display text-slate-900 dark:text-slate-100">
        <div class="relative flex h-auto min-h-screen w-full flex-col gradient-bg group/design-root overflow-x-hidden">
          <div class="layout-container flex h-full grow flex-col">
            <header
              class="flex items-center justify-between whitespace-nowrap border-b border-solid border-primary/10 px-10 py-4 bg-white/50 backdrop-blur-md sticky top-0 z-50">
              <div class="flex items-center gap-12">
                <div class="flex items-center gap-3 text-slate-900">
                  <div class="size-6 text-primary">
                    <svg fill="none" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
                      <path
                        d="M42.4379 44C42.4379 44 36.0744 33.9038 41.1692 24C46.8624 12.9336 42.2078 4 42.2078 4L7.01134 4C7.01134 4 11.6577 12.932 5.96912 23.9969C0.876273 33.9029 7.27094 44 7.27094 44L42.4379 44Z"
                        fill="currentColor"></path>
                    </svg>
                  </div>
                  <h2 class="text-slate-900 text-xl font-bold leading-tight tracking-widest uppercase">AISTHÉA</h2>
                </div>
              </div>
              <div class="flex flex-1 justify-end items-center">
                <button class="p-2 hover:bg-primary/10 rounded-full transition-colors">
                  <span class="material-symbols-outlined text-slate-700">close</span>
                </button>
              </div>
            </header>
            <main class="flex-1 flex items-center justify-center py-16 px-6">
              <div class="max-w-[640px] w-full">
                <div class="bg-white/40 backdrop-blur-xl border border-white/80 rounded-2xl p-10 md:p-14 shadow-sm">
                  <div class="text-center mb-12">
                    <span class="text-primary font-bold tracking-[0.25em] text-[10px] uppercase mb-4 block">Product
                      Feedback</span>
                    <h1 class="text-slate-900 text-4xl font-extralight font-serif leading-tight mb-2">Share Your Sensory
                      Experience</h1>
                    <p class="text-slate-500 text-sm font-light">Your reflection helps us refine the art of formulation.
                    </p>
                  </div>
                  <div class="flex items-center gap-4 mb-12 p-4 bg-white/60 rounded-xl border border-white/40"
                    id="product-preview">
                    <c:choose>
                      <c:when test="${not empty orderItems}">
                        <div class="size-16 rounded-lg bg-slate-100 bg-center bg-cover flex-shrink-0" id="preview-img"
                          style="background-image: url('${orderItems[0].imageUrl}'); background-size:cover;">
                        </div>
                        <div>
                          <h3 class="text-slate-900 text-sm font-bold uppercase tracking-wider" id="preview-name">
                            ${orderItems[0].productName}</h3>
                          <p class="text-slate-400 text-xs font-medium">Đơn hàng #${orderId}</p>
                        </div>
                      </c:when>
                      <c:otherwise>
                        <div class="size-16 rounded-lg bg-slate-100 flex-shrink-0"></div>
                        <div>
                          <p class="text-slate-400 text-xs font-medium">Đơn hàng #${orderId}</p>
                        </div>
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <form class="space-y-10" action="${pageContext.request.contextPath}/feedback" method="POST">
                    <input type="hidden" name="orderId" value="${orderId}" />
                    <input type="hidden" name="rating" id="ratingValue" value="0" />

                    <%-- Product selector --%>
                      <c:choose>
                        <c:when test="${not empty orderItems and fn:length(orderItems) == 1}">
                          <%-- Chỉ 1 sản phẩm: dùng hidden --%>
                            <input type="hidden" name="productId" value="${orderItems[0].productId}" />
                        </c:when>
                        <c:when test="${not empty orderItems}">
                          <%-- Nhiều sản phẩm: dùng select dropdown --%>
                            <div class="space-y-2">
                              <label class="text-slate-500 text-[10px] font-bold uppercase tracking-widest">Chọn sản
                                phẩm
                                đánh giá</label>
                              <select name="productId"
                                class="w-full bg-white/60 border border-slate-200 rounded-xl px-5 py-3 text-slate-800 text-sm font-medium focus:border-primary focus:outline-none transition-all"
                                onchange="updatePreview(this.value)">
                                <c:forEach var="item" items="${orderItems}">
                                  <option value="${item.productId}">${item.productName}</option>
                                </c:forEach>
                              </select>
                            </div>
                        </c:when>
                        <c:otherwise>
                          <input type="hidden" name="productId" value="" />
                        </c:otherwise>
                      </c:choose>
                      <div class="flex flex-col items-center">
                        <label class="text-slate-500 text-[10px] font-bold uppercase tracking-widest mb-4">
                          Rating</label>
                        <div class="flex gap-2 star-rating cursor-pointer">
                          <span
                            class="material-symbols-outlined text-3xl text-slate-300 hover:text-primary transition-colors"
                            style="font-variation-settings: 'FILL' 0">star</span>
                          <span
                            class="material-symbols-outlined text-3xl text-slate-300 hover:text-primary transition-colors"
                            style="font-variation-settings: 'FILL' 0">star</span>
                          <span
                            class="material-symbols-outlined text-3xl text-slate-300 hover:text-primary transition-colors"
                            style="font-variation-settings: 'FILL' 0">star</span>
                          <span
                            class="material-symbols-outlined text-3xl text-slate-300 hover:text-primary transition-colors"
                            style="font-variation-settings: 'FILL' 0">star</span>
                          <span
                            class="material-symbols-outlined text-3xl text-slate-300 hover:text-primary transition-colors"
                            style="font-variation-settings: 'FILL' 0">star</span>
                        </div>
                      </div>
                      <div class="space-y-3">
                        <label
                          class="text-slate-500 text-[10px] font-bold uppercase tracking-widest flex justify-between">
                          Your Reflection
                          <span class="text-slate-300 normal-case font-normal italic">Optional</span>
                        </label>
                        <textarea name="comment"
                          class="w-full bg-white/60 border border-slate-200 rounded-xl px-5 py-4 text-slate-800 font-serif text-lg italic placeholder:text-slate-300 placeholder:font-sans placeholder:not-italic resize-none transition-all focus:bg-white"
                          placeholder="Share your sensory experience..." rows="5"></textarea>
                      </div>
                      <div class="space-y-3">
                        <label class="text-slate-500 text-[10px] font-bold uppercase tracking-widest">Aesthetic
                          Capture</label>
                        <div
                          class="border-2 border-dashed border-slate-200 rounded-xl p-8 text-center hover:border-primary/50 transition-colors group cursor-pointer bg-white/20">
                          <input class="hidden" id="photo-upload" type="file" />
                          <label class="cursor-pointer" for="photo-upload">
                            <span
                              class="material-symbols-outlined text-slate-400 text-3xl mb-2 group-hover:text-primary transition-colors">add_a_photo</span>
                            <p class="text-slate-400 text-xs font-medium">Upload high-quality images of your AISTHÉA
                              moment
                            </p>
                          </label>
                        </div>
                      </div>
                      <div class="pt-6">
                        <button
                          class="w-full bg-slate-900 text-white py-5 rounded-lg text-xs font-bold tracking-[0.3em] uppercase hover:bg-slate-800 transition-all shadow-lg shadow-slate-900/10 hover:shadow-slate-900/20 active:scale-[0.98]"
                          type="submit">
                          Submit Review
                        </button>
                        <p class="text-center text-slate-400 text-[10px] font-medium mt-6 uppercase tracking-widest">
                          By submitting, you agree to our <a class="underline hover:text-primary transition-colors"
                            href="#">terms of service</a>
                        </p>
                      </div>
                  </form>
                </div>
              </div>
            </main>
            <footer class="py-12 px-10 text-center">
              <div class="max-w-[1200px] mx-auto border-t border-primary/5 pt-8">
                <p class="text-[10px] text-slate-400 font-medium uppercase tracking-[0.2em]"> 2026 AISTHÉA. Individual
                  Feedback Protocol.</p>
              </div>
            </footer>
          </div>
        </div>

        <script>
            (function () {
              var stars = document.querySelectorAll('.star-rating span');
              var ratingInput = document.getElementById('ratingValue');

              stars.forEach(function (star, idx) {
                star.addEventListener('click', function () {
                  var val = idx + 1;
                  ratingInput.value = val;
                  stars.forEach(function (s, i) {
                    s.style.fontVariationSettings = i < val ? "'FILL' 1" : "'FILL' 0";
                    s.style.color = i < val ? '#2b8cee' : '';
                  });
                });
                star.addEventListener('mouseover', function () {
                  stars.forEach(function (s, i) {
                    s.style.color = i <= idx ? '#2b8cee' : '';
                  });
                });
                star.addEventListener('mouseout', function () {
                  var cur = parseInt(ratingInput.value) || 0;
                  stars.forEach(function (s, i) {
                    s.style.color = i < cur ? '#2b8cee' : '';
                  });
                });
              });

              // Validate rating before submit
              var form = document.querySelector('form[action*="feedback"]');
              if (form) {
                form.addEventListener('submit', function (e) {
                  if (!ratingInput.value || ratingInput.value === '0') {
                    e.preventDefault();
                    alert('Vui lòng chọn số sao đánh giá!');
                  }
                  // Also sync textarea to comment field
                  var ta = form.querySelector('textarea');
                  if (ta && !form.querySelector('input[name="comment"]')) {
                    ta.setAttribute('name', 'comment');
                  }
                });
              }
            })();
        </script>
        <script>
          // Build product map from server-rendered data
          var productMap = {};
        </script>
        <c:forEach var="item" items="${orderItems}">
          <script>productMap["${item.productId}"] = { name: "${item.productName}", img: "${item.imageUrl}" };</script>
        </c:forEach>
        <script>
          // Update preview when dropdown changes
          var sel = document.querySelector('select[name="productId"]');
          if (sel) {
            sel.addEventListener('change', function () {
              var p = productMap[this.value];
              if (p) {
                var imgEl = document.getElementById('preview-img');
                var nameEl = document.getElementById('preview-name');
                if (imgEl) imgEl.style.backgroundImage = "url('" + p.img + "')";
                if (nameEl) nameEl.textContent = p.name;
              }
            });
          }
        </script>
      </body>

      </html>-->