/* 채용공고 공통 UI (index.html, jobs.html 에서 사용) */
(function (w) {
  'use strict';
  var DK = w.DK, esc = DK.esc;

  function allJobs() { return DK.Store.get(DK.K.jobs, []); }
  function byId(id) { return allJobs().filter(function (j) { return j.id === id; })[0]; }

  function savedIds() {
    var u = DK.Auth.current(); if (!u) return [];
    return (DK.Store.get(DK.K.saved, {})[u.id]) || [];
  }
  function toggleSave(id) {
    var u = DK.Auth.current();
    if (!u) { DK.toast('로그인 후 관심 공고를 저장할 수 있습니다.', 'err'); return null; }
    var all = DK.Store.get(DK.K.saved, {}), list = all[u.id] || [], i = list.indexOf(id);
    if (i > -1) list.splice(i, 1); else list.push(id);
    all[u.id] = list; DK.Store.set(DK.K.saved, all);
    DK.toast(i > -1 ? '관심 공고에서 제거했습니다.' : '관심 공고에 저장했습니다.', 'ok');
    return i === -1;
  }

  function statusTag(j) {
    if (j.status === '마감') return '<span class="tag red">마감</span>';
    if (j.status === '원문확인불가') return '<span class="tag orange">원문 확인 불가</span>';
    var d = Math.ceil((new Date(j.end) - new Date(DK.today())) / 86400000);
    return '<span class="tag green">모집중' + (d >= 0 && d <= 7 ? ' · D-' + d : '') + '</span>';
  }

  function card(j, opt) {
    opt = opt || {};
    var saved = savedIds().indexOf(j.id) > -1;
    return '<article class="job ' + (j.status !== '모집중' ? 'closed' : '') + '" data-id="' + j.id + '">' +
      '<div><div class="company">' + esc(j.company) + '</div>' +
      '<h3><a data-detail="' + j.id + '">' + esc(j.title) + '</a></h3>' +
      '<div class="meta">' + statusTag(j) + '<span class="tag">' + esc(j.field) + '</span><span class="tag gray">' + esc(j.region) + '</span>' +
      '<span class="tag gray">' + esc(j.career) + '</span><span class="tag gray">' + esc(j.empType) + '</span></div>' +
      '<div class="muted" style="margin-top:6px">모집기간 ' + esc(j.start) + ' ~ ' + esc(j.end) + ' · 출처 ' + esc(j.source) + '</div></div>' +
      '<div class="actions">' +
      '<button class="btn small secondary" data-detail="' + j.id + '">상세보기</button>' +
      '<button class="btn small ' + (saved ? 'accent' : 'secondary') + '" data-save="' + j.id + '">' + (saved ? '★ 저장됨' : '☆ 저장') + '</button>' +
      (opt.compare ? '<label class="check-label"><input type="checkbox" data-cmp="' + j.id + '"> 비교</label>' : '') +
      '</div></article>';
  }

  function detail(id) {
    var j = byId(id); if (!j) { DK.toast('공고를 찾을 수 없습니다.', 'err'); return; }
    var saved = savedIds().indexOf(id) > -1;
    var apply = j.status === '모집중' ?
      '<a class="btn accent" href="' + esc(DK.safeUrl(j.applyUrl)) + '" target="_blank" rel="noopener noreferrer">지원하러 가기 ↗</a>' :
      '<button class="btn" disabled>' + (j.status === '마감' ? '마감된 공고입니다' : '원문을 확인할 수 없습니다') + '</button>';
    var m = DK.openModal('<div class="modal-head"><div><div class="company muted">' + esc(j.company) + '</div><h2 style="margin:0">' + esc(j.title) + '</h2></div><button class="x" data-close aria-label="닫기">×</button></div>' +
      '<div style="margin-bottom:12px">' + statusTag(j) + ' <span class="tag">' + esc(j.field) + '</span></div>' +
      '<dl class="kv"><dt>직무(분야)</dt><dd>' + esc(j.field) + '</dd><dt>지역</dt><dd>' + esc(j.region) + '</dd><dt>경력</dt><dd>' + esc(j.career) + '</dd>' +
      '<dt>고용 형태</dt><dd>' + esc(j.empType) + '</dd><dt>모집 기간</dt><dd>' + esc(j.start) + ' ~ ' + esc(j.end) + '</dd>' +
      '<dt>출처</dt><dd>' + esc(j.source) + '</dd><dt>수집 일시</dt><dd>' + esc(j.collectedAt) + '</dd><dt>상태</dt><dd>' + esc(j.status) + '</dd>' +
      '<dt>상세 내용</dt><dd>' + esc(j.summary) + '</dd></dl>' +
      '<div class="btn-row" style="margin-top:18px">' + apply +
      '<button class="btn secondary" id="md-save">' + (saved ? '★ 저장됨' : '☆ 관심 공고 저장') + '</button></div>');
    m.querySelector('#md-save').addEventListener('click', function () {
      var r = toggleSave(id); if (r === null) return;
      this.textContent = r ? '★ 저장됨' : '☆ 관심 공고 저장';
      document.dispatchEvent(new CustomEvent('jobs:changed'));
    });
  }

  /* 비교 화면 (최대 3개) */
  function compare(ids) {
    var js = ids.map(byId).filter(Boolean);
    var rows = [['회사', 'company'], ['분야', 'field'], ['지역', 'region'], ['경력', 'career'], ['고용 형태', 'empType'], ['모집 시작', 'start'], ['모집 마감', 'end'], ['출처', 'source'], ['상태', 'status']];
    var h = '<div class="modal-head"><h2 style="margin:0">공고 비교</h2><button class="x" data-close aria-label="닫기">×</button></div><div class="table-scroll"><table><thead><tr><th>항목</th>' +
      js.map(function (j) { return '<th>' + esc(j.title) + '</th>'; }).join('') + '</tr></thead><tbody>' +
      rows.map(function (r) { return '<tr><th>' + r[0] + '</th>' + js.map(function (j) { return '<td>' + esc(j[r[1]]) + '</td>'; }).join('') + '</tr>'; }).join('') +
      '<tr><th>지원 경로</th>' + js.map(function (j) { return '<td>' + (j.status === '모집중' ? '<a href="' + esc(DK.safeUrl(j.applyUrl)) + '" target="_blank" rel="noopener noreferrer">지원 링크 ↗</a>' : '-') + '</td>'; }).join('') + '</tr>' +
      '</tbody></table></div>';
    DK.openModal(h, true);
  }

  /* 목록 컨테이너 이벤트 위임 */
  function bind(container, onChange) {
    container.addEventListener('click', function (e) {
      var d = e.target.closest('[data-detail]'); if (d) { e.preventDefault(); detail(+d.dataset.detail); return; }
      var s = e.target.closest('[data-save]'); if (s) { if (toggleSave(+s.dataset.save) !== null && onChange) onChange(); }
    });
  }

  w.Jobs = { all: allJobs, byId: byId, card: card, detail: detail, compare: compare, bind: bind, savedIds: savedIds, toggleSave: toggleSave, statusTag: statusTag };
})(window);
