<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ISTI_CityNavigation.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>ISTI縣市導航資料庫｜會員登入</title>
    <link href="<%=ResolveUrl("~/css/jquery-ui.css") %>" rel="stylesheet" type="text/css" />
    <link href="<%=ResolveUrl("~/css/bootstrap.css") %>" rel="stylesheet" /><!-- normalize & bootstrap's grid system -->
    <link href="<%=ResolveUrl("~/css/font-awesome.min.css") %>" rel="stylesheet" /><!-- css icon -->
    <link href="<%=ResolveUrl("~/css/fontello.css") %>" rel="stylesheet" />
    <link href="<%=ResolveUrl("~/css/superfish.css") %>" rel="stylesheet" type="text/css" /><!-- 下拉選單 -->
    <link href="<%=ResolveUrl("~/css/jquery.mmenu.css") %>" rel="stylesheet" type="text/css" /><!-- mmenu css:行動裝置選單 -->
    <link href="<%=ResolveUrl("~/css/jquery.mmenu.positioning.css") %>" rel="stylesheet" type="text/css" /><!-- mmenu css:行動裝置選單:位置 -->
    <link href="<%=ResolveUrl("~/css/jquery.powertip.css") %>" rel="stylesheet" type="text/css" /><!-- powertip:tooltips -->
    <link href="<%=ResolveUrl("~/css/jquery.datetimepicker.css") %>" rel="stylesheet" type="text/css" /><!-- datepicker -->
    <link href="<%=ResolveUrl("~/css/magnific-popup.css") %>" rel="stylesheet" type="text/css" /><!-- popup dialog -->
    <link href="<%=ResolveUrl("~/css/scrollbar.css") %>" rel="stylesheet" type="text/css" /><!-- scrollbar美化 -->
    <link href="<%=ResolveUrl("~/css/OchiLayout.css") %>" rel="stylesheet" type="text/css" /><!-- ochsion layout base -->
    <link href="<%=ResolveUrl("~/css/OchiColor.css") %>" rel="stylesheet" type="text/css" /><!-- ochsion layout color -->
    <link href="<%=ResolveUrl("~/css/OchiRWD.css") %>" rel="stylesheet" type="text/css" /><!-- ochsion layout RWD -->
    <link href="<%=ResolveUrl("~/css/style.css") %>" rel="stylesheet" type="text/css" />
    <link href="<%=ResolveUrl("~/css/NickStyle.css") %>" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery-3.3.1.min.js") %>"></script>
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery-ui.1.12.1.js") %>"></script>
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.breakpoint-min.js") %>"></script><!-- 斷點設定 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/superfish.min.js") %>"></script><!-- 下拉選單 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/supposition.js") %>"></script><!-- 下拉選單:修正最後項在視窗大小不夠時的BUG -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.mmenu.js") %>"></script><!-- mmenu js:行動裝置選單 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.touchSwipe.min.js") %>"></script><!-- 增加JS觸控操作 for mmenu -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.powertip.min.js") %>"></script><!-- powertip:tooltips -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.datetimepicker.js") %>"></script><!-- datepicker -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.easytabs.min.js") %>"></script><!-- easytabs tab -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.magnific-popup.min.js") %>"></script><!-- popup dialog -->
    <!-- 滾動偵測 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.scrollmagic.min.js") %>"></script><!-- scrollmagic配合捲軸動畫 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.scrollmagic.debug.js") %>"></script><!-- scrollmagic配合捲軸動畫:顯示起啟位置參考線(上線前移除) -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.scrollbar.min.js") %>"></script><!-- scrollbar美化 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.matchHeight-min.js") %>"></script><!-- equal height解決bootstrap grid layout內容不等高時排版問題 -->
    <script type="text/javascript">
        $(document).ready(function () {
            $(document).on("keyup", "body", function (e) {
            if (e.keyCode == 13)
                $("#lgbtn").click();
            });

            $(document).on("click", "#lgbtn", function () {
                $.ajax({
                    type: "POST",
                    async: false, //在沒有返回值之前,不會執行下一步動作
                    url: "handler/UserLogin.aspx",
                    data: {
                        acc: $("#AccTxt").val(),
                        pwd: $("#PwdTxt").val()
                    },
                    error: function (xhr) {
                        alert(xhr.responseText);
                    },
                    success: function (data) {
                        if ($(data).find("Error").length > 0) {
                            alert($(data).find("Error").attr("Message"));
                        }
                        else {
                            location.href = $("Redirect", data).text();
                        }
                    }
                });
            });
        });// end js
    </script>
    <style>
        .logcss {
            height: 200px;
            width: 400px;
            position: absolute; /*絕對位置*/
            top: 50%; /*從上面開始算，下推 50% (一半) 的位置*/
            left: 50%; /*從左邊開始算，右推 50% (一半) 的位置*/
            margin-top: -100px; /*高度的一半*/
            margin-left: -200px; /*寬度的一半*/
            font-size: 16pt;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="WrapperBody">
            <div class="WrapperHeader">
                <%--<i class="fa fa-bars itemhint"  aria-hidden="true" id="mmenuMobswitch" title="切換選單顯示"></i>--%>
                <div class="headerbox twocolV2">
                    <div class="left">
                        <div class="logoPadding"><img src="<%=ResolveUrl("~/images/logo.png") %>" class="img-responsive"> </div>
                    </div><!-- left -->
                </div><!--headerbox -->
            </div><!-- WrapperHeader -->

            <div class="logcss">
                <div style="text-align:center">
                    <div style="margin-bottom:10px;">帳號：<input id="AccTxt" type="text" class="inputex" /></div>
                    <div style="margin-bottom:10px;">密碼：<input id="PwdTxt" type="password" class="inputex" /></div>
                    <input id="lgbtn" type="button" value="登入" class="genbtn" />
                </div>
            </div><!-- WrapperMainContent -->
        </div>
        <div class="WrapperFooter">
            <div class="footerblock container font-normal">
                版權所有©2018 工業技術研究院｜ 建議瀏覽解析度1024x768以上
            </div><!--{* footerblock *}-->
        </div><!-- WrapperFooter -->
    </form>
<script type="text/javascript" src="<%=ResolveUrl("~/js/GenCommon.js") %>"></script><!-- UIcolor JS -->
<script type="text/javascript" src="<%=ResolveUrl("~/js/PageCommon.js") %>"></script><!-- 系統共用 JS -->
<script type="text/javascript" src="<%=ResolveUrl("~/js/NickCommon.js") %>"></script><!-- 系統共用 JS -->
<script type="text/javascript" src="<%=ResolveUrl("~/js/autoHeight.js") %>"></script><!-- 高度不足頁面的絕對置底footer -->
</body>
</html> 
