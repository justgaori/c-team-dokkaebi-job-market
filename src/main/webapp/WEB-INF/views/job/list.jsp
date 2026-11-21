<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>채용정보 - 목깨비의 취업시장</title>
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
            <a href="<c:url value='/resources/front/login.html'/>">로그인</a>
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
        <a href="<c:url value='/job/list'/>" class="active" aria-current="page">채용정보</a>
        <a href="<c:url value='/board/list'/>">정보공유 게시판</a>
        <a href="<c:url value='/resources/front/alerts.html'/>">맞춤 알림</a>
        <a href="<c:url value='/resources/front/about.html'/>">서비스 소개</a>
      </nav>
    </div>
  </div>
</header>

<div class="page-head">
  <div class="container">
    <nav class="breadcrumb" aria-label="현재 위치"><ol><li><a href="<c:url value='/'/>">홈</a></li><li aria-current="page">채용정보</li></ol></nav>
    <h1>채용정보</h1>
    <p>공공기관 채용공고를 한곳에서 검색하고 비교하세요. <span class="muted">(출처: 잡알리오)</span></p>
  </div>
</div>

<main class="container page" id="main" tabindex="-1">
  <c:if test="${not empty message}">
    <div class="card" style="margin-bottom:20px; background:#e8f5ec; border-color:#bfe0c8;">
      <c:out value="${message}"/>
    </div>
  </c:if>

  <form id="searchForm" action="<c:url value='/job/list'/>" method="get">
    <input type="hidden" name="pageNum" value="1">
    <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
    
    <section class="search-box" aria-label="채용공고 검색 조건">
      <div class="search-bar" role="search">
        <label class="sr-only" for="keyword">검색어</label>
        <input type="search" id="keyword" name="keyword" placeholder="직무, 회사명, 키워드" value='<c:out value="${pageMaker.cri.keyword}"/>'>
        <button class="btn accent" type="submit">검색</button>
      </div>
      <div class="filters">
        <div>
          <label for="region">지역</label>
          <select id="region" name="region">
            <option value="">전체</option>
            <c:forEach var="r" items="${regions}">
              <option value='<c:out value="${r}"/>' ${pageMaker.cri.region == r ? 'selected' : ''}><c:out value="${r}"/></option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label for="jobType">분야(NCS)</label>
          <select id="jobType" name="jobType">
            <option value="">전체</option>
            <c:forEach var="jt" items="${jobTypes}">
              <option value='<c:out value="${jt}"/>' ${pageMaker.cri.jobType == jt ? 'selected' : ''}><c:out value="${jt}"/></option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label for="employmentType">고용형태</label>
          <select id="employmentType" name="employmentType">
            <option value="">전체</option>
            <c:forEach var="et" items="${employmentTypes}">
              <option value='<c:out value="${et}"/>' ${pageMaker.cri.employmentType == et ? 'selected' : ''}><c:out value="${et}"/></option>
            </c:forEach>
          </select>
        </div>
        <div>
          <label for="status">상태</label>
          <select id="status" name="status">
            <option value="">전체</option>
            <option value="ongoing" ${pageMaker.cri.status == 'ongoing' ? 'selected' : ''}>모집중</option>
          </select>
        </div>
        <div class="btn-cell">
          <button class="btn secondary" type="button" id="resetBtn">조건 초기화</button>
        </div>
      </div>
    </section>
  </form>

  <div class="result-info">
    <div class="total" aria-live="polite">총 <b><c:out value="${pageMaker.total}"/></b>건</div>
    <sec:authorize access="hasRole('ROLE_ADMIN')">
      <form action="<c:url value='/job/admin/refresh'/>" method="get" style="display:inline;">
        <button class="btn small" type="submit">데이터 갱신</button>
      </form>
    </sec:authorize>
  </div>

  <div class="job-list" id="list">
    <c:forEach var="job" items="${list}">
      <div class="job ${job.closed ? 'closed' : ''}">
        <div>
          <div class="job-top">
            <c:if test="${job.closed}">
              <span class="tag gray">마감</span>
            </c:if>
            <c:if test="${!job.closed}">
              <c:choose>
                <c:when test="${job.dday == 0}">
                  <span class="tag red">오늘마감</span>
                </c:when>
                <c:when test="${job.dday <= 3}">
                  <span class="tag dday">D-<c:out value="${job.dday}"/></span>
                </c:when>
                <c:otherwise>
                  <span class="tag">D-<c:out value="${job.dday}"/></span>
                </c:otherwise>
              </c:choose>
            </c:if>
            <c:if test="${not empty job.recrutSeNm}">
              <span class="tag navy"><c:out value="${job.recrutSeNm}"/></span>
            </c:if>
          </div>
          <h3><a href="<c:url value='/job/get'/>?jobId=<c:out value='${job.jobId}'/>&pageNum=<c:out value='${pageMaker.cri.pageNum}'/>&amount=<c:out value='${pageMaker.cri.amount}'/>&keyword=<c:out value='${pageMaker.cri.keyword}'/>&region=<c:out value='${pageMaker.cri.region}'/>&jobType=<c:out value='${pageMaker.cri.jobType}'/>&employmentType=<c:out value='${pageMaker.cri.employmentType}'/>&status=<c:out value='${pageMaker.cri.status}'/>"><c:out value="${job.title}"/></a></h3>
          <p class="company"><c:out value="${job.orgName}"/></p>
          <ul class="job-cond">
            <c:if test="${not empty job.workRgnNm}">
              <li><c:out value="${job.workRgnNm}"/></li>
            </c:if>
            <c:if test="${not empty job.hireTypeNm}">
              <li><c:out value="${job.hireTypeNm}"/></li>
            </c:if>
            <c:if test="${not empty job.acbgCondNm}">
              <li><c:out value="${job.acbgCondNm}"/></li>
            </c:if>
            <c:if test="${job.hireCnt != null && job.hireCnt > 0}">
              <li><c:out value="${job.hireCnt}"/>명 채용</li>
            </c:if>
          </ul>
        </div>
        <div class="job-side">
          <dl class="job-dates">
            <div>
              <dt>시작</dt>
              <dd><fmt:formatDate value="${job.startDate}" pattern="yyyy-MM-dd"/></dd>
            </div>
            <div>
              <dt>마감</dt>
              <dd><fmt:formatDate value="${job.endDate}" pattern="yyyy-MM-dd"/></dd>
            </div>
          </dl>
          <div class="actions">
            <a class="btn small secondary" href="<c:url value='/job/get'/>?jobId=<c:out value='${job.jobId}'/>&pageNum=<c:out value='${pageMaker.cri.pageNum}'/>&amount=<c:out value='${pageMaker.cri.amount}'/>&keyword=<c:out value='${pageMaker.cri.keyword}'/>&region=<c:out value='${pageMaker.cri.region}'/>&jobType=<c:out value='${pageMaker.cri.jobType}'/>&employmentType=<c:out value='${pageMaker.cri.employmentType}'/>&status=<c:out value='${pageMaker.cri.status}'/>">상세보기</a>
          </div>
        </div>
      </div>
    </c:forEach>
    
    <c:if test="${empty list}">
      <div class="empty">조건에 맞는 공고가 없습니다.<br>검색어나 필터를 바꿔 보세요.</div>
    </c:if>
  </div>

  <div class="pagination" id="pager">
    <c:if test="${pageMaker.prev}">
      <button type="button" data-page="${pageMaker.startPage - 1}" aria-label="이전 페이지">&lt;</button>
    </c:if>
    <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
      <button type="button" class="${pageMaker.cri.pageNum == num ? 'on' : ''}" data-page="${num}" ${pageMaker.cri.pageNum == num ? 'aria-current="page"' : ''} aria-label="${num}페이지">${num}</button>
    </c:forEach>
    <c:if test="${pageMaker.next}">
      <button type="button" data-page="${pageMaker.endPage + 1}" aria-label="다음 페이지">&gt;</button>
    </c:if>
  </div>

  <p class="muted" style="text-align:center; margin-top:24px;">출처: 잡알리오(공공데이터포털)</p>
</main>

<footer class="site-footer">
  <div class="container">
    <ul class="footer-links">
      <li><a href="<c:url value='/job/list'/>">채용정보</a></li>
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
  var searchForm = document.getElementById('searchForm');
  var pager = document.getElementById('pager');
  
  pager.addEventListener('click', function(e) {
    var btn = e.target.closest('button');
    if (btn && btn.dataset.page) {
      searchForm.querySelector('[name=pageNum]').value = btn.dataset.page;
      searchForm.submit();
    }
  });
  
  document.getElementById('resetBtn').addEventListener('click', function() {
    document.getElementById('keyword').value = '';
    document.getElementById('region').value = '';
    document.getElementById('jobType').value = '';
    document.getElementById('employmentType').value = '';
    document.getElementById('status').value = 'ongoing';
    searchForm.querySelector('[name=pageNum]').value = 1;
    searchForm.submit();
  });
  
  ['region', 'jobType', 'employmentType', 'status'].forEach(function(id) {
    document.getElementById(id).addEventListener('change', function() {
      searchForm.querySelector('[name=pageNum]').value = 1;
      searchForm.submit();
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
