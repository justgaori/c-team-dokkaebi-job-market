<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>정보공유 게시판 - 목깨비의 취업시장</title>
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
        <li aria-current="page">정보공유 게시판</li>
      </ol>
    </nav>
    <h1>정보공유 게시판</h1>
    <p>재학생, 졸업생, 일반 게시판으로 나누어 취업 후기, 스터디, 지역 소식을 나누는 공간입니다.</p>
  </div>
</div>

<main class="container page" id="main" tabindex="-1">
  <div class="seg-tabs board-tabs" id="cat-tabs" aria-label="게시판 구분">
    <button type="button" role="tab" aria-selected="true" tabindex="0">전체<span class="cnt"><c:out value="${pageMaker.total}"/></span></button>
  </div>
  <div id="board-panel" aria-labelledby="cat-tabs">
    <div class="board-top">
      <div class="total" aria-live="polite">전체 <b id="total"><c:out value="${pageMaker.total}"/></b>건 <span class="muted" id="page-info">(<c:out value="${pageMaker.cri.pageNum}"/> / <c:out value="${pageMaker.endPage > 0 ? pageMaker.endPage : 1}"/> 페이지)</span></div>
      <form id="searchForm" class="search-bar" role="search" action="<c:url value='/board/list'/>" method="get">
        <label class="sr-only" for="kw">제목 또는 이름</label>
        <select name="type" style="width:auto;min-width:100px;margin-right:4px;">
          <option value="" <c:out value="${pageMaker.cri.type == null ? 'selected' : ''}"/>>전체</option>
          <option value="T" <c:out value="${pageMaker.cri.type eq 'T' ? 'selected' : ''}"/>>제목</option>
          <option value="C" <c:out value="${pageMaker.cri.type eq 'C' ? 'selected' : ''}"/>>내용</option>
          <option value="W" <c:out value="${pageMaker.cri.type eq 'W' ? 'selected' : ''}"/>>작성자</option>
          <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC' ? 'selected' : ''}"/>>제목+내용</option>
        </select>
        <input type="search" id="kw" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>' placeholder="제목 또는 이름 검색">
        <input type="hidden" name="pageNum" value="1">
        <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
        <button class="btn accent" type="submit">검색</button>
      </form>
    </div>
    <table class="board-table">
      <caption class="sr-only">정보공유 게시판 목록: 번호, 구분, 제목, 이름, 날짜</caption>
      <thead>
        <tr>
          <th scope="col" style="width:80px">번호</th>
          <th scope="col" style="width:100px">구분</th>
          <th scope="col">제목</th>
          <th scope="col" style="width:130px">이름</th>
          <th scope="col" style="width:130px">날짜</th>
        </tr>
      </thead>
      <tbody id="rows">
        <c:forEach items="${list}" var="board">
          <tr>
            <td class="num"><c:out value="${board.bno}"/></td>
            <td class="cat"><span class="tag gray">일반</span></td>
            <td class="title">
              <a class="move" href='<c:out value="${board.bno}"/>'><c:out value="${board.title}"/></a>
            </td>
            <td class="writer">
              <c:choose>
                <c:when test="${not empty board.username}"><c:out value="${board.username}"/></c:when>
                <c:otherwise><c:out value="${board.writer}"/></c:otherwise>
              </c:choose>
            </td>
            <td class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
          </tr>
        </c:forEach>
        <c:if test="${empty list}">
          <tr><td colspan="5" class="empty">등록된 게시글이 없습니다.</td></tr>
        </c:if>
      </tbody>
    </table>
    <div class="board-bottom">
      <div class="pagination" id="pager">
        <c:if test="${pageMaker.prev}">
          <button type="button" class="pageBtn" data-page="${pageMaker.startPage - 1}" aria-label="이전 페이지">‹</button>
        </c:if>
        <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
          <button type="button" class="pageBtn ${pageMaker.cri.pageNum == num ? 'on' : ''}" data-page="${num}" ${pageMaker.cri.pageNum == num ? 'aria-current="page"' : ''} aria-label="${num}페이지">${num}</button>
        </c:forEach>
        <c:if test="${pageMaker.next}">
          <button type="button" class="pageBtn" data-page="${pageMaker.endPage + 1}" aria-label="다음 페이지">›</button>
        </c:if>
      </div>
      <sec:authorize access="isAuthenticated()">
        <a class="btn" id="write-btn" href="<c:url value='/board/register'/>">글쓰기</a>
      </sec:authorize>
      <sec:authorize access="isAnonymous()">
        <a class="btn" id="write-btn" href="<c:url value='/login'/>">글쓰기</a>
      </sec:authorize>
    </div>
  </div>
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

<form id="actionForm" action="<c:url value='/board/list'/>" method="get">
  <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
  <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
  <input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}"/>'>
  <input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}"/>'>
</form>

<script>
document.addEventListener('DOMContentLoaded', function() {
  var result = '<c:out value="${result}"/>';
  if (result === 'success') {
    alert('처리가 완료되었습니다.');
  } else if (result && parseInt(result) > 0) {
    alert('게시글 ' + result + '번이 등록되었습니다.');
  }

  document.querySelectorAll('.pageBtn').forEach(function(btn) {
    btn.addEventListener('click', function() {
      var actionForm = document.getElementById('actionForm');
      actionForm.querySelector('[name="pageNum"]').value = this.dataset.page;
      actionForm.submit();
    });
  });

  document.querySelectorAll('.move').forEach(function(el) {
    el.addEventListener('click', function(e) {
      e.preventDefault();
      var actionForm = document.getElementById('actionForm');
      actionForm.action = '<c:url value="/board/get"/>';
      var bnoInput = document.createElement('input');
      bnoInput.type = 'hidden';
      bnoInput.name = 'bno';
      bnoInput.value = this.getAttribute('href');
      actionForm.appendChild(bnoInput);
      actionForm.submit();
    });
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
