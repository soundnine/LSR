<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<link href="/resources/css/pre-user-info.css" rel="stylesheet">
</head>
<body>

	<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<%@ include file="/WEB-INF/views/include/leftSide.jsp" %>
	<!-- 우측 면 -------------------------------------- -->
			<div class="col-xs-12 col-sm-8">
				<div class="pre-checking">
					<form class="form-inline" action="/userInfo" method="post">
						<div class="form-group">
							<label class="control-label">비밀번호를 입력해주세요: </label>
							<input type="hidden" name="userId" value="${sessionScope.login.userId }"/>
							<input class="form-control" name="password" type="password" required>
							<button class="btn btn-warning pull-right" type="submit">확인</button>
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
		
		//공백 제한
		$('.pre-checking input').on('keydown',function(e){
			var key = e.keyCode;
			if(key==32){
				e.preventDefault();
				alert("공백은 제한됩니다.");
			}
		});
		
		
		
	});
</script>
</html>