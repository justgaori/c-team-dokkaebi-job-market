/* 채용공고 공통 UI (index.html, jobs.html 에서 사용) */
(function (w) {
  'use strict';
  var DK = w.DK, esc = DK.esc;

  /* 기업 구분(companyType)이 없는 예전 시연 데이터는 화면 표시용으로 목업 원본에서 채워 읽는다 (저장값은 바꾸지 않음) */
  function allJobs() {
    var seed = w.SEED_JOBS || [];
    return DK.Store.get(DK.K.jobs, []).map(function (j) {
      if (!j.companyType) {
        var s = seed.filter(function (x) { return x.id === j.id && x.company === j.company; })[0];
        if (s && s.companyType) j.companyType = s.companyType;
      }
      return j;
    });
  }
  /* 지역 권역 묶음 (홈 최신 채용공고 탭, 채용정보 지역 필터에서 사용) */
  var AREAS = { '호남권': ['광주', '전남', '전북'], '수도권': ['서울', '경기', '인천'], '충청권': ['대전'], '영남권': ['부산', '대구'] };
  function inArea(j, area) { return (AREAS[area] || []).indexOf(j.region) > -1; }
  function ctypeTag(j) { return j.companyType ? '<span class="ctype">' + esc(j.companyType) + '</span>' : ''; }
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
    return '<span class="tag green">모집중</span>' + (d >= 0 && d <= 7 ? '<span class="tag dday">' + (d === 0 ? '오늘 마감' : 'D-' + d) + '</span>' : '');
  }

  function card(j, opt) {
    opt = opt || {};
    var saved = savedIds().indexOf(j.id) > -1;
    return '<article class="job' + (j.status !== '모집중' ? ' closed' : '') + '" data-id="' + j.id + '">' +
      '<div class="job-main">' +
      '<div class="job-top">' + statusTag(j) + '<span class="tag">' + esc(j.field) + '</span></div>' +
      '<h3><a href="jobs.html?id=' + j.id + '" data-detail="' + j.id + '">' + esc(j.title) + '</a></h3>' +
      '<p class="company">' + esc(j.company) + ctypeTag(j) + '</p>' +
      '<ul class="job-cond"><li>' + esc(j.region) + '</li><li>' + esc(j.career) + '</li><li>' + esc(j.empType) + '</li></ul></div>' +
      '<div class="job-side">' +
      '<dl class="job-dates"><div><dt>모집기간</dt><dd>' + esc(j.start) + ' ~ ' + esc(j.end) + '</dd></div><div><dt>출처</dt><dd>' + esc(j.source) + '</dd></div></dl>' +
      '<div class="actions">' +
      '<button type="button" class="btn small secondary" data-detail="' + j.id + '">상세보기</button>' +
      '<button type="button" class="btn small ' + (saved ? 'accent' : 'secondary') + '" data-save="' + j.id + '" aria-pressed="' + saved + '">' + (saved ? '★ 저장됨' : '☆ 저장') + '</button>' +
      (opt.compare ? '<label class="check-label"><input type="checkbox" data-cmp="' + j.id + '"> 비교</label>' : '') +
      '</div></div></article>';
  }

  function detail(id) {
    var j = byId(id); if (!j) { DK.toast('공고를 찾을 수 없습니다.', 'err'); return; }
    var saved = savedIds().indexOf(id) > -1;
    var apply = j.status === '모집중' ?
      '<a class="btn" href="' + esc(DK.safeUrl(j.applyUrl)) + '" target="_blank" rel="noopener noreferrer" title="새 창 열림">지원하러 가기 ↗<span class="sr-only">(새 창)</span></a>' :
      '<button class="btn" disabled>' + (j.status === '마감' ? '마감된 공고입니다' : '원문을 확인할 수 없습니다') + '</button>';
    var m = DK.openModal('<div class="modal-head"><div><div class="company muted">' + esc(j.company) + ctypeTag(j) + '</div><h2 style="margin:0">' + esc(j.title) + '</h2></div><button class="x" data-close aria-label="닫기">×</button></div>' +
      '<div class="modal-tags">' + statusTag(j) + '<span class="tag">' + esc(j.field) + '</span></div>' +
      '<dl class="kv"><dt>기업 구분</dt><dd>' + esc(j.companyType || '확인 중') + '</dd><dt>직무(분야)</dt><dd>' + esc(j.field) + '</dd><dt>지역</dt><dd>' + esc(j.region) + '</dd><dt>경력</dt><dd>' + esc(j.career) + '</dd>' +
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
    var rows = [['회사', 'company'], ['기업 구분', 'companyType'], ['분야', 'field'], ['지역', 'region'], ['경력', 'career'], ['고용 형태', 'empType'], ['모집 시작', 'start'], ['모집 마감', 'end'], ['출처', 'source'], ['상태', 'status']];
    var h = '<div class="modal-head"><h2 style="margin:0">공고 비교</h2><button class="x" data-close aria-label="닫기">×</button></div><div class="table-scroll"><table><thead><tr><th>항목</th>' +
      js.map(function (j) { return '<th>' + esc(j.title) + '</th>'; }).join('') + '</tr></thead><tbody>' +
      rows.map(function (r) { return '<tr><th>' + r[0] + '</th>' + js.map(function (j) { return '<td>' + esc(j[r[1]]) + '</td>'; }).join('') + '</tr>'; }).join('') +
      '<tr><th>지원 경로</th>' + js.map(function (j) { return '<td>' + (j.status === '모집중' ? '<a href="' + esc(DK.safeUrl(j.applyUrl)) + '" target="_blank" rel="noopener noreferrer" title="새 창 열림">지원 링크 ↗<span class="sr-only">(새 창)</span></a>' : '-') + '</td>'; }).join('') + '</tr>' +
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

  w.Jobs = { all: allJobs, byId: byId, card: card, ctypeTag: ctypeTag, AREAS: AREAS, inArea: inArea, detail: detail, compare: compare, bind: bind, savedIds: savedIds, toggleSave: toggleSave, statusTag: statusTag };
})(window);
