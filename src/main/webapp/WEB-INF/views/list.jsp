<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="resources/css/common.css" type="text/css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
</style>
</head>
<body>
	게시판 리스트
	<hr/>
	<button onclick="del()">선택 삭제</button>
	<table>
		<thead>
		<tr>
			<th><input type="checkbox" id="all"/></th>
			<th>글번호</th>
			<th>이미지</th>
			<th>제목</th>
			<th>작성자</th>
			<th>조회수</th>
			<th>날짜</th>
		</tr>
		</thead>
		<tbody id="list">
		</tbody>
		<!-- 
		<c:forEach items="${list}" var="item">
			<tr>
				<td><input type="checkbox" id="del" value="${item.idx}" /></td>
				<td>${item.idx}</td>
				<td>
					<c:if test="${item.img_cnt > 0}"><img class="icon" src="resources/img/image.png"/></c:if>
					<c:if test="${item.img_cnt == 0}"><img class="icon" src="resources/img/no_image.png"/></c:if>
				</td>
				<td>${item.subject}</td>
				<td>${item.user_name}</td>
				<td>${item.bHit}</td>
				<td>${item.reg_date}</td>
			</tr>
		</c:forEach>
		-->
	</table>
</body>
<script>
	listCall();
	
	function listCall(){
		$.ajax({
			type:'get',
			url:'./list.ajax',
			data:{},
			dataType:'json',
			success:function(data){
				drawList(data.list);
			},
			error:function(error){
				console.log(error);
			}
		});
	}
	
	function drawList(list){
		var content = '';
		
		for (item of list) {
			/* 추가하는 사항에 el 태그를 사용하면 속도차이로 값이 안나올수 있어 사용에 주의해야한다. -> 변수로 사용 */
			console.log(item);
			content += '<tr>';
			content +=	'<td><input type="checkbox" name="del" value="'+item.idx+'" /></td>';
			content +=	'<td>'+item.idx+'</td>';
			content +=	'<td>';
			
			var img = item.img_cnt > 0 ? 'image.png' : 'no_image.png';
			content +=	'<img class="icon" src="resources/img/'+img+'"/>';
			
			content +=	'</td>';
			content +=	'<td>'+item.subject+'</td>';
			content +=	'<td>'+item.user_name+'</td>';
			content +=	'<td>'+item.bHit+'</td>';
			
			// java.sql.Date 는 javascript 에서는 ms 로 변환하여 표시한다.
			// 방법 1. Back-end : DTO 의 반환 날짜 타입을 문자열로 변경
			// content +=	'<td>'+item.reg_date+'</td>';
			
			// 방법 2. Front-end : js 에서 직접 변환
			var date = new Date(item.reg_date);
			var dateStr = date.toLocaleDateString("ko-KR"); // en-US - 그 지역의 표준시로 보여달라
			
			content += '<td>'+dateStr+'</td>';
			
			content +='</tr>';
		}
	
		$('#list').html(content);
	}
	
	function del(){ // 체크 표시된 value 값을 delArr 에 담아보자
		var delArr = [];
		
		$('input[name="del"]').each(function(){
			if($(this).is(":checked")){ // function 매개변수에 item을 넣고 this 대신 item 을 넣어도 괜찮음
				delArr.push($(this).val());
			}
		});
		console.log('delArr : ', delArr);
	
		$.ajax({
			type:'post',
			url:'./del.ajax',
			data:{delList:delArr},
			dataType:'JSON',
			success:function(data){
				if (data.cnt > 0) {
					alert('선택하신 '+data.cnt+' 개의 글이 삭제 되었습니다.');
					$('#list').empty();
					listCall();
				}
			},
			error:function(error){
				console.log(error);
			}
		});
	
	}
	
	$('#all').on('click', function(){
		
		var $chk = $('input[name="del"]');
		
		// attr : 정적 속성 : 처음부터 그려저 있거나 jsp 에서 그린 내용을 처리
		// prop : 동적 속성 : 자바스크립트로 나중에 그려진 요소를 처리
		// ** 실행하려는 시점 보다 나중에 그려지는 건 prop, 실행하려는 시점보다 먼저 그려져 있는건 attr
		if($(this).is(":checked")){
			$chk.attr('checked', true);
		} else {
			$chk.attr('checked', false);
		}
	});
	
</script>
</html>