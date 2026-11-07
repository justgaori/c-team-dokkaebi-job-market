<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>글 수정 - 목깨비의 취업시장</title>
<link rel="stylesheet" href="<c:url value='/resources/front/css/style.css'/>">
<link rel="icon" type="image/png" href="<c:url value='/resources/front/img/favicon.png'/>">
</head>
<body>
<header class="site-header">
  <a class="skip-link" href="#main">본문 바로가기</a>
  <div class="util-bar">
    <div class="container">
      <p class="util-desc">목포대 재학생·졸업생을 위한 통합 취업정보 서비스</p>
      <div class="util-menu">
        <div class="acct">
          <sec:authorize access="isAuthenticated()">
            <span class="user-name"><sec:authentication property="principal.username"/>님</span>
            <form action="<c:url value='/logout'/>" method="post" style="display:inline;">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              <a href="#" onclick="this.closest('form').submit();return false;">로그아웃</a>
            </form>
          </sec:authorize>
        </div>
      </div>
    </div>
  </div>
  <div class="gnb-wrap">
    <div class="container">
      <a class="logo" href="<c:url value='/'/>">
        <img class="emblem" src="<c:url value='/resources/front/img/mascot.png'/>" alt="" width="143" height="160">
        <span>목깨비의 취업시장</span>
      </a>
      <button class="menu-btn" id="menu-btn" type="button" aria-label="주 메뉴 열기" aria-expanded="false" aria-controls="nav"><span></span><span></span><span></span></button>
      <nav class="nav" id="nav" aria-label="주 메뉴">
        <a href="<c:url value='/resources/front/jobs.html'/>">채용정보</a>
        <a href="<c:url value='/board/list'/>" class="active" aria-current="page">정보공유 게시판</a>
        <a href="<c:url value='/resources/front/alerts.html'/>">맞춤 알림</a>
        <a href="<c:url value='/resources/front/about.html'/>">서비스 소개</a>
      </nav>
    </div>
  </div>
</header>

<div class="page-head">
  <div class="container">
    <nav class="breadcrumb" aria-label="현재 위치">
      <ol>
        <li><a href="<c:url value='/'/>">홈</a></li>
        <li><a href="<c:url value='/board/list'/>">정보공유 게시판</a></li>
        <li aria-current="page" id="crumb">글 수정</li>
      </ol>
    </nav>
    <h1 id="head">글 수정</h1>
  </div>
</div>

<main class="container page" id="main" tabindex="-1">
  <form id="form" action="<c:url value='/board/modify'/>" method="post" novalidate>
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <input type="hidden" name="bno" value='<c:out value="${board.bno}"/>'>
    <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
    <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
    <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
    <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
    <p class="req-note"><span class="req" aria-hidden="true">*</span> 표시는 필수 입력 항목입니다.</p>
    <div class="form-table">
      <div class="field">
        <div class="field-label" id="cat-label">구분<span class="req" aria-hidden="true">*</span></div>
        <div class="field-body">
          <div class="radio-row" id="cats" role="radiogroup" aria-labelledby="cat-label" aria-required="true">
            <label class="radio"><input type="radio" name="category" value="재학생">재학생</label>
            <label class="radio"><input type="radio" name="category" value="졸업생">졸업생</label>
            <label class="radio"><input type="radio" name="category" value="일반" checked>일반</label>
          </div>
          <div class="error-msg"></div>
        </div>
      </div>
      <div class="field">
        <label for="title">제목<span class="req" aria-hidden="true">*</span></label>
        <div class="field-body">
          <input type="text" id="title" name="title" maxlength="100" required placeholder="제목을 입력해 주세요" value='<c:out value="${board.title}"/>'>
          <div class="error-msg"></div>
        </div>
      </div>
      <div class="field">
        <label for="content">내용<span class="req" aria-hidden="true">*</span></label>
        <div class="field-body">
          <textarea id="content" name="content" maxlength="2000" required aria-describedby="cnt-hint" placeholder="내용을 입력해 주세요"><c:out value="${board.content}"/></textarea>
          <div class="hint count" id="cnt-hint"><span id="cnt">0</span> / 2000자</div>
          <div class="error-msg"></div>
        </div>
      </div>
      <div class="field">
        <label for="writer">작성자</label>
        <div class="field-body">
          <input type="text" id="writer" name="writer" value='<c:out value="${board.writer}"/>' readonly style="background:#f4f6f9;">
        </div>
      </div>
    </div>
    <div class="btn-row form-actions">
      <button class="btn" type="submit" data-oper="modify">저장</button>
      <button class="btn danger" type="button" data-oper="remove">삭제</button>
      <a class="btn secondary" id="cancel" href="<c:url value='/board/get'/>?bno=<c:out value='${board.bno}'/>&pageNum=<c:out value='${cri.pageNum}'/>&amount=<c:out value='${cri.amount}'/>&type=<c:out value='${cri.type}'/>&keyword=<c:out value='${cri.keyword}'/>">취소</a>
    </div>
  </form>
</main>

<footer class="site-footer">
  <div class="container">
    <ul class="footer-links">
      <li><a href="<c:url value='/resources/front/jobs.html'/>">채용정보</a></li>
      <li><a href="<c:url value='/board/list'/>">정보공유 게시판</a></li>
      <li><a href="<c:url value='/resources/front/alerts.html'/>">맞춤 알림</a></li>
      <li><a href="<c:url value='/resources/front/about.html'/>">서비스 소개</a></li>
    </ul>
    <div class="footer-brand">
      <img class="emblem" src="<c:url value='/resources/front/img/mascot.png'/>" alt="" width="143" height="160">
      <span>목깨비의 취업시장</span>
    </div>
    <div class="footer-info">
      <p>국립목포대학교 컴퓨터공학과 C팀 프로젝트</p>
      <p>화면 시연용 서비스입니다.</p>
    </div>
    <p class="copyright">© 2026 목깨비의 취업시장</p>
  </div>
</footer>

<script>
document.addEventListener('DOMContentLoaded', function() {
  var content = document.getElementById('content');
  var cnt = document.getElementById('cnt');
  var formObj = document.getElementById('form');

  function updateCount() {
    cnt.textContent = content.value.length;
  }
  content.addEventListener('input', updateCount);
  updateCount();

  document.querySelector('[data-oper="remove"]').addEventListener('click', function() {
    if (confirm('이 게시글을 삭제하시겠습니까?')) {
      formObj.action = '<c:url value="/board/remove"/>';
      formObj.submit();
    }
  });

  var menuBtn = document.getElementById('menu-btn');
  if (menuBtn) {
    menuBtn.addEventListener('click', function() {
      var nav = document.getElementById('nav');
      var open = nav.classList.toggle('open');
      menuBtn.setAttribute('aria-expanded', open);
      menuBtn.setAttribute('aria-label', open ? '주 메뉴 닫기' : '주 메뉴 열기');
    });
  }
});
</script>
</body>
</html>
