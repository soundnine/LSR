<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tasty Food Community - 채널 상세</title>
<link href="/resources/bootstrap-3.3.2/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css"
	rel="stylesheet">
<link href="/resources/css/get-channel.css" rel="stylesheet">
</head>
<body>

	<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<!-- 아랫면 내용 ------------------------------------- -->
	<c:set value="${channelMap }" var="map"/>
	
	<div class="container">
		<div class="row main">
			<div class="col-xs-12">
				<!-- Profile -------------------------------------- -->
				<div class="profile">
				  <c:forEach items="${map['channel'] }" var="channel">	<!-- channel은 안 비어서 오니까 if문 안쪽으로 -->		
					 <c:if test="${empty channel.attachVO.uuid }">
						<div style="background: url('/resources/image/no-thumbnail-ch.jpg') no-repeat center center;background-size: cover;" class="image-box"></div>
					 </c:if>
					 <c:if test="${not empty channel.attachVO.uuid }">
					 	<c:url value="/showImage" var="url">
							<c:param name="pathName" value="${channel.attachVO.uploadPath }\\${channel.attachVO.uuid }_${channel.attachVO.fileName }"/>
						</c:url>
						<div style="background: url('${url}') no-repeat center center; background-size: cover;" class="image-box"></div>
					 </c:if>
				  </c:forEach>	 	
					<div class="profile-bottom">
						<div class="pseudo-profile-bottom">
							<div class="profile-thumbnail">
								<c:if test="${empty map['ownerImage'] }">
									<img src="/resources/image/no-thumbnail-user.png">
								</c:if>
								
								<c:if test="${not empty map['ownerImage'] }"> <!-- ownerImage는 비어서 올 수 있으니까 for문이 안쪽으로 -->
									<c:forEach items="${map['ownerImage'] }" var="ownerImage">
												<c:url value="/showImage" var="url">
					 								<c:param name="pathName" value="${ownerImage.uploadPath }\\${ownerImage.uuid }_${ownerImage.fileName }"/>
					 							</c:url>
												<img src="${url }">
									</c:forEach>
								</c:if>
							</div>
							<div class="profile-name">
								<c:forEach items="${map['channel'] }" var="channel" varStatus="status">
									<c:if test="${status.first }">
									<span><c:out value="${channel.channelName }"/></span>
									<input id="channel-name" type="hidden" value="${channel.channelName }"/>
									</c:if>
								</c:forEach>
							</div>
							<button type="button" class="follow-btn btn btn-sm btn-primary">Follow</button>
						</div>
					</div>
				</div>
				<!-- 게시글 -------------------------------------- -->
				<c:forEach items="${map['feeds']}" var="feed">
				<div class="ch-board">
					
					<div class="ch-board-writer">
								<c:if test="${empty map['ownerImage'] }">
									<img src="/resources/image/no-thumbnail-user.png">
								</c:if>
								
								<c:if test="${not empty map['ownerImage'] }"> <!-- ownerImage는 비어서 올 수 있으니까 for문이 안쪽으로 -->
									<c:forEach items="${map['ownerImage'] }" var="ownerImage">
												<c:url value="/showImage" var="url">
					 								<c:param name="pathName" value="${ownerImage.uploadPath }\\${ownerImage.uuid }_${ownerImage.fileName }"/>
					 							</c:url>
												<img src="${url }">
									</c:forEach>
								</c:if>
						<span><c:out value="${map['channel'][0].channelName }"/></span>
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
						<span><c:out value="${feed.content }" /></span>
					</div>
					<div class="ch-board-reply">
						<input class="feed-idx" type="hidden" value="${feed.idx }"/>
						<i class="like fas fa-thumbs-up"></i><i class="fas fa-comment-dots"></i>
					</div>
				</div>
				</c:forEach>
			</div>
		</div>

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
 		
 		//getChannel 로드 시 팔로우 체크하여 active 활성화 비활성화
		var followIcon = function(accessId, channelName){
			$.ajax({
				type:'get'
			   ,url:'/channel/followCheck/'+channelName+'/'+accessId
			   ,success:function(result,xhr,status){
				   		if(result == 1){
				   				$('.follow-btn').addClass('active');
				   		} else{
				   				$('.follow-btn').removeClass('active');
				   		}
			   	   }
			   ,error:function(error,xhr,status){
				   alert('팔로우 에러입니다.');
				   }
			   });
	       };
	    var channelName = $('#channel-name').val();
	    
	    var accessId = '<c:out value="${sessionScope.login.userId}"/>';
		followIcon(accessId,channelName);
 		
 		//팔로우 ajax
		$('.follow-btn').on('click',function(){
			//비활성화 시엔 누르면 팔로우
			if(!$(this).hasClass('active')){
				
				$.ajax({
					type:'post'
				   ,url:'/channel/follow/'+channelName+'/'+accessId+'/follow'
				   ,success:function(result,xhr,status){
					   $('.follow-btn').addClass('active');
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
				   ,success:function(result,xhr,status){
					   $('.follow-btn').removeClass('active');
				   }
				   ,error:function(error,xhr,status){
					   alert("팔로우 에러입니다.");
					   }
				});
   			}
		});
 		
 		//idx 모음 배열
 		var idxArray = new Array();
 		$('input[class=feed-idx]').each(function(i){
 			idxArray.push($('input[class=feed-idx]').eq(i).val());
 		});
 		
 	
		//페이지 들어오자마자 세션 비교하여 좋아요 체크여부 확인 후 색깔 주거나 빼기. 서버에서 유저 아이디로 좋아요한 피드 인덱스 받아온 후 채널 속 피드목록과 비교한 후 겹치면 색깔주기.
		 var checkFeedsLike = function(accessId){
			$.ajax({
				type:'get'
			   ,url:'/checkLikeUserAllFeeds/'+accessId
			   ,dataType:'json'
			   ,success:function(result,xhr,status){
				   console.log(result);
				   	    if(result.length !== 0){
				   		  for(var i in idxArray){
				   			  for(var j in result){
				   				if(idxArray[i] == result[j]){
				   					console.log("in for for: "+idxArray[i]);
					   				$('input[value='+idxArray[i]+']').next().addClass('like-check');
					   			}
					   	
				   			}
				   		  }
					   	}
					  }
			   ,error:function(error,xhr,status){
				   alert("피드 좋아요 화면 체크 에러입니다.");
				   }
			   });
	       };
		checkFeedsLike(accessId); 
		
		//좋아요 ajax
		$('.ch-board').on('click','.like',function(){
			var thisLike = $(this);
			var likeUserId = '<c:out value="${sessionScope.login.userId}"/>';
			var idx = $(this).prev().val();
			var boardType = 'feed';
			
			 if(!$(this).hasClass('like-check')){
				$.ajax({
					type:'post'
				   ,url:'/likes/'+'plus'+'/'+likeUserId+'/'+boardType+'/'+idx
				   ,success:function(result,xhr,status){
					   if(result == 'success'){
						   alert("좋아요 성공");
					   thisLike.addClass('like-check');
					   }
				   }
				   ,error:function(error,xhr,status){
					   alert("좋아요 체크 에러입니다.");
					   }
				});
   			 } 
			 
			 else if($(this).hasClass('like-check')){
					$.ajax({
						type:'post'
					   ,url:'/likes/'+'minus'+'/'+likeUserId+'/'+boardType+'/'+idx
					   ,success:function(result,xhr,status){
						   if(result == 'success'){
							   alert("좋아요 지우기 성공");
						   thisLike.removeClass('like-check');
						   }
					   }
					   ,error:function(error,xhr,status){
						   alert("좋아요 체크 에러입니다.");
						   }
					});
	   			}
			}); 
 	});
</script>
</html>