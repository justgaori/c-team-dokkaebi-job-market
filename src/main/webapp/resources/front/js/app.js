/* 공통 스크립트: 임시 저장소(localStorage), 로그인 상태, 헤더/푸터, 토스트, 유틸
 * ※ 백엔드 연결 전 화면 확인용. 실제 연동 시 이 파일의 Store/Auth 부분을 API 호출로 교체한다.
 * ※ 비밀번호 평문 저장은 데모용이며 실제 서버에서는 반드시 BCrypt 등으로 암호화한다. */
(function (w) {
  'use strict';
  var K = { users: 'dk_users', session: 'dk_session', jobs: 'dk_jobs', posts: 'dk_posts', noti: 'dk_noti', saved: 'dk_saved', seeded: 'dk_seeded_v1' };

  var Store = {
    get: function (k, def) { try { var v = localStorage.getItem(k); return v ? JSON.parse(v) : def; } catch (e) { return def; } },
    set: function (k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { /* 저장 불가 환경 무시 */ } }
  };

  function seed() {
    if (Store.get(K.seeded, false)) return;
    Store.set(K.users, [
      { id: 'admin', pw: 'admin1234!', name: '관리자', email: 'admin@mokpo.ac.kr', role: 'ADMIN', interests: [] },
      { id: 'student1', pw: 'student1!', name: '이서연', email: 'student1@mokpo.ac.kr', role: 'USER', interests: ['IT·개발'] },
      { id: 'alumni1', pw: 'alumni1234!', name: '김가온', email: 'alumni1@mail.com', role: 'USER', interests: [] }
    ]);
    Store.set(K.jobs, SEED_JOBS);
    Store.set(K.posts, SEED_POSTS);
    Store.set(K.noti, [
      { id: 1, userId: 'student1', type: 'JOB', title: '백엔드 개발자 (Java/Spring) 신입 채용', field: 'IT·개발', link: 'jobs.html?id=1', at: '2026-11-02 09:12', read: false }
    ]);
    Store.set(K.saved, {});
    Store.set(K.seeded, true);
  }

  function esc(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }
  function now() {
    var d = new Date(), p = function (n) { return n < 10 ? '0' + n : '' + n; };
    return d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate()) + ' ' + p(d.getHours()) + ':' + p(d.getMinutes());
  }
  function today() { return now().slice(0, 10); }
  function qs(name) { return new URLSearchParams(location.search).get(name); }
  function nextId(list) { return list.reduce(function (m, x) { return Math.max(m, x.id); }, 0) + 1; }
  /* 외부 링크는 http/https만 허용 (XSS 방지) */
  function safeUrl(u) { return /^https?:\/\//i.test(u) ? u : '#'; }

  var Auth = {
    current: function () {
      var id = Store.get(K.session, null);
      if (!id) return null;
      return Store.get(K.users, []).filter(function (u) { return u.id === id; })[0] || null;
    },
    login: function (id, pw) {
      var u = Store.get(K.users, []).filter(function (x) { return x.id === id && x.pw === pw; })[0];
      if (!u) return false;
      Store.set(K.session, u.id); return true;
    },
    logout: function () { try { localStorage.removeItem(K.session); } catch (e) {} },
    isAdmin: function () { var u = Auth.current(); return !!u && u.role === 'ADMIN'; },
    /* 로그인 필요 페이지 보호 */
    require: function () {
      if (!Auth.current()) { location.replace('login.html?next=' + encodeURIComponent(location.pathname.split('/').pop() + location.search)); return false; }
      return true;
    },
    update: function (user) {
      var us = Store.get(K.users, []);
      us = us.map(function (u) { return u.id === user.id ? user : u; });
      Store.set(K.users, us);
    }
  };

  var Noti = {
    mine: function () {
      var u = Auth.current(); if (!u) return [];
      return Store.get(K.noti, []).filter(function (n) { return n.userId === u.id; }).sort(function (a, b) { return b.id - a.id; });
    },
    unread: function () { return Noti.mine().filter(function (n) { return !n.read; }).length; },
    push: function (n) {
      var list = Store.get(K.noti, []); n.id = nextId(list); n.at = now(); n.read = false; list.push(n); Store.set(K.noti, list);
    }
  };

  /* 게시글 구분(재학생/졸업생/일반)이 없는 예전 시연 데이터는 목업 원본에서, 그래도 없으면 '일반'으로 읽는다 */
  var Posts = {
    all: function () {
      var seed = w.SEED_POSTS || [];
      return Store.get(K.posts, []).map(function (p) {
        if (!p.category) {
          var s = seed.filter(function (x) { return x.id === p.id && x.writerId === p.writerId; })[0];
          p.category = s && s.category ? s.category : '일반';
        }
        return p;
      });
    },
    catTag: function (c) {
      var cls = { '재학생': '', '졸업생': 'navy', '일반': 'gray' };
      return c ? '<span class="tag ' + (cls[c] != null ? cls[c] : 'gray') + '">' + esc(c) + '</span>' : '';
    }
  };

  /* ---------- UI ---------- */

  /* 구분 탭 (WAI-ARIA tabs): items = [{ value, label, count, title }], 클릭과 ←/→/Home/End 키로 선택 */
  function segTabs(box, panel, items, selected, onSelect) {
    var pre = box.id || 'tabs';
    box.setAttribute('role', 'tablist');
    box.innerHTML = items.map(function (it, i) {
      var on = it.value === selected;
      return '<button type="button" role="tab" id="' + pre + '-' + i + '" aria-controls="' + panel.id + '" aria-selected="' + on + '" tabindex="' + (on ? 0 : -1) + '"' +
        ' data-value="' + esc(it.value) + '"' + (it.title ? ' title="' + esc(it.title) + '"' : '') + '>' + esc(it.label) +
        (it.count != null ? '<span class="cnt">' + it.count + '</span>' : '') + '</button>';
    }).join('');
    function pick(btn, focus) {
      Array.prototype.forEach.call(box.querySelectorAll('[role=tab]'), function (b) { var on = b === btn; b.setAttribute('aria-selected', on); b.tabIndex = on ? 0 : -1; });
      panel.setAttribute('aria-labelledby', btn.id);
      if (focus) btn.focus();
      onSelect(btn.getAttribute('data-value'));
    }
    box.onclick = function (e) { var b = e.target.closest('[role=tab]'); if (b) pick(b); };
    box.onkeydown = function (e) {
      var bs = Array.prototype.slice.call(box.querySelectorAll('[role=tab]')), i = bs.indexOf(document.activeElement);
      if (i < 0) return;
      var n = e.key === 'ArrowRight' ? (i + 1) % bs.length : e.key === 'ArrowLeft' ? (i - 1 + bs.length) % bs.length : e.key === 'Home' ? 0 : e.key === 'End' ? bs.length - 1 : -1;
      if (n > -1) { e.preventDefault(); pick(bs[n], true); }
    };
    var cur = box.querySelector('[aria-selected="true"]') || box.querySelector('[role=tab]');
    if (cur) panel.setAttribute('aria-labelledby', cur.id);
  }
  function toast(msg, type) {
    var wrap = document.querySelector('.toast-wrap');
    if (!wrap) { wrap = document.createElement('div'); wrap.className = 'toast-wrap'; wrap.setAttribute('role', 'status'); document.body.appendChild(wrap); }
    var t = document.createElement('div'); t.className = 'toast ' + (type || ''); t.textContent = msg; wrap.appendChild(t);
    setTimeout(function () { t.remove(); }, 3000);
  }

  /* 모달: 열리면 초점을 창 안으로 옮기고 Tab 이동을 창 안에 가두며, 닫히면 연 버튼으로 초점을 돌려준다 (웹 접근성) */
  var lastFocus = null;
  var FOCUSABLE = 'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';
  function openModal(html, wide) {
    closeModal();
    lastFocus = document.activeElement;
    var back = document.createElement('div'); back.className = 'modal-back'; back.id = 'modal-back';
    back.innerHTML = '<div class="modal ' + (wide ? 'wide' : '') + '" role="dialog" aria-modal="true" tabindex="-1">' + html + '</div>';
    var dlg = back.querySelector('.modal'), title = dlg.querySelector('h2');
    if (title) { title.id = 'modal-title'; dlg.setAttribute('aria-labelledby', 'modal-title'); }
    back.addEventListener('click', function (e) { if (e.target === back) closeModal(); });
    back.addEventListener('keydown', function (e) {
      if (e.key !== 'Tab') return;
      var f = dlg.querySelectorAll(FOCUSABLE); if (!f.length) return;
      var first = f[0], last = f[f.length - 1];
      if (e.shiftKey && (document.activeElement === first || document.activeElement === dlg)) { e.preventDefault(); last.focus(); }
      else if (!e.shiftKey && document.activeElement === last) { e.preventDefault(); first.focus(); }
    });
    document.body.appendChild(back);
    document.documentElement.classList.add('modal-open');
    var x = back.querySelector('[data-close]'); if (x) x.addEventListener('click', closeModal);
    dlg.focus();
    return back;
  }
  function closeModal() {
    var m = document.getElementById('modal-back'); if (!m) return;
    m.remove();
    document.documentElement.classList.remove('modal-open');
    if (lastFocus && lastFocus.focus && document.body.contains(lastFocus)) lastFocus.focus();
    lastFocus = null;
  }
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeModal(); });

  function confirmBox(msg, onYes) {
    var m = openModal('<p style="margin-top:0">' + esc(msg) + '</p><div class="btn-row" style="justify-content:flex-end"><button class="btn secondary" data-close>취소</button><button class="btn danger" id="cf-yes">확인</button></div>');
    m.querySelector('#cf-yes').addEventListener('click', function () { closeModal(); onYes(); });
  }

  /* 로고 마스코트 (옆에 사이트 이름이 함께 있으므로 대체 텍스트는 비움) */
  var EMBLEM = '<img class="emblem" src="img/mascot.png" alt="" width="143" height="160">';

  function renderChrome(active) {
    var u = Auth.current(), n = u ? Noti.unread() : 0;
    function link(href, key, label, extra) {
      return '<a href="' + href + '"' + (active === key ? ' class="active" aria-current="page"' : '') + '>' + label + (extra || '') + '</a>';
    }
    var menu = link('jobs.html', 'jobs', '채용정보') + link('board.html', 'board', '정보공유 게시판') +
      link('alerts.html', 'alerts', '맞춤 알림', n ? '<span class="badge">' + n + '<span class="sr-only">건 읽지 않음</span></span>' : '') +
      link('about.html', 'about', '서비스 소개');
    var acct = u ? '<span class="user-name">' + esc(u.name) + '님' + (u.role === 'ADMIN' && u.name !== '관리자' ? '<span class="role">관리자</span>' : '') + '</span><a href="#" id="logout-link">로그아웃</a>'
      : link('login.html', 'login', '로그인') + link('signup.html', 'signup', '회원가입');
    var h = document.getElementById('app-header');
    if (h) {
      h.className = 'site-header';
      h.innerHTML = '<a class="skip-link" href="#main">본문 바로가기</a>' +
        '<div class="util-bar"><div class="container"><p class="util-desc">목포대 재학생·졸업생을 위한 통합 취업정보 서비스</p>' +
        '<div class="util-menu"><div class="acct">' + acct + '</div></div></div></div>' +
        '<div class="gnb-wrap"><div class="container">' +
        '<a class="logo" href="index.html">' + EMBLEM + '<span>목깨비의 취업시장</span></a>' +
        '<button class="menu-btn" id="menu-btn" type="button" aria-label="주 메뉴 열기" aria-expanded="false" aria-controls="nav"><span></span><span></span><span></span></button>' +
        '<nav class="nav" id="nav" aria-label="주 메뉴">' + menu + '</nav></div></div>';
      var mb = document.getElementById('menu-btn');
      mb.addEventListener('click', function () {
        var o = document.getElementById('nav').classList.toggle('open');
        mb.setAttribute('aria-expanded', o); mb.setAttribute('aria-label', o ? '주 메뉴 닫기' : '주 메뉴 열기');
      });
      var lo = document.getElementById('logout-link');
      if (lo) lo.addEventListener('click', function (e) { e.preventDefault(); Auth.logout(); toast('로그아웃 되었습니다.', 'ok'); setTimeout(function () { location.href = 'index.html'; }, 600); });
    }
    var main = document.querySelector('main');
    if (main && !main.id) main.id = 'main';
    if (main) main.setAttribute('tabindex', '-1');
    var f = document.getElementById('app-footer');
    if (f) {
      f.className = 'site-footer';
      f.innerHTML = '<div class="container">' +
        '<ul class="footer-links"><li><a href="jobs.html">채용정보</a></li><li><a href="board.html">정보공유 게시판</a></li><li><a href="alerts.html">맞춤 알림</a></li><li><a href="about.html">서비스 소개</a></li></ul>' +
        '<div class="footer-brand">' + EMBLEM + '<span>목깨비의 취업시장</span></div>' +
        '<div class="footer-info"><p>국립목포대학교 컴퓨터공학과 C팀 프로젝트</p>' +
        '<p>화면 시연용 서비스입니다. 입력한 정보는 지금 사용 중인 브라우저에만 저장됩니다.</p></div>' +
        '<p class="copyright">© 2026 목깨비의 취업시장</p></div>';
    }
  }

  /* 입력 검증 유틸 */
  function setErr(input, msg) {
    var f = input.closest('.field'); if (!f) return;
    f.classList.toggle('invalid', !!msg);
    var e = f.querySelector('.error-msg');
    if (e) {
      e.textContent = msg || '';
      /* 화면낭독기가 오류 문구를 입력칸 설명으로 읽도록 연결 */
      if (!e.id && input.id) e.id = input.id + '-err';
      var ids = (input.getAttribute('aria-describedby') || '').split(/\s+/).filter(function (x) { return x && x !== e.id; });
      if (msg && e.id) ids.push(e.id);
      if (ids.length) input.setAttribute('aria-describedby', ids.join(' ')); else input.removeAttribute('aria-describedby');
    }
    if (msg) input.setAttribute('aria-invalid', 'true'); else input.removeAttribute('aria-invalid');
  }

  seed();
  w.DK = { K: K, Store: Store, Auth: Auth, Noti: Noti, Posts: Posts, segTabs: segTabs, esc: esc, now: now, today: today, qs: qs, nextId: nextId, safeUrl: safeUrl,
    toast: toast, openModal: openModal, closeModal: closeModal, confirmBox: confirmBox, renderChrome: renderChrome, setErr: setErr,
    resetDemo: function () { try { Object.keys(K).forEach(function (k) { localStorage.removeItem(K[k]); }); } catch (e) {} location.reload(); } };
})(window);
