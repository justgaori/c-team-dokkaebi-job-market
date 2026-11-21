<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><c:out value="${job.title}"/> - 목깨비의 취업시장</title>
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
        <a href="<c:url value='/job/list'/>" class="active">채용정보</a>
        <a href="<c:url value='/board/list'/>">정보공유 게시판</a>
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
        <li><a href="<c:url value='/job/list'/>">채용정보</a></li>
        <li aria-current="page">공고 상세</li>
      </ol>
    </nav>
    <h1>채용정보</h1>
  </div>
</div>

<main class="container page" id="main" tabindex="-1">
  <c:if test="${job == null}">
    <div class="empty">존재하지 않는 채용공고입니다.</div>
    <div class="btn-row" style="justify-content:center; margin-top:20px;">
      <a class="btn secondary" href="<c:url value='/job/list'/>">목록으로</a>
    </div>
  </c:if>
  
  <c:if test="${job != null}">
    <div class="card">
      <div class="modal-tags" style="margin-bottom:12px;">
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
        <c:if test="${job.substYn == 'Y'}">
          <span class="tag orange">대체인력</span>
        </c:if>
      </div>
      
      <p class="company" style="margin:0 0 4px; color:var(--text-2); font-weight:600;"><c:out value="${job.orgName}"/></p>
      <h2 style="font-size:1.5rem; margin:0 0 16px;"><c:out value="${job.title}"/></h2>
      
      <dl class="kv">
        <dt>채용기간</dt>
        <dd>
          <fmt:formatDate value="${job.startDate}" pattern="yyyy-MM-dd"/> ~ 
          <fmt:formatDate value="${job.endDate}" pattern="yyyy-MM-dd"/>
          <c:if test="${!job.closed}">
            <span class="tag dday" style="margin-left:8px;">D-<c:out value="${job.dday}"/></span>
          </c:if>
        </dd>
        
        <c:if test="${not empty job.workRgnNm}">
          <dt>근무지역</dt>
          <dd><c:out value="${job.workRgnNm}"/></dd>
        </c:if>
        
        <c:if test="${not empty job.hireTypeNm}">
          <dt>고용형태</dt>
          <dd><c:out value="${job.hireTypeNm}"/></dd>
        </c:if>
        
        <c:if test="${not empty job.acbgCondNm}">
          <dt>학력요건</dt>
          <dd><c:out value="${job.acbgCondNm}"/></dd>
        </c:if>
        
        <c:if test="${not empty job.ncsNm}">
          <dt>NCS 분야</dt>
          <dd><c:out value="${job.ncsNm}"/></dd>
        </c:if>
        
        <c:if test="${job.hireCnt != null && job.hireCnt > 0}">
          <dt>채용인원</dt>
          <dd><c:out value="${job.hireCnt}"/>명</dd>
        </c:if>
      </dl>
    </div>
    
    <c:if test="${not empty job.qualifyCn}">
      <div class="card">
        <div class="card-head">
          <h2>지원자격</h2>
        </div>
        <div style="white-space:pre-wrap; line-height:1.8;"><c:out value="${job.qualifyCn}"/></div>
      </div>
    </c:if>
    
    <c:if test="${not empty job.prefCn}">
      <div class="card">
        <div class="card-head">
          <h2>우대사항</h2>
        </div>
        <div style="white-space:pre-wrap; line-height:1.8;"><c:out value="${job.prefCn}"/></div>
      </div>
    </c:if>
    
    <c:if test="${not empty job.procedureCn}">
      <div class="card">
        <div class="card-head">
          <h2>전형절차</h2>
        </div>
        <div style="white-space:pre-wrap; line-height:1.8;"><c:out value="${job.procedureCn}"/></div>
      </div>
    </c:if>
    
    <c:if test="${not empty job.files}">
      <div class="card">
        <div class="card-head">
          <h2>첨부파일</h2>
        </div>
        <ul style="list-style:none; margin:0; padding:0;">
          <c:forEach var="file" items="${job.files}">
            <li style="padding:8px 0; border-bottom:1px solid var(--line);">
              <a href="<c:out value='${file.fileUrl}'/>" target="_blank" rel="noopener">
                <span class="tag" style="margin-right:8px;"><c:out value="${file.fileTypeText}"/></span>
                <c:out value="${file.fileName}"/>
              </a>
            </li>
          </c:forEach>
        </ul>
      </div>
    </c:if>
    
    <div class="btn-row" style="justify-content:space-between; margin-top:24px;">
      <a class="btn secondary" href="<c:url value='/job/list'/>?pageNum=<c:out value='${cri.pageNum}'/>&amount=<c:out value='${cri.amount}'/>&keyword=<c:out value='${cri.keyword}'/>&region=<c:out value='${cri.region}'/>&jobType=<c:out value='${cri.jobType}'/>&employmentType=<c:out value='${cri.employmentType}'/>&status=<c:out value='${cri.status}'/>">목록</a>
      <c:if test="${not empty job.url}">
        <a class="btn" href="<c:out value='${job.url}'/>" target="_blank" rel="noopener">원문 보기 (잡알리오)</a>
      </c:if>
    </div>
    
    <p class="muted" style="text-align:center; margin-top:24px;">출처: 잡알리오(공공데이터포털)</p>
  </c:if>
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
