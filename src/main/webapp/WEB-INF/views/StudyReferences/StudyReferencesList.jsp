<%--
  Created by IntelliJ IDEA.
  User: yujung
  Date: 6/14/24
  Time: 2:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        h1 {
            font-weight: 600;
            font-size: 36px;
            color: #263238;
        }
        .container {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px; /* Add space between elements */
        }
        .total-post {
            font-size: 20px;
            font-weight: 600;
        }
        .search-option {
            width: 180px;
            height: 56px;
            font-size: 19px;
            color: #1d1d1d;
            border: 1px solid #717171;
            border-radius: 10px;
            padding: 0px 16px;
            -moz-appearance: none; /* Firefox에서 기본 스타일 제거 */
            -webkit-appearance: none; /* Safari와 Chrome에서 기본 스타일 제거 */
            appearance: none; /* 최신 브라우저에서 기본 스타일 제거 */
            /* 얇고 아래로 향하는 크고 얇은 화살표 아이콘을 배경 이미지로 추가하고, 위치를 오른쪽에서 20px, 중앙으로 설정 */
            background: url('data:image/svg+xml;charset=US-ASCII,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 12 8"><path fill="none" stroke="%231d1d1d" stroke-width="1" d="M2,2 L6,6 L10,2"/></svg>') no-repeat right 20px center;
            background-size: 14px; /* 화살표 크기 조절 */
        }

        .search-option::-ms-expand {
            display: none; /* Internet Explorer에서 기본 드롭다운 화살표 제거 */
        }



        .search-container {
            position: relative;
            width: 360px;
            height: 56px;
            border-radius: 10px;
            border: 1px solid #717171;
        }
        .search-bar {
            width: 100%;
            height: 100%;
            border: none;
            border-radius: 10px;
            padding: 0 40px 0 10px; /* Adjust padding for the icon */
            font-size: 19px;
            box-sizing: border-box;
        }
        .search-bar:focus {
            outline: none;
        }
        .search-button {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
        }
        .fa-magnifying-glass {
            font-size: 1.5em;
            color: #2D2D2D;
        }
        .flex-grow {
            flex-grow: 1;
        }
        .title-post {
            color: #1d1d1d;
            text-align: left;
            font-family: "Inter-Bold", sans-serif;
            font-size: 20px;
            line-height: 1.2em;
            font-weight: 700;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: flex-start;
            cursor: pointer;
            margin: 0;
        }
        .info-post {
            color: #8c8c8c;
            text-align: left;
            font-family: "Inter-Regular", sans-serif;
            font-size: 14px;
            line-height: 1.2em;
            font-weight: 400;
            position: relative;
            margin: 0;
        }
        .content-post {
            color: #1d1d1d;
            text-align: left;
            font-family: "Inter-Regular", sans-serif;
            font-size: 14px;
            line-height: 1.2em;
            font-weight: 400;
            position: relative;
            margin: 0;
        }
        .green {
            color: #588159;
            height: 2px;
            background-color: #588159;
            margin: 10px 0;
        }
        .heart-icon {
            cursor: pointer;
            font-size: 1.5em;
            color: #8c8c8c;
        }
        .heart-icon.liked {
            color: black;
        }
        .like-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 2px;
            margin: 0;
        }
        .post-container {
            display: flex;
            flex-direction: column;
            gap: 5px; /* 간격을 줄이기 위해 수정 */
            margin: 10px 0; /* 전체 포스트 간의 간격을 줄이기 위해 추가 */
        }
        .post-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 0;
        }
        .load-more-button {
            display: block;
            width: 210px;
            height: 56px;
            margin: 20px auto;
            background-color: #fff; /* 마우스를 올렸을 때 배경색을 흰색으로 설정합니다. */
            color: #588159; /* 마우스를 올렸을 때 글자색을 #588159로 설정합니다. */
            text-align: center;
            line-height: 40px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            border: 1px solid #588159;
        }
        .load-more-button:hover {
            color: #fff; /* 기본 글자색을 흰색으로 설정합니다. */
            background-color: #588159; /* 기본 배경색을 #588159로 설정합니다. */
        }
    </style>
    <script>
        function toggleLike(element) {
            element.classList.toggle('liked');
            if (element.classList.contains('liked')) {
                element.className = 'fa-solid fa-heart heart-icon liked';
            } else {
                element.className = 'fa-regular fa-heart heart-icon';
            }
        }

        function searchPosts() {
            var searchQuery = document.getElementById("searchInput").value;
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "searchResults.jsp?query=" + searchQuery, true);
            xhr.onload = function() {
                if (xhr.status === 200) {
                    document.querySelector('.post-container').innerHTML = xhr.responseText;
                } else {
                    alert("검색 결과를 가져오는데 실패했습니다.");
                }
            };
            xhr.send();
        }

        function loadMore() {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "loadMorePosts.jsp", true);
            xhr.onload = function() {
                if (xhr.status === 200) {
                    document.querySelector('.post-container').insertAdjacentHTML('beforeend', xhr.responseText);
                } else {
                    alert("더 많은 글을 불러오는데 실패했습니다.");
                }
            };
            xhr.send();
        }

        document.addEventListener("DOMContentLoaded", function() {
            var searchInput = document.getElementById("searchInput");
            searchInput.addEventListener("keypress", function(event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    searchPosts();
                }
            });
        });
    </script>
</head>
<body>
<h1>공부자료</h1>

<form method="GET" action="${root}/StudyReferences/StudyReferencesList" id="StudyReferencesList">
    <!-- 전체글(n) 검색창 -->
    <div class="container">
        <p class="total-post">전체글(${totalPost})</p>
        <div class="flex-grow"></div>
        <select class="search-option" name="searchOption">
            <option value="all-post">전체</option>
            <option value="title-post">제목</option>
            <option value="writer-post">작성자</option>
        </select>
        <div class="search-container">
            <input type="text" id="searchInput" class="search-bar" placeholder=" 검색어를 입력해주세요">
            <button type="button" class="search-button" onclick="searchPosts()">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>
        </div>
    </div>

    <!-- 글 목록 -->
    <div class="post-container">
        <c:forEach var="post" items="${StudyReferences}">
            <div class="post-header">
                <p class="title-post" onclick="location.href='StudyReferencesDetail.jsp?referenceIdx=${post.referenceIdx}'">${post.referenceIdx}. ${post.title}</p>
                <div class="like-container">
                    <i class="fa-regular fa-heart heart-icon" onclick="toggleLike(this)"></i>
                    <p class="info-post">좋아요 ${post.likesCount}</p>
                </div>
            </div>
            <p class="info-post">작성자: ${post.userIdx}  |   작성일: ${post.createdAt}  |  조회수: ${post.viewsCount}</p>
            <p class="content-post">${post.content}</p>
            <hr class="green">
        </c:forEach>
    </div>

    <button type="button" class="load-more-button" onclick="loadMore()">목록 더보기</button>
</form>
</body>
</html>
