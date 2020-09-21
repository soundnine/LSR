<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tasty Food Community - 자유게시판</title>
<link href="/resources/bootstrap-3.3.2/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css"
	rel="stylesheet">
<link href="/resources/css/get-free-board.css" rel="stylesheet">
</head>
<body>

	<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<%@ include file="/WEB-INF/views/include/leftSide.jsp" %>
	<!-- 우측 면 -------------------------------------- -->
			<div class="col-xs-12 col-sm-8">
				<div style="width:95%;">
					<i class="fas fa-cloud"></i>
					<h4 style="display: inline-block; width: 40%; margin: 2px auto;">자유게시판</h4>
					<i class="fas fa-thumbs-up pull-right"><span id="likes-num"></span></i>
					<i class="fas fa-hand-point-up pull-right">&nbsp;<c:out value="${vo.counts }"></c:out></i>
				</div>
				<div class="title">
					<i class="fas fa-heading"></i><span>&nbsp;Title</span>
					<div>
						<span><c:out value="${vo.title}"/></span>
					</div>
				</div>
				<div class="writer">
					<i class="fas fa-user"></i><span>&nbsp;Writer</span>
					<div>
						<span><c:out value="${vo.writer }"/></span></span>
					</div>
				</div>
				<div class="date">
					<i class="fas fa-calendar-alt"></i><span>&nbsp;Date</span>
					<div>
						<span><fmt:formatDate value="${vo.updateDate }" pattern="yyyy-MM-dd"/></span>
					</div>
				</div>
				<div class="content">
					<i class="fas fa-book-open"></i><span>&nbsp;Content</span>
					<div><c:out value="${vo.content }"/></div>
				</div>
				
				<div class="attach">
					<i class="fas fa-paperclip"></i>
					<ul>
					  <c:forEach items="${attach }" var="fileInfo">
						<li>
							<a href="/download?fileName="><i class="fas fa-save"></i><c:out value="${fileInfo.fileName }"/></a>
							<input type="hidden" 
							data-uploadpath="<c:out value='${fileInfo.uploadPath }'/>" 
							data-uuid="<c:out value='${fileInfo.uuid }'/>"
							data-filename="<c:out value='${fileInfo.fileName }'/>">
						</li>
					  </c:forEach>
					</ul>
				</div>

		<div>

			<div id="reply-wrapper" class="panel panel-primary">
				<div class="panel panel-heading">
					<i class="fa fa-comments fa-fw"></i> 
					<ul id="pagination">
					
					</ul>
					<button class='btn btn-xs pull-right' data-toggle="modal" data-target="#write-reply">댓글</button>
				</div>
				<div class="panel-body">
					<ul class="reply">
				
					</ul>
				</div>
			</div>
   <!---------------------- 리플 작성 모달 -->
    <div class="modal fade" id="write-reply" role="dialog" aria-labelledby="replyModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title"><i class="fas fa-comment-dots"></i>&nbsp;댓글 작성</h4>
                    </div>
                    <div class="modal-body">
                       <p id="writer-id"><i class="fas fa-user-edit"></i>&nbsp;<c:out value="${sessionScope.login.userId }"/></p>
                       <input id="reply-content" class="form-control" type="text" maxlength="30">
                    </div>
                    <div class="modal-footer">
                    	<button id="reply-submit" type="button" class="btn btn-primary" data-dismiss="modal">댓글 쓰기</button>		
                        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                    </div>
                </div>
            </div>
        </div>
  <!---------------------- 모달 끝 -->

			<div class="button-wrapper">
				<button id="like" type="button" class="btn btn-default">
					<span class="glyphicon glyphicon-heart"></span> 좋아요
				</button>
				<c:if test="${sessionScope.login.userId == vo.writer }">
					<button type="button" id="modify" class=" btn btn-primary">수정</button>
					<button type="button" id="remove" class="btn btn-warning">삭제</button>
				</c:if>
				<button type="button" id="reboard" class="btn btn-primary">답글</button>
				<button type="button" id="list" class="btn btn-default">목록</button>
			</div>
			<form action="/free/removeBoard" method="post">
				<input type="hidden" name="idx" value="${vo.idx }" />
			</form>
		</div></body>
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
		
		//변수
		var likeUserId = '${sessionScope.login.userId}';
		var boardType = 'freeBoard';
		var idx = '<c:out value="${vo.idx}"/>'
		var page = '<c:out value="${page}"/>'
		var type = '<c:out value="${type}"/>'
		var keyword = '<c:out value="${keyword}"/>'
		
		//페이지 들어오자마자 세션 비교하여 좋아요 체크여부 확인 후 색깔 주거나 빼기
		var initLikeIcon = function(accessId, type, idx){
			$.ajax({
				type:'get'
			   ,url:'/checkLikeUser/'+accessId+'/'+type+'/'+idx
			   ,success:function(result,xhr,status){
				   		if(result == 1){
				   				$('#like').find('span').addClass('like-check');
				   		} else{
				   				$('#like').find('span').removeClass('like-check');
				   		}
			   	   }
			   ,error:function(error,xhr,status){
				   alert("좋아요 유저 에러입니다.");
				   }
			   });
	       };
		initLikeIcon(likeUserId,boardType,idx);
		
		//좋아요 숫자 뿌리기
		var likeNumberAjax = function(){
			$.ajax({
				type:'get'
			   ,url:'/free/getLikesNum/'+idx
			   ,dataType:'json'
			   ,success:function(result,xhr,status){
				  
					$('#likes-num').text(result);
				} 
			   ,error:function(error,xhr,status){
					alert("좋아요 로딩에 실패했습니다.");
				}
			});
		}
		likeNumberAjax();
		
		//좋아요 ajax
		$('#like').on('click',function(e){
			/* e.preventDefault(); */
			console.log($(this).find('span').hasClass('like-check'));
			if(!$(this).find('span').hasClass('like-check')){
				
				$.ajax({
					type:'post'
				   ,url:'/likes/'+'plus'+'/'+likeUserId+'/'+boardType+'/'+idx
				   ,success:function(result,xhr,status){
					   if(result == 'success'){
					   $('#like').find('span').addClass('like-check');
					   likeNumberAjax(); //좋아요 숫자 뿌리기 콜백으로 즉시반영
					   }
				   }
				   ,error:function(error,xhr,status){
					   alert("좋아요 체크 에러입니다.");
					   }
				});
   			}
			else if($(this).find('span').hasClass('like-check')){
				
				$.ajax({
					type:'post'
				   ,url:'/likes/'+'minus'+'/'+likeUserId+'/'+boardType+'/'+idx
				   ,success:function(result,xhr,status){
					   if(result == 'success'){
					   $('#like').find('span').removeClass('like-check');
					   likeNumberAjax();
					   }
				   }
				   ,error:function(error,xhr,status){
					   alert("좋아요 체크 에러입니다.");
					   }
				});
   			}
		});
	
		
		//댓글 ajax
		var getReplyList = function(targetPage){
			console.log(targetPage);
			if(!targetPage){
				var page = 1;
			} else{
				var page = targetPage;
			}
			console.log("@@page:"+page);
			
			var boardType = 'freeBoard';
			$.ajax({
				type:'get'
			   ,url:'/replies/getList/'+boardType+'/'+idx+'/'+page
			   ,dataType:'json'
			   ,success:function(result,xhr,status){
				   var replyLists = result.replyList;
				   var totalCounts = result.totalCount;
   				   //사용자 체크하여 수정 삭제버튼 여부				   
				   var sessionIdChk = '<c:out value="${sessionScope.login.userId}"/>';
				   
				   //이미지 넣기
				   /* if(${sessionScope.login.attachVO} === null){
						var pathName = 'src=/resources/image/no-thumbnail-user.png';
					}
					else if(${sessionScope.login.attachVO} !== null){
						//사용자 이미지용
					    var uuid = '${sessionScope.login.attachVO.uuid}';
						var uploadPath = decodeURIComponent('${sessionScope.login.attachVO.uploadPath}');
						var fileName = '${sessionScope.login.attachVO.fileName}';
					    var pathNames = encodeURIComponent(uploadPath+'\\'+uuid+'_'+fileName);
						var pathName = 'src=/showImage?pathName='+pathNames;
					} */
				   
				   
				   //페이징
				   if(replyLists||totalCounts){
					   var lastPage = Math.ceil(totalCounts/3);
					   var paging = '';
					   var replyContent ='';
					   
					
					   for(i=1;i<=lastPage;i++){
						   paging = paging + '<li><a data-page="'+i+'" href="/replies/getList/'+boardType+'/'+idx+'/'+i+'">'+i+'</a></li>'
					   }
					   
					   $('#pagination').html(paging);
					   
					   //데이터 계속 안나오던것 배열 인덱스 초과해서였음.... 아이디 일치 시 수정 삭제버튼 O 이미지 있을 시 로컬 없을 시 기본 이미지
					   for(i=0;i<replyLists.length;i++){ 
						   if(sessionIdChk == replyLists[i].replyWriter){
							 	
							   if(replyLists[i].attachVO === null){
									var pathName = 'src=/resources/image/no-thumbnail-user.png';
								}
								else{
								    var uuid = replyLists[i].attachVO.uuid;
								    var uploadPath = replyLists[i].attachVO.uploadPath;
								    var fileName = replyLists[i].attachVO.fileName;    //원본 대신 썸네일
								    var pathNames = encodeURIComponent(uploadPath+'\\'+uuid+'_thumb_'+fileName);
									var pathName = 'src=/showImage?pathName='+pathNames;
								}
							   
							   
					   			replyContent = replyContent + '<div data-replyidx="'+replyLists[i].idx+
					   										  '"><div style="margin:2px;"><img style="width:20px;height:18px;border-radius:50%;margin-right:4px;"'+pathName+'>'
					   									      +replyLists[i].replyWriter+
					   										  '<span class="pull-right">'+replyLists[i].updateDate+
					   										  '</span></div><div class="reply-content">'
					   										  +replyLists[i].reply+
					   										  '<i style="margin-left:4px; margin-right:10px;" class="fas fa-trash-alt pull-right"></i><i class="fas fa-cog pull-right"></i></div></div>'
						   } else if(sessionIdChk != replyLists[i].replyWriter){
							   
							    if(replyLists[i].attachVO === null){
									var othersPathName = 'src=/resources/image/no-thumbnail-user.png';
								}
								else{
								    var othersUuid = replyLists[i].attachVO.uuid;
								    var othersUploadPath = replyLists[i].attachVO.uploadPath;
								    var othersFileName = replyLists[i].attachVO.fileName;
								    var othersPathNames = encodeURIComponent(othersUploadPath+'\\'+othersUuid+'_thumb_'+othersFileName);
									var othersPathName = 'src=/showImage?pathName='+othersPathNames;
								}
							    
							    
							   
							    replyContent = replyContent + '<div data-replyidx="'+replyLists[i].idx+
							                                  '"><div style="margin:2px;"><img style="width:20px;height:18px;border-radius:50%;margin-right:4px;"'+othersPathName+'>'
							                                  +replyLists[i].replyWriter+
							                                  '<span class="pull-right">'+replyLists[i].updateDate+
							                                  '</span></div><div>'
							                                  +replyLists[i].reply+
							                                  '</div></div>'
						   }
					   } 
					   
					   $('.reply').html(replyContent);
				   } else{
					   return;
				   }
			   }
			   ,error:function(result,xhr,status){
				   alert("리플 리스트 로드 에러입니다.");
			   }	   
			});
		}
		
		//댓글 페이지 버튼 클릭
		$('#pagination').on('click','a',function(e){
			e.preventDefault();
			var pageMove = $(this).data('page');
			getReplyList(pageMove);
		});
		
		
		getReplyList();
		
		//댓글 삭제 버튼 클릭
		$('.reply').on('click','.fa-trash-alt',function(){
			var chk = confirm('정말 삭제하시겠습니까?');
			var idxVal = $(this).parent('div').parent('div').data('replyidx');
			console.log(idxVal);
			if(!chk){
				return;
			} else if(chk){
				console.log("trueTest");
				$.ajax({
					type:'post'
				   ,url:'/replies/remove/'+ idxVal
				   ,success:function(){
					   alert("삭제 되었습니다.");
				   }
				   ,error:function(){
					   alert("삭제 중 에러가 났습니다.");
				   }
				});
				getReplyList(1); //콜백 안에 넣으니까 작동안해서 꺼냈더니 작동 O
			}
		});
		
		//댓글 수정 버튼 클릭
		$('.reply').on('click','.fa-cog',function(){
			var targetWrapper = $(this).closest('div');
			var currentContent = targetWrapper.text();
			console.log(currentContent);
			targetWrapper.html('<input type="text" name="reply" minlength="1" maxlength="30" value="'+currentContent+'" required><i class="fas fa-check-circle pull-right"><i style="margin-left:4px; margin-right:8px;" class="fas fa-times-circle pull-right"></i></i>');
			
			//댓글 수정 중 취소버튼 클릭
			$('.reply').on('click','.fa-times-circle',function(){
				targetWrapper.html(currentContent+'<i style="margin-left:4px; margin-right:10px;" class="fas fa-trash-alt pull-right"></i><i class="fas fa-cog pull-right"></i></div></div>');
			});
			
			//댓글 수정 중 제출버튼 클릭
			$('.reply').on('click','.fa-check-circle',function(){
				var replyContent = $(this).prev().val();
				var replyIdx = $(this).parent('div').parent('div').data('replyidx');
				if(!$.trim(replyContent)){
					alert("수정 내용을 입력해주세요.");
					return;
				}
				 $.ajax({
					type:'post'
				   ,url:'/replies/modify/'+replyIdx
				   ,data:JSON.stringify(replyContent)
				   ,contentType:'application/json; charset=utf-8'
				   ,success:function(result,xhr,status){
					   targetWrapper.html(replyContent+'<i style="margin-left:4px; margin-right:10px;" class="fas fa-trash-alt pull-right"></i><i class="fas fa-cog pull-right"></i></div></div>');
				   }
				   ,error:function(error,xhr,status){
					   alert('댓글 수정 에러입니다.');
				   }
				   
				}); 
			});
		});
		
		//댓글 작성 후 제출 버튼 클릭
		$('#reply-submit').on('click',function(){
			var replyWriterValue = '<c:out value="${sessionScope.login.userId}"/>';
			var replyValue = $('#reply-content').val();
			
			
			if(!$.trim(replyValue)){
				alert("내용을 입력해주세요.");
				return;
			}
			
			var replyObj = { reply:replyValue
						    ,replyWriter:replyWriterValue
						    ,freeBoardIdx:idx
						   };
			
			$.ajax({
				type:'post'
			   ,url:'/replies/register'
			   ,data:JSON.stringify(replyObj)
			   ,contentType:'application/json; charset=utf-8'
			   ,success:function(result,status,xhr){
				   alert("댓글이 등록되었습니다.");
				   $('#write-reply').hide();
				   getReplyList(1);
			   }
			   ,error:function(error,status,xhr){
				   alert("댓글 등록 에러입니다.");
			   }
			});
		});
		
		
		//아이콘 눌러서 수정 전 페이지
		$('.fa-cog').on('click',function(e){
			location.href='/preUserInfo';
		});
		
		//버튼 이동
		$('#modify').on('click',function(){
			location.href='/free/modifyFreeBoard?idx='+idx+'&page='+page+'&type='+type+'&keyword='+keyword+'';
		});
		
		$('#reboard').on('click',function(){
			location.href='/free/reBoard?idx='+idx+'&page='+page+'&type='+type+'&keyword='+keyword+'';
		});
		
		$('#list').on('click',function(){
			location.href='/free/freeBoardList?page='+page+'&type='+type+'&keyword='+keyword+'';
		});
		
		//삭제
		$('#remove').on('click',function(){
			var removeChk = confirm("정말 삭제하시겠습니까?");
			if(removeChk){
			$('form[action="/free/removeBoard"]').submit();
		 }
		});
		
		//다운로드
		$('.attach').on('click','a',function(e){
			e.preventDefault();
			var hidden = $(this).next();
			var downloadUri = encodeURIComponent(hidden.data('uploadpath')+'/'+hidden.data('uuid')+'_'+hidden.data('filename'));
			self.location ="/download?fileName="+downloadUri;
		});
		
		
		
		
	});
</script>
</html>