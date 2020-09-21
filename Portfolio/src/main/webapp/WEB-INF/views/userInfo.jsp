<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tasty Food Community - 메인 메뉴</title>
<link href="/resources/bootstrap-3.3.2/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css"
	rel="stylesheet">
<link href="/resources/css/user-info.css" rel="stylesheet">
</head>
<body>

	<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<%@ include file="/WEB-INF/views/include/leftSide.jsp" %>
	<!-- 우측 면 -------------------------------------- -->
			<div class="col-xs-12 col-sm-8">
				<div class="checking">
					<form class="form-group" action="/userInfoAfter" method="post">
						<div class="control-group">
							<label class="control-label">새 비밀번호 입력: </label>
							<div>
								<input class="pw form-control" type="password" name="password" maxlength="12"/>
							</div>
							
							<label class="control-label">새 비밀번호 확인: </label>
							<div>
								<input class="pw-check form-control" type="password" maxlength="12"/>
							</div>
							
							<label class="control-label">이메일 수정: </label>
							<div>
								<input class="email form-control" name="email" type="text" value="<c:out value="${userInfo.email }"/>" required/>
							</div>
							<div>
								<button class="btn btn-warning" type="submit">회원정보 수정</button>
							</div>
						</div>
					</form>
					
				</div>
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
			location.href='pre-user-info.html';
		});
		
	    //입력값 공백 못넣게 하기
		$('.checking input').on('keydown',function(e){
			var key = e.keyCode;
			if(key==32){
				e.preventDefault();
				alert("공백은 제한됩니다.");
			}
		});
	    
		//이메일 정규식
		var emailRegExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		var pwRegExp = /^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{6,12}$/;
		
		//비밀번호 체크
		$('.checking button').on('click',function(e){
			e.preventDefault();
			var pw = $('.pw').val();
			var pwCheck = $('.pw-check').val(); 
		
			if(pw||pwCheck){
				if(pw!==pwCheck){
					alert('비밀번호가 서로 같지 않습니다.');
					return;
				}
				if(!pwRegExp.test(pw)||!pwRegExp.test(pwCheck)){
					alert('비밀번호는 영문,숫자 혼용 6~12자 입니다.');
					return;
				}
			} 
			//이메일만 수정할 때(비밀번호 칸 둘다 공백)
			else if(!pw&&!pwCheck){
				alert('이메일이 수정되었습니다.');
			}
		    //이메일은 NotNull. 기본 화면에 값 뿌리기.
			if(!emailRegExp.test($('.email').val())){
				alert('이메일 형식이 맞지 않습니다.');
				return;
			} //getMapping 컨트롤러에서 기본 이메일 주소 가져와서 value값에 뿌리기.
			
			alert('회원정보가 변경되었습니다.');
			 $('form').submit(); 
		});
	
	});
</script>
</html>