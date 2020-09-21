<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tasty Food Community - 채널</title>
<link href="/resources/bootstrap-3.3.2/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css"
	rel="stylesheet">
<link href="/resources/css/channel-list.css" rel="stylesheet">
</head>
<body>

	<%@ include file="/WEB-INF/views/include/header.jsp" %>
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
				<!-- 구독 채널 -------------------------------------- -->
				<div class="subscription panel panel-primary">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="fas fa-cloud"></i><span>구독</span>
						</h3>
					</div>
					<ul class="left-channel-list list-group">
						<li class=" list-group-item"><i class="fas fa-ban"></i><span>구독중인
								채널이 없습니다.</span></li>
					</ul>
				</div>
				<!-- 채널 메뉴 -------------------------------------- -->
				<div class="panel panel-primary">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="fas fa-cloud"></i><span>채널</span>
						</h3>
					</div>
					<ul class="list-group">
						<li class="list-group-item"><i class="fas fa-list"></i><a><span>채널
									목록</span></a></li>
						<li class="list-group-item"><i class="fas fa-plus"></i><a><span>채널
									개설</span></a></li>
						<li class="list-group-item"><i class="fas fa-coins"></i><a href="/channel/myChannel"><span>내
									채널 관리</span></a></li>
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
	<!-- 우측 면 -------------------------------------- -->
			<div class="col-xs-12 col-sm-8">
			
				<div id="channel-list">
					
					</div>
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
				} else{
					hideInfo.show();
					hideSubscription.show();
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
				} else{
					hideInfo.show();
					hideSubscription.show();
				}
		});	
		
		//아이콘 눌러서 수정 전 페이지
		$('.fa-cog').on('click',function(e){
			location.href='/preUserInfo';
		});
		
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
		
		var accessId = '<c:out value="${sessionScope.login.userId}"/>';
		
		//채널 목록 로드
		var ajaxListLoad = function(){
			$.ajax({
				type:'get'
			   ,url:'/channel/getList/'+accessId
			   ,async:false
			   ,dataType:'json'
			   ,success:function(result,xhr,status){
				   console.dir(result);
				   var channelList = result.chContentAndImage;
				   var followList = result.followList;
				   //전체 틀
				   var list = '<div class="panel panel-primary"><div class="panel-heading"><span>채널목록</span></div><div class="ajax-list panel-body">';
				   //채널목록 없을 시
				   if(result.length === 0){
					   
					   list = list + '<i class="fas fa-ban"></i> 현재 개설된 채널이 없습니다</div></div>';
					   $('#channel-list').html(list);	
					   
					   //채널목록 존재 시
				   } else {
					   //팔로우 목록 없을 시
					  if(followList.length === 0){
						  var active = '';
					  }
					   //있을 시
					  for(i=0;i<channelList.length;i++){
						  var channelName = channelList[i].channelName;
						  var channelOwner = channelList[i].channelOwner;//웹소켓 세션 followee 구별용
						  console.log("activeCheck: "+active);
						    //채널 목록 이름과 좋아요 목록 이름 비교하여 active
						   		for(j=0;j<followList.length;j++){
						   			console.log("pre:"+channelList[i].channelName);
						   			if(channelList[i].channelName == followList[j]){
						   				console.log("Y:"+channelList[i].channelName);
						   				var active = 'active';
						   			}
						   		}
						     //이미지 비교
						  	if(channelList[i].attachVO === null){//채널 이미지 없을 시 기본 이미지
								var imgPath = '/resources/image/no-thumbnail-user.png';
							}
							else{
							    var uuid = channelList[i].attachVO.uuid;
							    var uploadPath = channelList[i].attachVO.uploadPath;
							    var fileName = channelList[i].attachVO.fileName;  
							    var imgPath = '/showImage?pathName='+encodeURIComponent(uploadPath+'\\'+uuid+'_thumb_'+fileName);
								
							} 
						  	//하나씩 담기
						     list = list+('<ul><li>'+
									     '<img src="'+imgPath+'" class="small-user-image pull-left"><a href="/channel/getChannel?channelName='+channelName+
									     '"><span>'+channelName+'</span></a><button type="button" class="follow-btn btn btn-primary btn-xs pull-right '+active+'">Follow</button><input type="hidden" value="'+channelOwner+'"/>'+
									     '</li></ul>');
						  	active='';//처음 위에서 선언 했을땐 if문을 한번이라도 통과하면  그뒤로 계속 active값이 active 상태, 같을 땐 active 다를 땐 공백 값을 주면 비교대상이 2개가 넘어가면 공백 active 혼재되어 이상한 값을 가짐. 뒤에 선언하니 처음 들어갈 때 undefined되며 작동. 비교할 for문 값이 없을때의 active값만 따로 처리.
					  } // else - 첫번째 for문 끝
					  
					    //왼쪽 구독목록  --> 먹통 구간 발견 --> 한칸 위에 써서 for문 두개가 이중 for문으로 노드삽입 안쪽-바깥쪽 계속 반복.
					     if(followList.length !== 0 && followList !== null){
						   var leftList = '';
						   for(i=0;i<followList.length;i++){
							   leftList = leftList + '<li style="list-style:none;padding:10px;"><i style="margin-right:4px;" class="fas fa-apple-alt"></i><a href=/channel/getChannel?channelName='+followList[i]+'>'+followList[i]+'</a></li>'
						   }
						   $('.left-channel-list').html(leftList);
					   } else if(followList.length === 0 || followList === null){
						   $('.left-channel-list').html('<li class=" list-group-item"><i class="fas fa-ban"></i><span>구독중인 채널이 없습니다.</span></li>');
					   }    
					  
					   //오른쪽 채널목록 -> 첫번째 for문ㄴ
					  list = list + '</div></div>';
					  $('#channel-list').html(list);
				     
				   }//else 끝
			     } //success 끝
			   ,error:function(error,xhr,status){
				   alert("채널 로드 에러입니다.");
			   } 	
				    
			});
			
		}
		ajaxListLoad();
		
		//채널 목록 클릭 시 목록 로드
		$('.fa-list').next('a').on('click',function(e){
			e.preventDefault();
			console.log("채널 목록 없을 시에도 확인용");
			ajaxListLoad();
		});
		
		// 채널 개설 클릭 시 폼 생성
		$('.fa-plus').next('a').on('click',function(e){
			e.preventDefault();
			
			 var form = '<div class="ch-form"><ul class="list-group"><li class="list-group-item">채널 개설</li></ul>'+
			            '<form action="/channel/registerChannel" method="post" class="form-group">'+
			            '<div>&nbsp;<i class="fas fa-address-card"></i>&nbsp;&nbsp;채널명'+ 
			            '<input style="width:90%; margin:0 auto;" class="form-control" type="text" name="channelName" required maxlength="20"/>'+
			            '<input type=hidden name=channelOwner value="${sessionScope.login.userId}"></div>'+
			            '<div style="height:30px; margin:0;"><button style="margin-bottom:4px;"type="submit" class="btn btn-sm btn-primary pull-right">개설</button></div></form></div>';
			            
			$('#channel-list').html(form); 
		});
		//채널 개설 전 채널 존재여부 검사
		$('#channel-list').on('click','button[type=submit]',function(e){
			e.preventDefault();
			var nameValue = $(this).parent().parent('form').find('input[name=channelName]').val();
			var form = $(this).parent().parent('form');
			console.log(nameValue);
			if(!$.trim(nameValue)){
				alert("채널 이름을 입력해주세요.");
				return;
			}
			var userId = '${sessionScope.login.userId}';
			$.ajax({
				type:'get'
			   ,url:'/channel/channelExistenceChk/'+ userId
			   ,dataType:'json'
			   ,success:function(result,xhr,status){
				   if(result === 0){
					   var chk = confirm("개설하시겠습니까?");
					   if(chk === true){
						   form.submit();
					   } else if(chk === false){
						   return;
					   }
				   } else {
					   alert("채널이 이미 존재합니다.");
					   return;
				   }
			   }
			   ,error:function(error,xhr,status){
				   alert("채널 개설 에러입니다.");
			   }
			});
		});
		
		//팔로우 ajax
		$('#channel-list').on('click','.follow-btn',function(e){
			e.stopImmediatePropagation();
			var thisBtn = $(this);
			var channelName = $(this).prev().find('span').text();
			var channelOwner = $(this).next().val();
			console.log(channelName);
			console.log(channelOwner);
			//비활성화 시엔 누르면 팔로우
			if(!$(this).hasClass('active')){
				
				$.ajax({
					type:'post'
				   ,url:'/channel/follow/'+channelName+'/'+accessId+'/follow'
				   ,async:false
				   ,success:function(result,xhr,status){
					   thisBtn.addClass('active');
					   //소켓 send
					   if(socket){
						   socket.send(accessId+','+channelOwner);
					   }
				   }
				   ,error:function(error,xhr,status){
					   alert("팔로우 에러입니다.");
					   }
				});
   			}
			//활성화 시엔 누르면 언팔로우
			else if($(this).hasClass('active')){
				
				$.ajax({
					type:'post'
				   ,url:'/channel/follow/'+channelName+'/'+accessId+'/unFollow'
				   ,async:false
				   ,success:function(result,xhr,status){
					   thisBtn.removeClass('active');
				   }
				   ,error:function(error,xhr,status){
					   alert("팔로우 에러입니다.");
					   }
				});
   			}
			ajaxListLoad();
		});
	
	});
</script>
</html>