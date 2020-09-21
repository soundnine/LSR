<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<link href="/resources/css/free-board-list.css" rel="stylesheet">
</head>
<body>

	<%@ include file="/WEB-INF/views/include/header.jsp" %>
	<%@ include file="/WEB-INF/views/include/leftSide.jsp" %>
	<!-- 우측 면 -------------------------------------- -->
			<div class="col-xs-12 col-sm-8">
				<div class="notice">
					<p>자유게시판</p>
				</div>
				<div class="search-wrapper">
				  <form action="/free/freeBoardList" method="get">
					<select name="type">
						<option value="T" <c:out value = "${type eq 'T' ? 'selected':''}"/>>제목</option>
						<option value="W" <c:out value = "${type eq 'W' ? 'selected':''}"/>>작성자</option>
						<option value="C" <c:out value = "${type eq 'C' ? 'selected':''}"/>>내용</option>
						<option value="TC" <c:out value = "${type eq 'TC' ? 'selected':''}"/>>제목+내용</option>
					</select>				
					<input type="text" name="keyword" value="<c:out value='${keyword }'/>" maxlength="25">
					<button type="submit" class="btn btn-sm btn-primary" >검색</button>
				  </form>
				</div>

				<table class="table table-hover table-responsive">
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">제목</th>
							<th scope="col">작성자</th>
							<th scope="col">작성일</th>
							<th scope="col">조회수</th>
						</tr>
					</thead>

					<tbody>
					 <c:forEach items="${list}" var="vo">
						<tr>
							<td><c:out value="${vo.rn }"></c:out></td>
							<td><a class="board-title" href="/free/getFreeBoard?idx=<c:out value="${vo.idx }"/>&page=<c:out value="${page }"/>&type=<c:out value="${type }"/>&keyword=<c:out value="${keyword }"/>">
							<%-- <input type="hidden" data-idx="<c:out value='${vo.idx }'/>"> --%>
								<c:out value="${vo.title }"></c:out>&nbsp;[<c:out value="${vo.replyCount }"></c:out>]</a>
								<c:if test="${vo.locking == 1 }">
									<i class="fas fa-lock"></i>
								</c:if>
								<c:if test="${vo.attachCount>0 && vo.attachCount != null }">
									<i class="fas fa-file-download"></i>
								</c:if>
							</td>
							<td><c:out value="${vo.writer }"></c:out></td>
							<td><fmt:formatDate value="${vo.updateDate }" pattern="yyyy-MM-dd"/></td>
							<td><c:out value="${vo.counts }"></c:out></td>
						</tr>
					</c:forEach>	
					</tbody>
				</table>
				
				<div class="button-wrapper">
					<button type="button" class="btn btn-sm btn-primary">새글 쓰기</button>
				</div>
				
				<ul class="pagination">
					<li><a class="pre-move"><i class="fas fa-angle-left"></i></a></li>
					
					<li><a class="post-move"><i class="fas fa-angle-right"></i></a></li>
				</ul>
			</div>
		</div>
	</div>
</body>
<script src="/resources/js/jquery-1.12.4.js" type="text/javascript"></script>
<script src="/resources/bootstrap-3.3.2/js/bootstrap.min.js"
	type="text/javascript"></script>
<script>
	$(document).ready(function(){
		
		history.replaceState({}, null, null);
		
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
		
		//uri parameter 값들
		var page = '<c:out value="${page}"/>';
		var type = '<c:out value="${type}"/>';
		var keyword = '<c:out value="${keyword}"/>';
		var total ='<c:out value="${total}"/>';
		
		//아이콘 눌러서 수정 전 페이지
		$('.fa-cog').on('click',function(e){
			location.href='/preUserInfo';
		});
		
		//새글 쓰기 이동
		$('.button-wrapper button').on("click", function(e){
			e.preventDefault();
			location.href='/free/registerFreeBoard?page='+page+'&type='+type+'&keyword='+keyword+'';
		});
		
		
		
		//페이지 번호 뽑기
		//시작번호, 끝번호, 실제 마지막 번호
		(function(p,ty,k,tt){
			var start = Math.ceil(p/5)*5-4; 
			var end = Math.ceil(p/5)*5; 
			var totalEnd = Math.ceil(tt/10); 
			
			console.log(totalEnd);
			
			//실제 마지막번호와 일치
			if(totalEnd<=end){ 
				end = totalEnd;
			}
			
			console.log(end);
			
			var pageNum = '';
			for(var i = start; i<=end; i++){
				var pageNum = pageNum + '<li><a href="/free/freeBoardList?page='+i+'&type='+ty+'&keyword='+k+'">'+i+'</a></li>'
			}
			
			$('.pagination li:nth-child(1)').after(pageNum);
		})(page,type,keyword,total);
		
		
		
		//좌우 이동 버튼 클릭 이벤트 핸들링
		$('.pre-move').on('click',function(e){
			e.preventDefault();
			//이전 페이지 가장 끝 번호 이동
			var preMove = (Math.ceil(page/5)-1)*5;
			if(preMove === 0){
				alert("이전 페이지가 없습니다.");
				return;
			}
			location.href = '/free/freeBoardList?page='+preMove+'&type='+type+'&keyword='+keyword+'';
		});
		
		$('.post-move').on('click',function(e){
			e.preventDefault();
			//이후 페이지 가장 첫 번호 이동
			var postMove = Math.ceil(page/5)*5+1;
			var lastChk = Math.ceil(total/10);
			if(postMove>lastChk){
				alert("다음 페이지가 없습니다.");
				return;
			}
			
			location.href = '/free/freeBoardList?page='+postMove+'&type='+type+'&keyword='+keyword+'';
		});
		
		//제목클릭 조회수 증가 --> 쿠키로(주소타고 들어올 때 고려)
		/* $('.board-title').on('click',function(e){
			e.preventDefault();
			var idx = $(this).next().data('idx');
			var updateCount = function(idx, callback, error){
				$.ajax({
					type:'post'
				   ,url:''+idx
				   ,success:function(result,status,xhr){
					  if(callback){
						  callback(console.log(result));
					  }
				   }
				   ,error:function(result,status,xhr){
					   if(error){
						   error(result);
					   }
				   }
				});
			}
			updateCount(idx);
			location.href = '/free/getFreeBoard?idx='+idx+'page='+page+'&type='+type+'&keyword='+keyword+'';
		}); */
		
		
		
	});
</script>
</html>