<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>AISTHÉA - Home</title>

        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main_layout.css">
    </head>
    <body>

        <%@ include file="/views/header_home.jsp" %>

        <div id="hero-wrapper">
            <section class="hero-section" data-section="women" data-title="OuterWear Fall" data-sub="Cozy & Layered">
                <div class="hero-bg" style="background-image:url('${pageContext.request.contextPath}/images/collections/women/winter/intro1/winter1.png')"></div>
                <div class="hero-overlay"></div>
                <div class="hero-content">
                    <div class="hero-card">
                        <div class="hero-title">OuterWear Fall</div>
                        <div class="hero-sub">Cozy & Layered</div>
                    </div>
                </div>
            </section>

            <section class="hero-section" data-section="women" data-title="Winter Collection" data-sub="Minimal looks you need">
                <div class="hero-bg" style="background-image:url('${pageContext.request.contextPath}/images/collections/women/winter/intro2/winter2.png')"></div>
                <div class="hero-overlay"></div>
                <div class="hero-content">
                    <div class="hero-card">
                        <div class="hero-title">Winter Collection</div>
                        <div class="hero-sub">Minimal looks you need</div>
                    </div>
                </div>
            </section>

            <section class="hero-section" data-section="men" data-title="Urban Workwear" data-sub="Smart & Comfortable">
                <div class="hero-bg" style="background-image:url('${pageContext.request.contextPath}/images/collections/men/intro/main.png')"></div>
                <div class="hero-overlay"></div>
                <div class="hero-content">
                    <div class="hero-card">
                        <div class="hero-title">Urban Workwear</div>
                        <div class="hero-sub">Smart & Comfortable</div>
                    </div>
                </div>
            </section>

            <section class="hero-section" data-section="stylist" data-title="Minimalist Picks" data-sub="Understated & clean">
                <div class="hero-bg" style="background-image:url('${pageContext.request.contextPath}/images/collections/stylist/intro/main.png')"></div>
                <div class="hero-overlay"></div>
                <div class="hero-content">
                    <div class="hero-card">
                        <div class="hero-title">Minimalist Picks</div>
                        <div class="hero-sub">Understated & clean</div>
                    </div>
                </div>
            </section>
        </div>

        <main id="product-list" style="padding:28px 40px; display:none;">
            <div id="grid" style="display:flex;flex-wrap:wrap;gap:20px;justify-content:center">
            </div>
        </main>
        
        <script>
            window.appContextPath = '${pageContext.request.contextPath}';
        </script>
        <script src="${pageContext.request.contextPath}/js/homepage.js"></script>
        <script src="${pageContext.request.contextPath}/js/header_home.js"></script>
    </body>
</html>