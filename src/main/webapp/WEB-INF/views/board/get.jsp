<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><c:out value="${board.title}"/> - 목깨비의 취업시장</title>
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
          <sec:authorize access="isAnonymous()">
            <a href="<c:url value='/login'/>">로그인</a>
          </sec:authorize>
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
        <li aria-current="page">게시글 보기</li>
      </ol>
    </nav>
    <h1>정보공유 게시판</h1>
  </div>
</div>

<main class="container page" id="main" tabindex="-1">
  <article id="view">
    <div class="post-head">
      <h2><c:out value="${board.title}"/></h2>
      <dl class="post-info">
        <div>
          <dt>구분</dt>
          <dd><span class="tag gray">일반</span></dd>
        </div>
        <div>
          <dt>이름</dt>
          <dd>
            <c:choose>
              <c:when test="${not empty board.username}"><c:out value="${board.username}"/></c:when>
              <c:otherwise><c:out value="${board.writer}"/></c:otherwise>
            </c:choose>
          </dd>
        </div>
        <div>
          <dt>날짜</dt>
          <dd><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></dd>
        </div>
      </dl>
    </div>
    <div class="post-body"><c:out value="${board.content}"/></div>
    <div class="post-actions">
      <div class="btn-row">
        <a class="btn secondary" href="<c:url value='/board/list'/>?pageNum=<c:out value='${cri.pageNum}'/>&amount=<c:out value='${cri.amount}'/>&type=<c:out value='${cri.type}'/>&keyword=<c:out value='${cri.keyword}'/>">목록</a>
        <button type="button" class="btn secondary" id="print">인쇄</button>
      </div>
      <sec:authentication property="principal" var="pinfo"/>
      <sec:authorize access="isAuthenticated()">
        <c:if test="${pinfo.username eq board.writer}">
          <div class="btn-row">
            <a class="btn" href="<c:url value='/board/modify'/>?bno=<c:out value='${board.bno}'/>&pageNum=<c:out value='${cri.pageNum}'/>&amount=<c:out value='${cri.amount}'/>&type=<c:out value='${cri.type}'/>&keyword=<c:out value='${cri.keyword}'/>">수정</a>
            <button type="button" class="btn danger" id="del">삭제</button>
          </div>
        </c:if>
      </sec:authorize>
      <sec:authorize access="hasRole('ROLE_ADMIN')">
        <c:if test="${pinfo.username ne board.writer}">
          <div class="btn-row">
            <a class="btn" href="<c:url value='/board/modify'/>?bno=<c:out value='${board.bno}'/>&pageNum=<c:out value='${cri.pageNum}'/>&amount=<c:out value='${cri.amount}'/>&type=<c:out value='${cri.type}'/>&keyword=<c:out value='${cri.keyword}'/>">수정</a>
            <button type="button" class="btn danger" id="del">삭제</button>
          </div>
        </c:if>
      </sec:authorize>
    </div>
  </article>
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

<form id="delForm" action="<c:url value='/board/remove'/>" method="post">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
  <input type="hidden" name="bno" value='<c:out value="${board.bno}"/>'>
  <input type="hidden" name="writer" value='<c:out value="${board.writer}"/>'>
  <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
  <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
  <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
  <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
</form>

<script>
document.addEventListener('DOMContentLoaded', function() {
  var printBtn = document.getElementById('print');
  if (printBtn) {
    printBtn.addEventListener('click', function() { window.print(); });
  }

  var delBtn = document.getElementById('del');
  if (delBtn) {
    delBtn.addEventListener('click', function() {
      if (confirm('이 게시글을 삭제하시겠습니까?')) {
        document.getElementById('delForm').submit();
      }
    });
  }

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
