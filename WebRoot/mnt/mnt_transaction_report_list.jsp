<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="/WEB-INF/tld/rmp.tld"  prefix="rmp" %>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>（柱状图）日交易量</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/dialog.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/form.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${pageContext.request.contextPath}/ec/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/ec/highcharts.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/ec/exporting.js"></script>
<style type="text/css">
body {
	font-family: "微软雅黑";
}
.font{color:red}
.input_file{width:140px; margin-left:-140px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>
<script type="text/javascript">  
       /*获取json数据开始*/  
       //定义变量  
       $(document).ready(function () {  
           var jsonXData = [];  
           var jsonyD1 = [];  
          // var jsonyD2 = [];  
         //获取数据  
           $.ajax({ 
        	   url: "${pageContext.request.contextPath}/transactionSuccess_report.action", 
               cache: false,  
               async: false,  
               success: function (data) {  
                   var json = eval("(" + data + ")");  
                   if (json.Rows.length > 0) {  
                       for (var i = 0; i < json.Rows.length; i++) {  
                           var rows = json.Rows[i];  
                           var Year = rows.day; 
                           var ShouldPay = rows.number;  
                           //var TruePay = rows.truePay;  
                           jsonXData.push(Year); //赋值  
                           jsonyD1.push(ShouldPay);  
                          // jsonyD2.push(TruePay);  
                       } //for  
                       var chart;  
                       chart = new Highcharts.Chart({  
                           chart: {  
                               renderTo: 'containerliuliang',//放置图表的容器  
                               plotBackgroundColor: null,  
                               plotBorderWidth: null,  
                               defaultSeriesType: 'column'   //图表类型line, spline, area, areaspline, column, bar, pie , scatter   
                           },  
                           title: {  
                               text: '最近31天的交易量情况',  
                               style: { font: 'normal 13px 宋体' }  
                           },  
                           xAxis: {//X轴数据  
                               categories: jsonXData,  
                               lineWidth: 2,  
                               labels: {  
                                   rotation: -45, //字体倾斜  
                                   align: 'right',  
                                   style: { font: 'normal 13px 宋体' }  
                               }  
                           },  
                           yAxis: {//Y轴显示文字  
                               lineWidth: 2,  
                               title: {  
                                   text: '数量/条'  
                               }  
                           },  
                           tooltip: {  
                               formatter: function () {  
                                   return '<b>' + this.x + '</b><br/>' +  
                                this.series.name + ': ' + this.y+'条';  
                               }  
                           },  
                           plotOptions: {  
                               column: {  
                                   dataLabels: {  
                                       enabled: true  
                                   },  
                                   enableMouseTracking: true//是否显示title  
                               }  
                           },  
                           series: [{  
                               name: '交易量',  
                               data: jsonyD1  
                           }
                          /*  , {  
                               name: '实缴',  
                               data: jsonyD2  
                           } */
                           ]  
                       });  
                       //$("tspan:last").hide(); //把广告删除掉  
                   } //if  
               }  
           });  
       });  
       
       function back(){
    		window.location.href="${pageContext.request.contextPath}/ec/ec_transaction_num_alllist.jsp";
    	}
    </script> 
</head>
<div style="padding:5px;">  
    <fieldset>  
     <div>  
        <div style="margin: 0 1px">  
      	<span style="float:right";>
      	<input id="filter_reset2" class="inputd" type="button" onclick="back()" value="返回"/>
      	</span>
        <div id="containerliuliang" style="min-width: 368px; height: 368px; margin: 0 auto"></div>  
        </div>  
     </div>  
    </fieldset>  
</div>
</body>

</html>

