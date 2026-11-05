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

  /* ---------- UI ---------- */
  function toast(msg, type) {
    var wrap = document.querySelector('.toast-wrap');
    if (!wrap) { wrap = document.createElement('div'); wrap.className = 'toast-wrap'; wrap.setAttribute('role', 'status'); document.body.appendChild(wrap); }
    var t = document.createElement('div'); t.className = 'toast ' + (type || ''); t.textContent = msg; wrap.appendChild(t);
    setTimeout(function () { t.remove(); }, 3000);
  }

  function openModal(html, wide) {
    closeModal();
    var back = document.createElement('div'); back.className = 'modal-back'; back.id = 'modal-back';
    back.innerHTML = '<div class="modal ' + (wide ? 'wide' : '') + '" role="dialog" aria-modal="true">' + html + '</div>';
    back.addEventListener('click', function (e) { if (e.target === back) closeModal(); });
    document.body.appendChild(back);
    var x = back.querySelector('[data-close]'); if (x) x.addEventListener('click', closeModal);
    return back;
  }
  function closeModal() { var m = document.getElementById('modal-back'); if (m) m.remove(); }
  document.addEventListener('keydown', function (e) { if (e.key === 'Escape') closeModal(); });

  function confirmBox(msg, onYes) {
    var m = openModal('<p style="margin-top:0">' + esc(msg) + '</p><div class="btn-row" style="justify-content:flex-end"><button class="btn secondary" data-close>취소</button><button class="btn danger" id="cf-yes">확인</button></div>');
    m.querySelector('#cf-yes').addEventListener('click', function () { closeModal(); onYes(); });
  }

  function renderChrome(active) {
    var u = Auth.current(), n = u ? Noti.unread() : 0;
    var nav = '<a href="jobs.html" class="' + (active === 'jobs' ? 'active' : '') + '">채용정보</a>' +
      '<a href="board.html" class="' + (active === 'board' ? 'active' : '') + '">게시판</a>' +
      '<a href="alerts.html" class="' + (active === 'alerts' ? 'active' : '') + '">알림' + (n ? ' <span class="badge">' + n + '</span>' : '') + '</a>';
    if (u) nav += '<span class="user-name">' + esc(u.name) + (u.role === 'ADMIN' ? ' (관리자)' : '') + '님</span><a href="#" id="logout-link">로그아웃</a>';
    else nav += '<a href="login.html" class="' + (active === 'login' ? 'active' : '') + '">로그인</a><a href="signup.html" class="' + (active === 'signup' ? 'active' : '') + '">회원가입</a>';
    var h = document.getElementById('app-header');
    if (h) {
      h.className = 'site-header';
      h.innerHTML = '<div class="container"><a class="logo" href="index.html">목깨비<span>의</span> 취업시장</a>' +
        '<button class="menu-btn" id="menu-btn" aria-label="메뉴 열기" aria-expanded="false">☰</button>' +
        '<nav class="nav" id="nav">' + nav + '</nav></div>';
      var mb = document.getElementById('menu-btn');
      mb.addEventListener('click', function () { var o = document.getElementById('nav').classList.toggle('open'); mb.setAttribute('aria-expanded', o); });
      var lo = document.getElementById('logout-link');
      if (lo) lo.addEventListener('click', function (e) { e.preventDefault(); Auth.logout(); toast('로그아웃 되었습니다.', 'ok'); setTimeout(function () { location.href = 'index.html'; }, 600); });
    }
    var f = document.getElementById('app-footer');
    if (f) { f.className = 'site-footer'; f.innerHTML = '<div class="container">© 2026 목깨비의 취업시장 · 국립목포대학교 컴퓨터공학과 C팀 · (화면 데모: 데이터는 이 브라우저에만 저장됩니다)</div>'; }
  }

  /* 입력 검증 유틸 */
  function setErr(input, msg) {
    var f = input.closest('.field'); if (!f) return;
    f.classList.toggle('invalid', !!msg);
    var e = f.querySelector('.error-msg'); if (e) e.textContent = msg || '';
  }

  seed();
  w.DK = { K: K, Store: Store, Auth: Auth, Noti: Noti, esc: esc, now: now, today: today, qs: qs, nextId: nextId, safeUrl: safeUrl,
    toast: toast, openModal: openModal, closeModal: closeModal, confirmBox: confirmBox, renderChrome: renderChrome, setErr: setErr,
    resetDemo: function () { try { Object.keys(K).forEach(function (k) { localStorage.removeItem(K[k]); }); } catch (e) {} location.reload(); } };
})(window);
