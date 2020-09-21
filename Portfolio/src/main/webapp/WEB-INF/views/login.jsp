<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tasty Food Community - 로그인</title>
<link href="/resources/bootstrap-3.3.2/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css"
	rel="stylesheet">
<link href="/resources/css/login.css" rel="stylesheet">
</head>

<body>
	<div class="container">
		<div class="row">
			<div class="wrapper col-xs-12">
				<div id="signup-form">
					<img src="/resources/image/logo.png" class="logo-image img-responsive">
					<form class="form-group" action="/loginPost" method="post">
						<div id="login-input-wrapper">
							<label class="username-label control-label">아이디</label>
							<input type="text" class="form-control" name="userId"/>
							<label class="pw-label control-label">비밀번호</label>
							<input type="password" class="form-control" name="password" autocomplete="off"/>
						</div>
						<!-- <div class="checkbox">
							<label>
								<input type="checkbox" value=""/> Remember me
							</label>
						</div> -->
						<div id="login-button-wrapper">
							<button type="submit" class="btn btn-primary">로그인</button>
							<div class="pull-right">
								<i class="fas fa-grin"></i><a id="register-link" href="/register">회원가입</a>
								<!-- <i class="fas fa-grin"></i><a id="info" data-toggle="modal" href="#infoModal">아이디 찾기</a> -->
							</div>
						</div>
					</form>
				</div>
				<!-- 회원정보 모달 ----------------------------------------------------------------->
			<!-- 	<div class="modal fade" id="infoModal" tabindex="-1"
					role="dialog" aria-labelledby="infoModalLabel" aria-hidden=true; data-backdrop="static" data-keyboard="false">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h3 class="modal-title" id="infoModalLabel">아이디 찾기</h3>
							</div>
							<div id="info-modal" class="modal-body">
								<form class="form-group" action="" method="">
									<div>
										<label class="control-label">이름</label>
										<input type="text" class="form-control" name="userName" required maxlength="6"/>
									</div>
									
									<div>
										<label class="control-label">생년월일</label>
										<input type="text" class="form-control" name="birthday" required value="YYYYMMDD" maxlength="8"/>
									</div>
								</form>
							</div>
							<div id="info-button" class="modal-footer">
								<button type="submit" class="btn btn-primary">찾기</button>
								<button type="button" class="btn btn-default"
									data-dismiss="modal">취소</button>
							</div>
						</div>
					</div>
				</div> -->
				<!-- 모달 ----------------------------------------------------------------->
			</div>
		</div>
	</div>
</body>
<script src="/resources/js/jquery-1.12.4.js" type="text/javascript"></script>
<script src="/resources/bootstrap-3.3.2/js/bootstrap.min.js" type="text/javascript"></script>
<script>
$(document).ready(function(){
	//모달 닫힘 방지 - 자동 load 오류
	/* $('#registerModal').modal({
		backdrop:'static',
		keyboard:false
	}); */
	//공백제한
	$('#info-wrapper input').on('keydown',function(e){
		var key = e.keyCode;
		if(key==32){
			e.preventDefault();
			alert("공백은 제한됩니다.");
		}
	});
	
	
	//공백제한
	$('#info-modal input').on('keydown',function(e){
		var key = e.keyCode;
		if(key==32){
			e.preventDefault();
			alert("공백은 제한됩니다.");
		}
	});
	
	//회원정보 양식 체크
	$('#info-button button[type=submit]').on('click',function(e){
		e.preventDefault();
		var userName = $('#info-modal input[name=userName]').val();
		var birthday = $('#info-modal input[name=birthday]').val();
		//이름 정규식 한글 2~6
		var userNameRegExp = /^[가-힣]{2,6}$/;
		//생년월일 정규식 YYYYMMDD
		var birthRegExp = /^(19[0-9][0-9]|20\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$/;
		
		if(!userNameRegExp.test(userName)){
			alert('이름 형식이 맞지 않습니다.');
			return;
		} 
		
		if(!birthRegExp.test(birthday)){
			alert('생년월일 형식이 맞지 않습니다.');
			return;
		} 
		
		$('#info-modal form').submit();
	}); 
	
	//로그인 클릭시 null 제한
	$('#login-button-wrapper button').on('click', function(e){
		e.preventDefault();
		var idChk = $('input[name=userId]').val();
		var pwChk = $('input[name=password]').val();
		//아이디 정규식 영문 숫자 4~10자
		var userIdRegExp = /^[a-zA-Z0-9]{4,10}$/;
		//비밀번호 정규식 6~12자 영문,숫자
		var pwRegExp = /^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{6,12}$/;
		
		
		if(!idChk){
			alert('아이디를 입력해주세요.');
			
		} else if(!userIdRegExp.test(idChk)){
			alert('아이디는 영문 또는 숫자 4~10자 입니다.');
			return;
			
		} else if (!pwChk){
			alert('패스워드를 입력해주세요.');
			
		} else if(!pwRegExp.test(pwChk)){
			alert('비밀번호는 영문,숫자 혼용 6~12자 입니다.');
			return;
		}
		$('#signup-form form').submit();
	});
	
});
</script>
</html>