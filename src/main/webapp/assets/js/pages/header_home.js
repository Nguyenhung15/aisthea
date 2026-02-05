(function () {
    const navItems = document.querySelectorAll('#main-nav .nav-item');
    const megaWrap = document.getElementById('mega-wrap');
    const megaContent = document.getElementById('mega-content');
    const searchIcon = document.getElementById('search-icon');
    const searchPop = document.getElementById('search-pop');

    let hideTimer = null;
    const contextPath = window.appContextPath || '';

    function buildMegaFor(section) {
        megaContent.innerHTML = '';
        
        const data = (window.megaMenuData && window.megaMenuData[section]) ? window.megaMenuData[section] : {};
        
        const keys = Object.keys(data);
        if (keys.length === 0) {
            megaContent.innerHTML = '<div style="padding:18px;color:var(--muted)">No content</div>';
            return;
        }
        
        for (const categoryName in data) {
            const itemData = data[categoryName];
            
            const linkUrl = `${contextPath}/${itemData.genderKey}/${itemData.index}`;

            const link = document.createElement('a');
            link.href = linkUrl;
            link.className = 'mega-menu-item';
            
            link.innerHTML = `
                <div class="item-image">
                    <img src="${itemData.img}" alt="${categoryName}">
                </div>
                <span class="item-name">${categoryName}</span>
            `;
            
            megaContent.appendChild(link);
        }
        
        megaContent.style.setProperty('--col-count', 4);
    }

    navItems.forEach(item => {
        item.addEventListener('mouseenter', () => {
            clearTimeout(hideTimer);
            navItems.forEach(i => i.classList.remove('active'));
            item.classList.add('active');

            const key = item.dataset.key;
            buildMegaFor(key);
            megaWrap.classList.add('active');

            if (typeof window.showSection === 'function') {
                window.showSection(key);
            }
        });
    });

    document.querySelectorAll('header, .mega-wrap').forEach(el => {
        el.addEventListener('mouseleave', () => {
            hideTimer = setTimeout(() => megaWrap.classList.remove('active'), 250);
        });
        el.addEventListener('mouseenter', () => clearTimeout(hideTimer));
    });

    searchIcon.addEventListener('click', (ev) => {
        ev.stopPropagation();
        if (searchPop.classList.contains('active')) {
            searchPop.classList.remove('active');
            searchPop.innerHTML = '';
            return;
        }
        searchPop.innerHTML = '';
        const input = document.createElement('input');
        input.placeholder = 'Tìm sản phẩm...';
        searchPop.appendChild(input);
        const results = document.createElement('div');
        results.style.marginTop = '8px';
        searchPop.appendChild(results);
        input.addEventListener('input', () => {
            const q = input.value.trim().toLowerCase();
            const list = [];
            const sections = window.megaMenuData || {};
            Object.keys(sections).forEach(sec => {
                Object.keys(sections[sec]).forEach(group => {
                    const item = sections[sec][group];
                    if (!q || group.toLowerCase().includes(q))
                        list.push({name: group, group: sec, img: item.img, link: `${contextPath}/${item.genderKey}/${item.index}`});
                });
            });
            if (list.length === 0)
                results.innerHTML = `<div style="padding:12px;color:var(--muted)">Không tìm thấy</div>`;
            else {
                results.innerHTML = list.map(p => `<a href="${p.link}" class="row-result" style="display:flex;gap:8px;padding:8px;align-items:center;cursor:pointer;text-decoration:none;color:inherit;">
      <img src="${p.img}" style="width:56px;height:56px;object-fit:cover;border-radius:6px">
      <div><div style="font-weight:600">${p.name}</div><div style="font-size:12px;color:var(--muted)">${p.group}</div></div>
    </a>`).join('');
            }
        });
        searchPop.classList.add('active');
    });

    document.addEventListener("DOMContentLoaded", () => {
        const accountBtn = document.getElementById("account-btn");
        const logoutMenu = document.getElementById("logout-menu");
        if (accountBtn && logoutMenu) {
            accountBtn.addEventListener("click", (e) => {
                e.stopPropagation();
                logoutMenu.style.display = logoutMenu.style.display === "block" ? "none" : "block";
            });

            document.addEventListener("click", (e) => {
                if (!accountBtn.contains(e.target) && !logoutMenu.contains(e.target)) {
                    logoutMenu.style.display = "none";
                }
            });
        }
    });

    document.addEventListener('click', (e) => {
        const inMega = e.target.closest('.mega');
        const inNav = e.target.closest('#main-nav');
        const inSearch = e.target.closest('#search-pop') || e.target.closest('#search-icon');
        if (!inMega && !inNav)
            megaWrap.classList.remove('active');
        if (!inSearch) {
            searchPop.classList.remove('active');
            searchPop.innerHTML = '';
        }
    });
})();