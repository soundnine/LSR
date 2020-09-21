<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 좌측 사이드 -------------------------------------- -->
	<div class="container">
		<div class="row">
			<div class="col-xs-12 col-sm-4">
				<div class="panel panel-primary">
					<div class="panel-heading">
						My Page 
						<a href="/preUserInfo">
						<i style="color:black;"class="fas fa-user-cog pull-right"></i>
						</a>
					</div>
					<div class="panel-body">
						<div>
							<img id="user-img" style="width:60px; height:60px; border-radius:50%;"
							src="" data-toggle="modal" data-target="#profile-image">
							<span style="font-size:20px;">${sessionScope.login.userName }</span>
						</div>
						<!-- <i class="fas fa-envelope"></i><a>&nbsp;쪽지함</a> -->
						<a href="/logout"><i class="fas fa-sign-out-alt pull-right"></i></a>
					</div>
				</div>
				<!---------------------- 프로필 이미지 인풋 모달 -->
			    <div class="modal fade" id="profile-image" role="dialog" aria-labelledby="profileModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" tabindex="-1">
			            <div class="modal-dialog">
			                <div class="modal-content">
			                    <div class="modal-header">
			                        <h4 class="modal-title"><i style="color:black;" class="fas fa-image"></i>&nbsp;프로필 이미지 등록</h4>
			                    </div>
			                    <div class="modal-body">
			                       <label>이미지 파일을 선택해주세요.</label>
			                       <input id="image-input" class="form-control" type="file" accept=".jpg, .jpeg, .png .bmp">
			                    </div>
			                    <div class="modal-footer">
			                    	<button id="profile-submit" type="button" class="btn btn-primary">등록하기</button>		
			                        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			                    </div>
			                </div>
			            </div>
			        </div>
 				 <!---------------------- 모달 끝 -->
				
				<!-- 구독 채널 -------------------------------------- -->
				<div class="subscription panel panel-primary">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="fas fa-cloud"></i>구독
						</h3>
					</div>
					<ul class="list-group">
						<li class="list-group-item"><i class="fas fa-ban"></i>구독중인
							채널이 없습니다.</li>
					</ul>
				</div>
				<!-- 인기 게시글 -------------------------------------- -->
				<div class="popular-board panel panel-primary">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="fas fa-cloud"></i>인기 게시글
						</h3>
					</div>
					<ul class="list-group">
						<li class="list-group-item"><i class="fas fa-ban"></i>삽입 예정</li>
					</ul>
				</div>
				<!-- 구분선 -------------------------------------- -->
				<hr>
				<!-- About -------------------------------------- -->
				<div class="info-wrapper">
					<ul class="info">
						<li>About Us</li>
						<li>Terms And Conditions</li>
						<li>Privacy</li>
						<li>Business</li>
						<li>TEL.02-000-000 서울시 도봉구</li>
					</ul>
				</div>
			</div>
<script src="/resources/js/jquery-1.12.4.js" type="text/javascript"></script>			
<script>
	
	//왼쪽 인기 게시글 작은창 로드(좋아요 DESC)
	var leftPopularBoards = function(){
		$.ajax({
			type:'get'
		   ,url:'/getPopularBoards'
		   ,dataType:'json'
		   ,success:function(result,xhr,status){
			   if(result !== null && result.length !== 0){
				   var list = '';
				   for(i=0;i<result.length;i++){
					   list = list + '<li class="list-group-item"><i style="margin-right:4px;" class="fas fa-kiss-wink-heart"></i><a href="/free/getFreeBoard?idx='+
							         result[i].idx+'&page=1&type=T&keyword=">'+result[i].title+'</a></li>';
				   }
				   $('.popular-board ul').html(list);
			   }
		   }
		   ,error:function(error,xhr,status){
			   alert('인기 게시판 로드 오류입니다.');
		   }
		});
	}
	leftPopularBoards();
	
	//구독 작은창 로드
	var followList = function(){
		var accessId = '${sessionScope.login.userId}';
		$.ajax({
			type:'get'
		   ,url:'/channel/getList/'+accessId
		   ,dataType:'json'
		   ,success:function(result,xhr,status){
			   console.log(result);
			   if(result.followList !== null && result.followList.length !== 0){
				   var list = '';
				   
				   for(i=0;i<result.followList.length;i++){
					   list = list + '<li class="list-group-item"><i style="margin-right:4px;" class="fas fa-apple-alt"></i><a href="/channel/getChannel?channelName='+
							         result.followList[i]+'">'+result.followList[i]+'</a></li>';
				   }
				   $('.subscription ul').html(list);
			   }
		   }
		   ,error:function(error,xhr,status){
			   alert('구독 로드 오류입니다.');
		   }
		});
	}
	followList();

    //프로필 이미지 불러오기
	var loadImage = function(){
		var uuid = '${sessionScope.login.attachVO.uuid}';
		var uploadPath = decodeURIComponent('${sessionScope.login.attachVO.uploadPath}');
		var fileName = '${sessionScope.login.attachVO.fileName}';
		
		console.log(uploadPath.length); //썸네일로 변경
		var pathName = encodeURIComponent(uploadPath+'\\'+uuid+'_thumb_'+fileName);
		
		if(!uuid){
			var image = '/resources/image/no-thumbnail-user.png';
		}
		else{
			var image = '/showImage?pathName='+pathName;
		}
		$('#user-img').attr('src',image);
	}
	loadImage();
	
	//프로필 이미지 업로드 하기
	$('#profile-submit').on('click',function(){
		var name = '${sessionScope.login.userId}';
		var nameType = 'users';
		var userFile = $('input[type=file]');
		
		if(userFile.val().length === 0){
			alert("파일을 첨부해주세요.");
			return;
		}
		
		var formData = new FormData();
		var uploadData = userFile[0].files;
		
		for(var i = 0; i<uploadData.length;i++){
			formData.append('profileImage',uploadData[i]);
		}
		
		$.ajax({
			url:'/uploadImage/'+nameType+'/'+ name
		   ,type:'POST'
		   ,data:formData
		   ,processData:false
		   ,contentType:false
		   ,success:function(result,xhr,status){
			   alert("프로필 등록에 성공했습니다.");
			   $('#profile-image').hide();
			  location.reload();
		//ajax 대신 세션으로 사용해서 리로드. 뒤로가기 고민하기.
		   }
		   ,error:function(error,xhr,status){
			   alert("파일 업로드에 실패했습니다.");
		   }
		});
		
	});
	
	
		
	
</script>