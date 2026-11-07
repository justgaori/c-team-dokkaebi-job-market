<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<c:set var="pageTitle" value="로그인" scope="request"/>
<%@ include file="../includes/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-md-6 col-lg-4">
        <div class="card">
            <div class="card-header text-center">
                <h4><i class="bi bi-person-circle"></i> 로그인</h4>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${error}"/>
                    </div>
                </c:if>
                <c:if test="${not empty logout}">
                    <div class="alert alert-info" role="alert">
                        <c:out value="${logout}"/>
                    </div>
                </c:if>
                
                <form action="/login" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    
                    <div class="mb-3">
                        <label for="username" class="form-label">아이디</label>
                        <input type="text" class="form-control" id="username" name="username" 
                               placeholder="아이디를 입력하세요" required autofocus>
                    </div>
                    
                    <div class="mb-3">
                        <label for="password" class="form-label">비밀번호</label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="비밀번호를 입력하세요" required>
                    </div>
                    
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="remember" name="remember-me">
                        <label class="form-check-label" for="remember">로그인 상태 유지</label>
                    </div>
                    
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-box-arrow-in-right"></i> 로그인
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="../includes/footer.jsp" %>
