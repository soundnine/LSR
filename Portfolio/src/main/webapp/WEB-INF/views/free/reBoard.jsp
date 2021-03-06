<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tasty Food Community - 자유게시판</title>
<link href="/resources/bootstrap-3.3.2/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css"
	rel="stylesheet">
<link href="/resources/css/re-board.css" rel="stylesheet">
</head>
<body>

	<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<%@ include file="/WEB-INF/views/include/leftSide.jsp" %>
			<!-- 우측 면 -------------------------------------- -->
			<div class="col-xs-12 col-sm-8">
				<div class="wrapper">
					<i class="fas fa-cloud"></i>
					<h4>답글 달기</h4>
				</div>
				<form action="/free/reBoard" method="post" enctype="multipart/form-data">
					<div class="title"> <!-- [RE:] 형식으로 원글에서 제목 뽑아서 붙이기 -->
						<i class="fas fa-heading"></i><span>&nbsp;Title</span>
						<div>
							<input class="form-control" type="text" name="title" value="[RE]: <c:out value='${title }'/>" readonly="readonly">
						</div>
					</div>
					<div class="writer">
						<i class="fas fa-user"></i><span>&nbsp;Writer</span>
						<div>
							<input class="form-control" type="text" name="writer" value="${sessionScope.login.userId }" readonly="readonly">
						</div>
					</div>
					<div class="date">
						<i class="fas fa-calendar-alt"></i><span>&nbsp;Date</span>
						<div>
							<fmt:formatDate value="${today }" pattern="yyyy-MM-dd" var="date"/>
							<input class="form-control" type="text" name="updateDate" value="${date }" readonly="readonly">
						</div>
					</div>
					<div class="content">
						<i class="fas fa-book-open"></i><span>&nbsp;Content</span>
						<textarea class="form-control" cols="90" rows="20" name="content" required></textarea>
					</div>
					<div class="attach">
					<label>
						<i class="fas fa-paperclip"></i>
						<i class="fas fa-plus"></i>
						<i class="fas fa-minus"></i>
					</label>
						 <input class="file-attach form-control" type="file" name="files">
					</div>
					<input type="hidden" name="parentIdx" value="<c:out value='${idx }'/>">
					<div class="button-wrapper">
						<input  type="checkbox" class="pull-left" name="locking"><span class="pull-left">글 잠금</span>					
						<button type="submit" class="btn btn-primary">글쓰기</button>
						<button type="button" class="btn btn-default">목록</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
<script src="/resources/js/jquery-1.12.4.js" type="text/javascript"></script>
<script src="/resources/bootstrap-3.3.2/js/bootstrap.min.js"
	type="text/javascript"></script>
<script>
	$(document).ready(function(){
		//반응형 즉시실행함수 hr밑 info 삭제
		(function(){
			var hideInfo = $('.info-wrapper');
			var hideSubscription = $('.subscription');
			var hidePopularBoard = $('.popular-board');
			if (window.matchMedia("(max-width: 768px)").matches) {
				  hideInfo.hide();
				  hideSubscription.hide();
				  hidePopularBoard.hide();
				} else{
					hideInfo.show();
					hideSubscription.show();
					hidePopularBoard.show();
				}
		})();
		
		//반응형 hr밑 info 삭제
		$(window).resize(function(){
			var hideInfo = $('.info-wrapper');
			var hideSubscription = $('.subscription');
			var hidePopularBoard = $('.popular-board');
			
			if (window.matchMedia("(max-width: 768px)").matches) {
				  hideInfo.hide();
				  hideSubscription.hide();
				  hidePopularBoard.hide();
				} else{
					hideInfo.show();
					hideSubscription.show();
					hidePopularBoard.show();
				}
		});	
		
		//아이콘 눌러서 수정 전 페이지
		$('.fa-cog').on('click',function(e){
			location.replace('/preUserInfo');
		});
		
		//글 잠금 설정 시 패스워드 입력칸 삽입
		$('input[type=checkbox]').on("click",function(){
			if($(this).is(':checked')){
				$(this).val('1');
				$('input[type=checkbox]+span').
				after('<input style="margin:0 4px;" type="text" class="pull-left" name="lockingPassword" maxlength="10" required/>');
			} else{
				$('input[name=lockingPassword]').remove();
			}
		})
		
		//공백제한 input 위임
		$('.button-wrapper').on('keydown','input[name=lockingPassword]',function(e){
			var key = e.keyCode;
			if(key==32){
				e.preventDefault();
				alert("공백은 제한됩니다.");
			}
		});
		
		//목록 버튼 클릭 핸들러
		$('.button-wrapper button[type=button]').on('click',function(){
			var page = '<c:out value="${page}"/>';
			var type = '<c:out value="${type}"/>';
			var keyword = '<c:out value="${keyword}"/>';
			location.href='/free/freeBoardList?page='+page+'&type='+type+'&keyword='+keyword+'';
		});
		
		//글쓰기 버튼 클릭 이벤트 핸들러, 비밀번호 입력 강제시키기, 제목 내용 trim null 체크
		$('.button-wrapper button[type=submit]').on('click',function(e){
			e.preventDefault();
			var title = $('input[name=title]');
			var content = $('textarea[name=content]');
			var lockingPassword = $('input[name=lockingPassword]');
			
			if(!$.trim(content.val())){
				alert("내용을 입력해주세요");
				return;
			}
			
			if($('input[type=checkbox]').is(':checked')){
				if(!lockingPassword.val()){
					alert("비밀번호를 입력해주세요.");
					return;
				}
			}
			
			//유니코드 10진수
			// 숫자(0~9) : 48~57, 영문대문자(A-Z) : 65~90, 영문소문자(a-z) : 97~122, 한글(가~힣) : 44032~55203, 한글자음 : 12593~12622, 한글모음 : 12623~12643
			// 특수문자(공백과 줄바꿈없는 공백 추가) /*-+.\|/?.>,<=-_)(*&^%$#@!~` -> 33, 35, 36, 37, 38, 40, 41, 42, 42, 43, 44, 45, 45, 46, 46, 47, 47, 60, 61, 62, 63, 64, 92, 94, 95, 96, 124, 126
		    // 영문 숫자 기호는 1바이트 한글은 3바이트	
			var special = [32, 33, 35, 36, 37, 38, 40, 41, 42, 42, 43, 44, 45, 45, 46, 46, 47, 47, 60, 61, 62, 63, 64, 92, 94, 95, 96, 124, 126,160];
			var chk = 0;
			
			 for(i=0; i<content.val().length; i++){
				var target = content.val().charCodeAt(i);
				
				if(special.includes(target)){ //특문, 공백, 줄바꿈 없는 공백 1바이트 추가
					chk = chk + 1;
				} else if((47<target&&target<58)||(64<target&&target<91)||(96<target&&target<123)){//숫자 영문대 영문소
					chk = chk + 1;
				} else if((44031<target&&target<55204)||(12592<target&&target<12644)){//한글
					chk = chk + 3;
				} else {  //한자 일본어 고려
					chk = chk + 3; 
				}
			} 
			if(chk>3500){
				alert("최대 글자 수를 넘었습니다.");
				return;
			}
			
			$('form[action="/free/reBoard"]').submit();
		});
		
		//input 3개까지 추가하는 클릭 이벤트 핸들러
		$('.fa-plus').on('click',function(){
			
			var inputCounts = $('.file-attach').length;
			console.log(inputCounts);
			
			if(inputCounts>2){
				alert("더 이상 첨부할 수 없습니다.");
				return;
			}
			
			var inputs = '<input class="file-attach form-control" type="file" name="files">'
				$('.attach').append(inputs);
		});
		//input 항목 삭제
		$('.fa-minus').on('click',function(){
			var inputCounts = $('.file-attach').length;
			
			if(inputCounts==0){
				alert("더 이상 지울 수 없습니다.");
				return;
			}
			
			$('.attach input:last-child').remove();
		});
		
	 });
</script>
</html>