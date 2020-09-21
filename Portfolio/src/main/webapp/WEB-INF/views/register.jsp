<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tasty Food Community - 로그인</title>
<link href="/resources/bootstrap-3.3.2/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css"
	rel="stylesheet">
<link href="/resources/css/register.css" rel="stylesheet">
</head>

<body>
	<div class="container">
		<div class="row">
			<div class="wrapper col-xs-12">
				<div id="register-form">
					<form action="/register" method="post">
						<div class="form-group">
							<label class="control-label">아이디 - 4~10자 사이로
								입력해주세요(영문,숫자)</label> 
								<input type="text" class="form-control"
								name="userId" required maxlength="10" />
						</div>

						<div class="form-group">
							<label class="control-label">비밀번호 - 6~12자 사이로
								입력해주세요(영문,숫자 혼용)</label> 
								<input type="password" class="form-control"
								name="password" required maxlength="12" />
						</div>

						<div class="form-group">
							<label class="control-label">비밀번호 확인</label> 
							<input
								type="password" class="form-control" id="password-check"
								required maxlength="12" />
						</div>

						<div class="form-group">
							<label class="control-label">이름</label> 
							<input type="text"
								class="form-control" name="userName" required maxlength="6" />
						</div>
						<div class="form-group form-group-xs">
							<label for="gender" class="control-label">성별</label><br> 
							<span>남</span>
							<input
								type="radio" name="gender" value="1" required>
							<!-- 이름 같으면 require 하나만 해도 o -->
							<span>여</span>
							<input type="radio" name="gender" value="2">
						</div>
						<div class="form-group">
							<label class="control-label">생년월일</label> 
							<input type="text"
								class="form-control" name="birthday" required value="YYYYMMDD"
								maxlength="8" />
						</div>

						<div class="form-group">
							<label class="control-label">이메일</label> 
							<input type="text"
								class="form-control" name="email" required maxlength="27" />
						</div>
						<div id="under-button">
							<button type="submit" class="btn btn-primary">가입하기</button>
							<button type="button" class="btn btn-default">취소</button>
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
	//모달 닫힘 방지 - 자동 load 오류
	/* $('#registerModal').modal({
		backdrop:'static',
		keyboard:false
	}); */
	
	//공백 제한
	$('#register-form input').on('keydown',function(e){
		var key = e.keyCode;
		if(key==32){
			e.preventDefault();
			alert("공백은 제한됩니다.");
		}
	});
	
	//양식 체크
	$('button[type=submit]').on('click',function(e){
		e.preventDefault();
		var userId = $('#register-form input[name=userId]').val();
		var password = $('#register-form input[name=password]').val();
		var passwordChk = $('#register-form input[id=password-check]').val();
		var userName = $('#register-form input[name=userName]').val();
		var gender = $('#register-form input[name=gender]:checked');
		var birthday = $('#register-form input[name=birthday]').val();
		var email = $('#register-form input[name=email]').val();
		//아이디 정규식 영문 숫자 4~10자
		var userIdRegExp = /^[a-zA-Z0-9]{4,10}$/;
		//비밀번호 정규식 6~12자 영문,숫자
		var pwRegExp = /^(?=.*\d)(?=.*[a-zA-Z])[0-9a-zA-Z]{6,12}$/;
		//이름 정규식 한글 2~6
		var userNameRegExp = /^[가-힣]{1,5}$/;
		//생년월일 정규식 YYYYMMDD
		var birthRegExp = /^(19[0-9][0-9]|20\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$/;
		//이메일 정규식
		var emailRegExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

		if(!userIdRegExp.test(userId)){
			alert('아이디 형식이 맞지 않습니다.');
			return;
		} 
		
		if(!password||!passwordChk){
			alert('비밀번호를 입력해주세요.');
			return;
			
		} else if(password!==passwordChk){
			alert('비밀번호가 서로 같지 않습니다.');
			return;
			
		} else if(!pwRegExp.test(password)||!pwRegExp.test(passwordChk)){
			alert('비밀번호는 영문,숫자 혼용 6~12자 입니다.');
			return;
		}
		
		if(!userNameRegExp.test(userName)){
			alert('이름 형식이 맞지 않습니다.');
			return;
		} 
		
		if(gender.length===0){
			alert('성별을 선택해주세요.');
			return;
		}
		
		if(!birthRegExp.test(birthday)){
			alert('생년월일 형식이 맞지 않습니다.');
			return;
		} 
		
		if(!emailRegExp.test(email)){
			alert('이메일 형식이 맞지 않습니다.');
			return;
		} 
		
		 $('form').submit(); 
	});
		//취소 버튼 로그인 화면 이동
		$('button[type=button]').on('click',function(){
			location.href = '/login';
		});
	
});
</script>
</html>