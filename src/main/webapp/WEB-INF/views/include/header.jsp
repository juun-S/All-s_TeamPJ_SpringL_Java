<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<%--<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>--%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>

<!-- 헤더 영역 -->
<header>
    <!--스킵 내비게이션-->
    <div id="skipnav">
        <a href="#content">본문 바로가기</a>
    </div>
    <div class="logoarea">
        <!-- 로고 이미지 -->
        <a href="${root}/main"><img class="logo" src="${root}/resources/images/logo.png" style="width:100%" alt="all's 로고"/></a>
    </div>

    <div class="r-header">
        <div id="topmenu">
            <%-- 로그인한 사용자에게만 정보 표시 --%>
<%--            <sec:authorize access="isAuthenticated()">--%>
            <!-- 관리자 페이지 링크 -->
                <a class="manager-page" href="${root}/admin/websiteInfo"><i class="bi bi-gear"></i>관리자</a>
<%--            </sec:authorize>--%>
            <!-- 날씨 정보 링크 -->
            <a class="weather" href="#"><i class="bi bi-cloud-moon"></i>강남구 25°C</a>
            <%-- 로그인한 사용자에게만 정보 표시 --%>
            <sec:authorize access="isAuthenticated()">
                <!-- 프로필 링크 -->
                <a class="profile" href="#">
                    <div class="profile-img">
                        <img src="../img/manggom.png" alt="내 프로필">
                    </div>
                    <div class="status"><span class="status">접속중</span></div>
                </a>                    <!-- 알림 영역 -->
                <div class="alarm flex-colum hidden">
                    <div class="alarmprofile">
                        <div class="profile-img"><img src="${root}/resources/images/${userVo.profileImage}" alt="내 프로필"></div>
                        <p class="profile-username">
                            Jihyeon
                            <a class="manager-page" href="${root}/Users/UsersUpdateForm" aria-label="회원정보 수정"><i class="bi bi-gear"></i></a>
                        </p>
                    </div>
                    <div class="alarmList">
                        <h3>알림 내역</h3>
                        <ul>
                            <li>
                                <a href="#">
                                    <i class="bi bi-person-plus"></i>
                                    <span class="alarmitem">1건의 가입신청이 존재합니다</span>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <i class="bi bi-bell"></i>
                                    <span class="alarmitem">회원 등급이 상승했습니다</span>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <i class="bi bi-filter-square"></i>
                                    <span class="alarmitem">댓글이 달렸습니다</span>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <i class="bi bi-filter-square"></i>
                                    <span class="alarmitem">좋아요가 눌렸습니다</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                    <!-- 로그아웃 버튼 -->
                    <form method="POST" action="${root}/logout">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button class="secondary-default" type="submit">로그아웃</button>
                    </form>
                </div>
            </sec:authorize>
        </div>
        <!-- 모바일 사이즈 메뉴 -->
        <div class="m-size-nav">
            <button class="secondary-default menu-open">
                <i class="bi bi-list"></i>
                <span class="hide">메뉴 열기</span>
            </button>
            <!-- 공부 시작 버튼 -->
            <button id="m-timestart" class="primary-default" onclick="timerOpen()">공부 시작</button>
        </div>
    </div>
</header>