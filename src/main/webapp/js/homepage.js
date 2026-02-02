window.megaMenuData = {
    women: {
        "ÁO KHOÁC":      { genderKey: "women", index: "ao_khoac", img: "https://i.pinimg.com/1200x/e8/b4/08/e8b408e3efca56101817e5dcc493646d.jpg" },
        "ÁO THUN":       { genderKey: "women", index: "ao_thun", img: "https://i.pinimg.com/1200x/32/8f/54/328f54a667c60e64abcc633568ed7a3b.jpg" },
        "QUẦN":          { genderKey: "women", index: "quan", img: "https://i.pinimg.com/1200x/30/7a/c0/307ac07bef5fa0452e94c29e5208ae64.jpg" },
        "CHÂN VÁY & ĐẦM": { genderKey: "women", index: "vay_dam", img: "https://i.pinimg.com/1200x/39/4d/bb/394dbb1d073379c4247c0219d31b4e03.jpg" },
        "ĐỒ MẶC TRONG & ĐỒ LÓT": { genderKey: "women", index: "do_mac_trong", img: "https://i.pinimg.com/1200x/63/da/7c/63da7c57252c7e6599ec16b8721b0bcc.jpg" },
        "ÁO SƠ MI":      { genderKey: "women", index: "ao_so_mi", img: "https://image.hm.com/assets/hm/d5/6a/d56aac4cbad55f663d136f40ae3327c928888c70.jpg?imwidth=2160" },
        "ÁO LEN":        { genderKey: "women", index: "ao_len", img: "https://i.pinimg.com/1200x/45/c4/f2/45c4f2e1f048d0a3370f1a75b58cb18a.jpg" },
        "PHỤ KIỆN":      { genderKey: "women", index: "phu_kien", img: "https://i.pinimg.com/1200x/ec/06/6d/ec066d98dc47e663d91b9eea3a78071d.jpg" }
    },
    men: {
        "ÁO KHOÁC":    { genderKey: "men", index: "ao_khoac", img: "https://i.pinimg.com/1200x/65/cf/7e/65cf7ee1d1f4687fae539888444809b5.jpg" },
        "ÁO THUN":     { genderKey: "men", index: "ao_thun", img: "https://img.lazcdn.com/g/p/601589dc90f6190b44db9f69028f0912.jpg_720x720q80.jpg" },
        "ÁO LEN":      { genderKey: "men", index: "ao_len", img: "https://img.freepik.com/psd-mien-phi/ao-len-det-kim-mau-xam-thoi-trang-nam-trang-phuc-mua-dong-trang-phuc-thuong-ngay-ket-cau-mem-mai-quan-ao-thoai-mai_191095-84711.jpg?semt=ais_hybrid&w=740&q=80" },
        "ÁO SƠ MI":    { genderKey: "men", index: "ao_so_mi", img: "https://lados.vn/wp-content/uploads/2025/05/1-soc-den-ld8155.jpg" },
        "QUẦN":        { genderKey: "men", index: "quan", img: "https://polomanor.vn/cdn/shop/files/Polomanor_KakiSD_den_25012024_1.jpg?v=1756867743" },
        "ĐỒ THỂ THAO": { genderKey: "men", index: "do_the_thao", img: "https://armyhaus.com/wp-content/uploads/2020/08/IMG_9106.jpg" },
        "ĐỒ MẶC NHÀ":  { genderKey: "men", index: "do_mac_nha", img: "https://pos.nvncdn.com/4866c4-103846/ps/20251107_nCYAnqCFKF.jpeg?v=1762480080" },
        "PHỤ KIỆN":    { genderKey: "men", index: "phu_kien", img: "https://bizweb.dktcdn.net/100/527/490/files/day-lung-nam-cao-cap-da-that-khong-dau-khoa-lecos-ldb4-32.jpg?v=1739418145733" }
    },
    stylist: {
        "Minimalist": { genderKey: "stylist", index: "style_minimalist", img: "https://images.unsplash.com/photo-1551854838-ef3d0d7c2f4f?auto=format&fit=crop&w=800&q=60" },
        "Streetwear": { genderKey: "stylist", index: "style_streetwear", img: "https://images.unsplash.com/photo-1519741491601-9f5dcd2b0f3e?auto=format&fit=crop&w=800&q=60" }
    }
};

(function () {
    const sections = Array.from(document.querySelectorAll('.hero-section'));
    if (!sections.length)
        return;

    let currentIndex = 0;
    let isAnimating = false;
    const animDuration = 900; 

    function showAt(index, instant) {
        index = Math.max(0, Math.min(index, sections.length - 1));
        if (index === currentIndex && !instant)
            return;
        sections.forEach((s, i) => {
            if (i === index) {
                s.classList.add('active');
            } else {
                s.classList.remove('active');
            }
        });
        currentIndex = index;
    }

    window.showSection = function (key) {
        const idx = sections.findIndex(s => s.dataset.section === key);
        if (idx >= 0) {
            showAt(idx, false);
        }
    };

    let wheelTimeout = null;
    window.addEventListener('wheel', function (e) {
        if (isAnimating)
            return;
        const delta = e.deltaY;
        if (Math.abs(delta) < 10)
            return;
        if (delta > 0) { 
            if (currentIndex < sections.length - 1) {
                isAnimating = true;
                showAt(currentIndex + 1);
                clearTimeout(wheelTimeout);
                wheelTimeout = setTimeout(() => isAnimating = false, animDuration + 50);
            }
        } else { 
            if (currentIndex > 0) {
                isAnimating = true;
                showAt(currentIndex - 1);
                clearTimeout(wheelTimeout);
                wheelTimeout = setTimeout(() => isAnimating = false, animDuration + 50);
            }
        }
    }, {passive: true});

    window.addEventListener('keydown', function (e) {
        if (isAnimating)
            return;
        if (e.key === 'ArrowDown' || e.key === 'PageDown') {
            if (currentIndex < sections.length - 1) {
                isAnimating = true;
                showAt(currentIndex + 1);
                setTimeout(() => isAnimating = false, animDuration + 50);
            }
        } else if (e.key === 'ArrowUp' || e.key === 'PageUp') {
            if (currentIndex > 0) {
                isAnimating = true;
                showAt(currentIndex - 1);
                setTimeout(() => isAnimating = false, animDuration + 50);
            }
        }
    });

    let touchStartY = null;
    window.addEventListener('touchstart', (e) => {
        touchStartY = e.touches && e.touches[0] ? e.touches[0].clientY : null;
    }, {passive: true});
    window.addEventListener('touchend', (e) => {
        if (touchStartY === null)
            return;
        const endY = (e.changedTouches && e.changedTouches[0]) ? e.changedTouches[0].clientY : null;
        if (endY === null)
            return;
        const diff = touchStartY - endY;
        if (Math.abs(diff) < 40)
            return;
        if (diff > 0 && currentIndex < sections.length - 1) {
            isAnimating = true;
            setTimeout(() => isAnimating = false, animDuration + 50);
        }
        if (diff < 0 && currentIndex > 0) {
            isAnimating = true;
            showAt(currentIndex - 1);
            setTimeout(() => isAnimating = false, animDuration + 50);
        }
        touchStartY = null;
    }, {passive: true});

    showAt(0, true);

    window.getCurrentHeroIndex = () => currentIndex;
})();