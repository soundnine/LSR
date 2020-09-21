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
<link href="/resources/css/main.css" rel="stylesheet">
</head>
<body>

	<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<%@ include file="/WEB-INF/views/include/leftSide.jsp" %>
	<!-- 우측 면 -------------------------------------- -->
			<div id="feed-wrapper" class="col-xs-12 col-sm-8">
				
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
			var hidePopularBoard = $('.popular-board');
			if (window.matchMedia("(max-width: 768px)").matches) {
				  hideInfo.hide();
				  hidePopularBoard.hide();
				} else{
					hideInfo.show();
					hidePopularBoard.show();
				}
		})();
		
		//반응형 resizing hr밑 info 삭제
		$(window).resize(function(){
			var hideInfo = $('.info-wrapper');
			var hidePopularBoard = $('.popular-board');
			
			if (window.matchMedia("(max-width: 768px)").matches) {
				  hideInfo.hide();
				  hidePopularBoard.hide();
				} else{
					hideInfo.show();
					hidePopularBoard.show();
				}
		});
		
		//아이콘 눌러서 수정 전 페이지
		$('.fa-cog').on('click',function(e){
			location.href='pre-user-info.html';
		});
		
		var accessId = '<c:out value="${sessionScope.login.userId}"/>';
		var loadNewFeeds = function(p){
			if(!p){
				var page = 1;
			} else{
				var page = p;
			}
			
			$.ajax({
				type:'get'
			   ,url:'/getNewFeeds/'+ accessId + '/' + page
			   ,dataType:'json'
			   ,success:function(result,xhr,status){
				   console.log("page:"+page);
				   console.log(result);
				   console.log(result.length);
				   var list = '';
				   
 				   if(!result || result.length === 0){
					   $('#feed-wrapper').html('<div style="background-color:white; border:solid 1px; border-color:#D3D3D3;"><i class="fas fa-ban"></i><span>구독 채널 새글 목록이 없습니다.</span></div>')
				   } else{
					   for(i=0;i<result.length;i++){
						   //채널 이미지 여부
						   if(!result[i].CH_UUID){
							   var chImage = '/resources/image/no-thumbnail-user.png'
						   } else{
							   var chEncodedPath = encodeURIComponent(result[i].CH_UPLOADPATH+'\\'+result[i].CH_UUID+'_'+result[i].CH_FILENAME);
							   var chImage = '/showImage?pathName='+chEncodedPath+'';
						   }
						   //피드 이미지 여부
						   if(!result[i].FEED_UUID){
							   var feedImage = '';
						   } else{
							   var fEncodedPath = encodeURIComponent(result[i].FEED_UPLOADPATH+'\\'+result[i].FEED_UUID+'_'+result[i].FEED_FILENAME);
							   var feedImage = '<div><img style="width:100px; height:100px;" src="/showImage?pathName='+fEncodedPath+'"></div>';
						   }
						   
						   list = list + '<div class="new-feed"><div class="feed-writer"><img src="'+chImage+'"><span>'+result[i].CHANNELNAME+'</span></div><div class="feed-content">'+feedImage+result[i].CONTENT+'</div><div class="feed-reply"><input class="feed-idx" type="hidden" value="'+result[i].IDX+'"/><i class="like fas fa-thumbs-up"></i><i class="fas fa-comment-dots"></i></div></div>';
						   
					   }
					   if(result.length>2){
						   list = list + '<div style="text-align:center;"><input type="hidden" value="'+page+'"><i class="fas fa-arrow-circle-down"></i></div>';
					   }
					   //페이지 이동시 버튼 삭제
					   $('.fa-arrow-circle-down').remove();
					   //피드 리스트 삽입
					   $('#feed-wrapper').append(list);
				   } 
			   }
			   ,error:function(error,xhr,status){
				    alert('피드 로드 에러입니다.');
			   }	   
			});
			
		}
		loadNewFeeds();
		
		//다음 피드 목록 불러오기
		$('#feed-wrapper').on('click','.fa-arrow-circle-down',function(){
			var count;
			var currentPageNum = parseInt($(this).prev().val());
			console.log(currentPageNum);
			
			$.ajax({
				type:'get'
			   ,url:'/getNewFeedsCount/'+ accessId
			   ,dataType:'json'
			   ,async:false //동기식으로 전환했더니 count값 대입O
			   ,success:function(result,xhr,status){
				   count = result;
			   }
			});
			
			console.log('count:'+count);
			//값 비교 후 3의 배수(화살표는 있는데 더 이상의 데이터는 없을 때) 처리
			if(currentPageNum == Math.ceil(count/3)){
				$('.fa-arrow-circle-down').remove();
				alert("새로운 피드가 없습니다.");
				return;
			}
			else{
			loadNewFeeds(currentPageNum + 1);
			}
		});
	});
</script>
</html>