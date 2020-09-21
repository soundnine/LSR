<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tasty Food Community - 내 채널</title>
<link href="/resources/bootstrap-3.3.2/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css"
	rel="stylesheet">
<link href="/resources/css/my-channel.css" rel="stylesheet">
</head>
<body>

	<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<!-- 아랫면 내용 ------------------------------------- -->
	<div class="container">
		<div class="row main">
			<div class="col-xs-12">
				<!-- Profile -------------------------------------- -->
				<div class="profile">
					<div class="image-box" data-toggle="modal" data-target="#back-image"></div>
					<div class="profile-bottom">
						<div class="pseudo-profile-bottom">
							<div class="profile-thumbnail">
								<img id="user-img" src="">
							</div>
							<div class="profile-name">
								<span><c:out value='${sessionScope.login.channelVO.channelName }'/></span>
							</div>
						</div>
					</div>
				</div>
				<!-- 새글 쓰기 -------------------------------------- -->
				<div class="new-board">
					<div class="new-board-writer">
						<img src="">
						<span><c:out value='${sessionScope.login.channelVO.channelName }'/></span>
					</div>
					<div class="new-board-content">
						<form action="/channel/registerFeed" method="post" enctype="multipart/form-data" class="form-group">
							<textarea class="form-control" rows="3" cols="70" name="content" maxlength="210" required></textarea>
							<input type="hidden" name=writer value="<c:out value='${sessionScope.login.channelVO.channelOwner }'/>">
							<input style="display:none;"type="file" name=files accept=".jpg, .jpeg, .png .bmp">
						</form>
					</div>
					<div class="new-board-attach">
						<button type="button" class="btn btn-sm btn-primary pull-left">이미지 첨부</button>
						<button type="submit" class="btn btn-sm btn-primary pull-right">글쓰기</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 게시글 -------------------------------------- -->
	  <c:set var="map" value="${feedsMap }"/> 
		  <c:forEach items="${map['feeds']}" var="feed"> 
			<div class="ch-board">
			
				<div class="ch-board-writer">
					<img class="writer-image" src=""><span><c:out value='${sessionScope.login.channelVO.channelName }'/></span>
					<i style="color: black;" class="fas fa-cog pull-right"></i>
				</div>
				
				  <c:if test="${not empty map['attaches']}">
					<c:forEach items="${map['attaches'] }" var="attach">
					  <c:if test="${attach.feedIdx eq feed.idx }">  
					  	<c:url value="/showImage" var="url">
				 			<c:param name="pathName" value="${attach.uploadPath }\\${attach.uuid }_${attach.fileName }"/>
				 		</c:url>		
							<div>
								<img style="width:100px; height:100px;"src="${url }"/>
							</div>
					   </c:if>
				   </c:forEach>
				 </c:if> 
				 
				<div class="ch-board-content">
					<span><c:out value="${feed.content }"></c:out></span>
				</div>
				
				<div class="ch-board-reply">
					<i class="fas fa-comment-dots"></i>
				</div>
			</div>
		 </c:forEach> 
		<!--------------------- 배경 이미지 인풋 모달 -->
			    <div class="modal fade" id="back-image" role="dialog" aria-labelledby="backModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" tabindex="-1">
			            <div class="modal-dialog">
			                <div class="modal-content">
			                    <div class="modal-header">
			                        <h4 class="modal-title"><i style="color:black;" class="fas fa-image"></i>&nbsp;배경 이미지 등록</h4>
			                    </div>
			                    <div class="modal-body">
			                       <label>이미지 파일을 선택해주세요.</label>
			                       <input id="image-input" class="form-control" type="file" accept=".jpg, .jpeg, .png .bmp">
			                    </div>
			                    <div class="modal-footer">
			                    	<button id="back-submit" type="button" class="btn btn-primary">등록하기</button>		
			                        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
			                    </div>
			                </div>
			            </div>
			        </div>
		<!---------------------- 모달 끝 -->
		<!-- footer ----------------------------------------------------------------->		
		<div class="row footer">
			<div class="col-xs-12">
				<!-- 구분선 -------------------------------------- -->
				<hr>
				<!-- About -------------------------------------- -->
				<div>
					<ul class="info">
						<li><i class="fas fa-trademark"></i>Community -</li>
						<li>About Us /</li>
						<li>Terms And Conditions /</li>
						<li>Privacy /</li>
						<li>Business /</li>
						<li>TEL.02-000-000 서울시 도봉구</li>
					</ul>
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
		 //프로필 이미지 불러오기
		var loadImage = function(){
			var attachChk = '${sessionScope.login.attachVO}'
			var uuid = '${sessionScope.login.attachVO.uuid}';
			var uploadPath = decodeURIComponent('${sessionScope.login.attachVO.uploadPath}');
			var fileName = '${sessionScope.login.attachVO.fileName}';
			
			console.log(uploadPath.length); //썸네일로 변경
			var pathName = encodeURIComponent(uploadPath+'\\'+uuid+'_thumb_'+fileName);
			
			if(!attachChk){
				var image = '/resources/image/no-thumbnail-user.png';
			}
			else{
				var image = '/showImage?pathName='+pathName;
			}
			$('#user-img').attr('src',image);
			$('.new-board img').attr('src',image);
			$('.ch-board .writer-image').attr('src',image);
		}
		loadImage();
		
		//변수
		var name = '${sessionScope.login.channelVO.channelName}';
		var nameType = 'channel';
		
		//배경 이미지 로드받기
		var loadBackImage = function(){
			  $.ajax({
				   type:'get'
				  ,url:'/channel/getChannelImage/'+nameType+'/'+name
				  ,dataType:'json'
				  ,success:function(result,xhr,status){
					  console.log(result);
					  if(result.uuid === null){
						  $('.image-box').css({'background':'url(/resources/image/no-thumbnail-ch.jpg) no-repeat center center'
							                  ,'background-size':'cover'
						  					  });
					  } else{
						  var encoded = encodeURIComponent(result.uploadPath+'\\'+result.uuid+'_thumb_'+result.fileName);
						  $('.image-box').css({'background':'url(/showImage?pathName='+encoded+') no-repeat center center'
							                  ,'background-size':'cover'
						  					 });
					  }
				  }
				  ,error:function(error,xhr,status){
					  alert("배경 이미지 로딩 에러입니다.");
				  }
			   });
		}
		loadBackImage();
		
		//배경 이미지 업로드 하기
		$('#back-submit').on('click',function(){
			var userFile = $('#image-input');
			
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
			    type:'post'
			   ,url:'/uploadImage/'+nameType+'/'+ name
			   ,data:formData
			   ,processData:false
			   ,contentType:false
			   ,success:function(result,xhr,status){
				   alert("배경 등록에 성공했습니다.");
				   $('#back-image').hide();
				   loadBackImage();
			   }
			   ,error:function(error,xhr,status){
				   alert("파일 업로드에 실패했습니다.");
			   }
			});
			
		});
		
		//글쓰기 버튼 클릭 이벤트 핸들러, 내용 trim null 체크 form 전송
		$('.new-board button[type=submit]').on('click',function(e){
			e.preventDefault();
			var content = $('textarea[name=content]');
			if(!$.trim($('textarea[name=content]').val())){
				alert("내용을 입력해주세요");
				return;
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
			if(chk>900){
				alert("최대 글자 수를 넘었습니다.");
				return;
			}	
			 $('form[action="/channel/registerFeed"]').submit(); 
		});
		//------------ form 전송 끝
		
		//파일첨부 이벤트 트리거
		$('.new-board-attach button[type=button]').on('click',function(){
			$('input[name=files]').trigger('click');
		});
		
		//파일 첨부 시 확인용 아이콘 + 취소 아이콘
		$('input[name=files]').on('change',function(){
			var imgRegex = new RegExp("(.*?)\.(jpg|jpeg|png|bmp)");
			var maxSize = 10485760; //10메가
			var icons = '<i style="margin:8px 8px;"class="fas fa-check-circle"></i><i id="delete" style="margin:8px 2px;"class="fas fa-times-circle"></i>';
			
			//파일 확장자 + 사이즈 체크
			if($(this)[0].files.length !== 0){
				if(!imgRegex.test($(this)[0].files[0].name)){
					alert('jpg,jpeg,png,bmp 파일만 업로드 가능합니다.');
					$(this).val('');
					return;
				} else if($(this)[0].files[0].size > maxSize){
					alert('용량은 10MB까지 입니다.');
					$(this).val('');
					return;
				}
				$('.new-board-attach button[type=button]').after(icons);//아이콘 추가
			} 
		});
		
		//x아이콘 클릭시 인풋 파일 내용 초기화 아이콘 모두 지우기
		$('.new-board-attach').on('click','#delete',function(){
			console.log($('input[name=files]')[0].files.length);
			$('input[name=files]').val('');
			console.log($('input[name=files]')[0].files.length);
			$(this).prev().remove();
			$(this).remove();
		});
		
		var ddd = '<c:out value="${feedsMap}"/>';
		console.log(ddd);
		
		
		
	});
</script>
</html>