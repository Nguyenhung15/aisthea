<%@ page contentType="text/html;charset=UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Search Debug</title>
        <style>
            body {
                font-family: sans-serif;
                padding: 40px;
                max-width: 800px;
                margin: auto
            }

            #log {
                background: #f4f4f4;
                padding: 20px;
                border-radius: 8px;
                white-space: pre-wrap;
                font-family: monospace;
                font-size: 13px;
                max-height: 500px;
                overflow-y: auto
            }

            button {
                padding: 10px 24px;
                background: #024acf;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                margin: 8px 4px
            }

            h2 {
                color: #333
            }
        </style>
    </head>

    <body>
        <h2>Search Debug Tool</h2>
        <button onclick="testFetch()">1. Test Fetch</button>
        <button onclick="testParse()">2. Parse Cards</button>
        <button onclick="testSearch('áo')">3. Search "áo"</button>
        <button onclick="testSearch('quần')">4. Search "quần"</button>
        <button onclick="clearLog()">Clear</button>
        <div id="log">Click a button...\n</div>
        <script>
            var logEl = document.getElementById('log');
            var fetchedHtml = null, parsedDoc = null, allProducts = [];
            function log(m) { logEl.textContent += '\n' + m; logEl.scrollTop = logEl.scrollHeight }
            function clearLog() { logEl.textContent = '' }
            var ctxPath = '${pageContext.request.contextPath}';
            log('Context: ' + ctxPath);

            function testFetch() {
                log('\n=== FETCH ' + ctxPath + '/product?page=1 ===');
                fetch(ctxPath + '/product?page=1').then(function (r) {
                    log('Status: ' + r.status);
                    return r.text();
                }).then(function (html) {
                    fetchedHtml = html;
                    log('HTML length: ' + html.length);
                    log('Has "group cursor-pointer": ' + (html.indexOf('group cursor-pointer') !== -1));
                    log('Has "action=view": ' + (html.indexOf('action=view') !== -1));
                    var c = 0, idx = 0;
                    while ((idx = html.indexOf('group cursor-pointer', idx)) !== -1) { c++; idx += 20 }
                    log('Count "group cursor-pointer": ' + c);
                }).catch(function (e) { log('ERROR: ' + e.message) });
            }

            function testParse() {
                if (!fetchedHtml) { log('Run Step 1 first!'); return }
                log('\n=== PARSE ===');
                parsedDoc = new DOMParser().parseFromString(fetchedHtml, 'text/html');
                var s1 = parsedDoc.querySelectorAll('div.group');
                var s2 = parsedDoc.querySelectorAll('div.group.cursor-pointer');
                var s3 = parsedDoc.querySelectorAll('a[href*="action=view"]');
                var s4 = parsedDoc.querySelectorAll('h2');
                log('div.group: ' + s1.length);
                log('div.group.cursor-pointer: ' + s2.length);
                log('a[href*=action=view]: ' + s3.length);
                log('h2: ' + s4.length);
                allProducts = [];
                var cards = s2.length > 0 ? s2 : s1;
                cards.forEach(function (card, i) {
                    var lk = card.querySelector('a[href*="action=view"]');
                    var nm = card.querySelector('h2');
                    var br = card.querySelector('h3');
                    var im = card.querySelector('img');
                    var pr = card.querySelector('.text-primary');
                    var p = {
                        name: nm ? nm.textContent.trim() : '?', brand: br ? br.textContent.trim() : '?',
                        link: lk ? lk.getAttribute('href') : '?', img: im ? im.getAttribute('src') : '?',
                        price: pr ? pr.textContent.trim() : '?', text: card.textContent.toLowerCase()
                    };
                    allProducts.push(p);
                    log('  #' + (i + 1) + ': ' + p.name + ' | ' + p.brand);
                });
                if (cards.length === 0) {
                    log('NO CARDS! Trying links...');
                    s3.forEach(function (l, i) { log('  Link ' + (i + 1) + ': ' + l.getAttribute('href')) });
                }
            }

            function testSearch(kw) {
                if (!allProducts.length) { log('Run 1 & 2 first!'); return }
                log('\n=== Search "' + kw + '" ===');
                var m = allProducts.filter(function (p) { return p.text.indexOf(kw.toLowerCase()) !== -1 });
                log('Matches: ' + m.length + '/' + allProducts.length);
                m.forEach(function (p, i) { log('  ' + (i + 1) + ': ' + p.name) });
            }
        </script>
    </body>

    </html>