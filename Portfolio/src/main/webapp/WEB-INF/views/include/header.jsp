<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <!--  네비 -------------------------------------- -->
	<div class="container">
		<div class="row top">
				<div class="col-xs-12 col-sm-3 image-wrapper">
					<a href="/main"><img class="small-logo"
						src="/resources/image/logo-sm.png" /></a> <i class="fas fa-bell"></i>
						<div id="socket-content" style="display:none; margin-left:6px;"></div>
				</div>
				<div class="col-xs-12 col-sm-9 link-wrapper">
					<!--  문의토글 -------------------------------------- -->
					<div class="dropdown links">
						<a href="/free/freeBoardList">자유게시판</a>
						<a href="/channel/channelList">채널</a>
						<a class="dropdown-toggle" type="button" data-toggle="dropdown">문의
							<span class="caret"></span>
						</a>
						<ul class="dropdown-menu dropdown-menu-right">
							<li><a class="inquiry-link" data-toggle="modal"
								href="#inquiryModal">문의하기</a></li>
							<li>관리자</li>
						</ul>
					</div>
					<!--  문의토글 -------------------------------------- -->
				</div>
		</div>
	</div>
	<!-- 모달 ----------------------------------------------------------------->
				<div class="modal fade" id="inquiryModal" tabindex="-1"
					role="dialog" aria-labelledby="inquiryModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h3 class="modal-title" id="inquiryModalLabel">문의</h3>
							</div>
							<div class="modal-body">
								<form>
									<div class="form-group">
										<label for="inquiry" class="control-label">종류:</label>
										<select class="form-control" id="inquiry" name="inquiry" >
											<option value="report">신고</option>
											<option value="question">질문</option>
											<option value="inquiryetc">기타</option>
										</select>
									</div>
									
									<div class="form-group">
										<label for="inquirytitle" class="control-label">제목:</label>
										<input type="text" class="form-control" id="inquirytitle" name="inquirytitle" required maxlength="30"/>
									</div>
									
									<div class="form-group">
										<label for="inquirycontent" class="control-label">내용:</label>
										<textarea class="form-control" id="inquirycontent" name="inquirycontent" cols="50" rows="5" required></textarea>
									</div>
								</form>
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-primary">문의하기</button>
								<button type="button" class="btn btn-default"
									data-dismiss="modal">취소</button>
							</div>
						</div>
					</div>
				</div>
<script src="/resources/js/jquery-1.12.4.js" type="text/javascript"></script>
<script>
 var socket = new WebSocket('ws://localhost:8080/socketUrl');
 
 socket.onopen = function(e){
	console.log('소켓 오픈');
 };
 
 socket.onmessage = function(e){
 	console.log(e.data);
 	$('.fa-bell').css('color','red');
 	$('#socket-content').html(e.data);
 	$('#socket-content').css('display','inline-block');
 };
 
 socket.onclose = function(e){
	 console.log('소켓 클로즈');
 };
 
 socket.onerror = function(e){
	 console.log('소켓 에러');
 };
</script>				