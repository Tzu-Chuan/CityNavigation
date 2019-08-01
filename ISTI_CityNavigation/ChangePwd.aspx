<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangePwd.aspx.cs" Inherits="ISTI_CityNavigation.ChangePwd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>經濟部智慧城鄉生活應用導航資料庫｜會員登入</title>
    <link href="<%=ResolveUrl("~/css/jquery-ui.css") %>" rel="stylesheet" type="text/css" />
    <link href="<%=ResolveUrl("~/css/bootstrap.css") %>" rel="stylesheet" />
    <!-- normalize & bootstrap's grid system -->
    <link href="<%=ResolveUrl("~/css/font-awesome.min.css") %>" rel="stylesheet" />
    <!-- css icon -->
    <link href="<%=ResolveUrl("~/css/fontello.css") %>" rel="stylesheet" />
    <!-- css icon:http://fontello.com/  -->
    <link href="<%=ResolveUrl("~/css/superfish.css") %>" rel="stylesheet" type="text/css" />
    <!-- 下拉選單 -->
    <link href="<%=ResolveUrl("~/css/jquery.mmenu.css") %>" rel="stylesheet" type="text/css" />
    <!-- mmenu css:行動裝置選單 -->
    <link href="<%=ResolveUrl("~/css/jquery.powertip.css") %>" rel="stylesheet" type="text/css" />
    <!-- powertip:tooltips -->
    <link href="<%=ResolveUrl("~/css/jquery.datetimepicker.css") %>" rel="stylesheet" type="text/css" />
    <!-- datepicker -->
    <link href="<%=ResolveUrl("~/css/magnific-popup.css") %>" rel="stylesheet" type="text/css" />
    <!-- popup dialog -->
    <link href="<%=ResolveUrl("~/css/scrollbar.css") %>" rel="stylesheet" type="text/css" />
    <!-- scrollbar美化 -->
    <link href="<%=ResolveUrl("~/css/OchiLayout.css") %>" rel="stylesheet" type="text/css" />
    <!-- ochsion layout base -->
    <link href="<%=ResolveUrl("~/css/OchiColor.css") %>" rel="stylesheet" type="text/css" />
    <!-- ochsion layout color -->
    <link href="<%=ResolveUrl("~/css/OchiRWD.css") %>" rel="stylesheet" type="text/css" />
    <!-- ochsion layout RWD -->
    <link href="<%=ResolveUrl("~/css/style.css") %>" rel="stylesheet" type="text/css" />
    <link href="<%=ResolveUrl("~/css/NickStyle.css") %>" rel="stylesheet" type="text/css" />

    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery-3.4.1.min.js") %>"></script>
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery-ui.1.12.1.js") %>"></script>
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.breakpoint-min.js") %>"></script>
    <!-- 斷點設定 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/superfish.min.js") %>"></script>
    <!-- 下拉選單 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/supposition.js") %>"></script>
    <!-- 下拉選單:修正最後項在視窗大小不夠時的BUG -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.mmenu.min.js") %>"></script>
    <!-- mmenu js:行動裝置選單 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.touchSwipe.min.js") %>"></script>
    <!-- 增加JS觸控操作 for mmenu -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.powertip.min.js") %>"></script>
    <!-- powertip:tooltips -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.datetimepicker.js") %>"></script>
    <!-- datepicker -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.easytabs.min.js") %>"></script>
    <!-- easytabs tab -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.magnific-popup.min.js") %>"></script>
    <!-- popup dialog -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/animatescroll.min.js") %>"></script>
    <!-- 動態滾動 -->
    <!-- 動畫套件 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery-timing.min.js") %>"></script>
    <!-- 組織動畫用JS.wait() -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/TweenMax.min.js") %>"></script>
    <!-- GSAP -->
    <!-- 滾動偵測 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.scrollmagic.min.js") %>"></script>
    <!-- scrollmagic配合捲軸動畫 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.scrollmagic.debug.js") %>"></script>
    <!-- scrollmagic配合捲軸動畫:顯示起啟位置參考線(上線前移除) -->
    <!-- 網站套件 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.matchHeight-min.js") %>"></script>
    <!-- equal height解決bootstrap grid layout內容不等高時排版問題 -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/jquery.scrollbar.min.js") %>"></script>
    <!-- scrollbar美化 -->

    <style>
        .logcss {
            height: 200px;
            width: 400px;
            position: absolute; /*絕對位置*/
            top: 50%; /*從上面開始算，下推 50% (一半) 的位置*/
            left: 50%; /*從左邊開始算，右推 50% (一半) 的位置*/
            margin-top: -50px; /*高度的一半*/
            margin-left: -200px; /*寬度的一半*/
            font-size: 16pt;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            $(document).on("click", "#changebtn", function () {
                var msg = "";
                if ($("#nPwd").val() == "") {
                    msg += "新密碼內容不可以空白";
                }

                if ($("#cPwd").val() == "") {
                    msg += "確認新密碼內容不可以空白";
                }

                if ($("#nPwd").val().indexOf(" ") != -1 || $("#cPwd").val().indexOf(" ") != -1) {
                    msg += "密碼內容不可以有空格";
                }


                if ($("#nPwd").val() != $("#cPwd").val()) {
                    msg += "密碼錯誤請重新確認";
                }

                if (msg != "") {
                    alert(msg);
                    return;
                }

                //修改密碼
                $.ajax({
                    type: "POST",
                    async: false, //在沒有返回值之前,不會執行下一步動作
                    url: "handler/ChangeUserPwd.aspx",
                    data: {
                        gid: $.getQueryString("ChangePwd"),
                        ck: $.getQueryString("ck"),
                        M_Pwd: $("#nPwd").val(),
                        Token: $("#InfoToken").val()
                    },
                    error: function (xhr) {
                        alert(xhr.responseText);
                    },
                    success: function (data) {
                        if ($(data).find("Error").length > 0) {
                            alert($(data).find("Error").attr("Message"));
                        }
                        else {
                            alert($("Response", data).text());
                            location.href = "Login.aspx";
                        }
                    }
                });
            });
        }); // js end

    </script>
</head>
<body>
    <div>
        <form runat="server">
            <asp:HiddenField ID="InfoToken" runat="server" />
            <!-- Preloader -->
            <div id="preloader">
                <div id="status">
                    <div id="CSS3loading">
                        <!-- css3 loading -->
                        <div class="sk-three-bounce">
                            <div class="sk-child sk-bounce1"></div>
                            <div class="sk-child sk-bounce2"></div>
                            <div class="sk-child sk-bounce3"></div>
                        </div>
                        <!-- css3 loading -->
                        <span id="loadingword">資料讀取中，請稍待...</span>
                    </div>
                    <!-- CSS3loading -->
                </div>
                <!-- status -->
            </div>
            <!-- preloader -->


            <div class="WrapperBody" id="WrapperBody">
                <div class="WrapperHeader">
                    <div class="container">
                        <div class="logo" style="margin-top: 30px;">
                            <img src="<%=ResolveUrl("~/images/logo.png") %>" />
                        </div>
                    </div>
                    <!-- container -->
                </div>
                <!-- WrapperHeader -->
                <div class="container margin15T" id="ContentWrapper">
                    <div class="logcss">
                        <div class="gentable" text-align: center;">
                            <table width: 100%;" cellspacing="0" cellpadding="0">
                                <tr>
                                    <th colspan="2">會員密碼修改</th>
                                </tr>
                                <tr>
                                    <th>新密碼</th>
                                    <td>
                                        <input id="nPwd" type="password" class="inputex width100 dialogInput" /></td>
                                </tr>
                                <tr>
                                    <th style="width:150px">確認新密碼</th>
                                    <td>
                                        <input id="cPwd" type="password" class="inputex width100 dialogInput" /></td>
                                    </tr>
                            </table>
                            <div style="text-align: center; margin-top: 5px;">
                                <input type="button" class="genbtn" id="changebtn" value="送出" />
                            </div>
                        </div>
                    </div>
                </div>
                <!-- ContentWrapper -->
            </div>
            <!-- WrapperBody -->

            <div class="WrapperFooter">
                <div class="footerblock container font-normal">
                    版權所有©2019 智慧城鄉計畫辦公室｜ 建議瀏覽解析度1024x768以上
                </div>
                <!--{* footerblock *}-->
            </div>
            <!-- WrapperFooter -->
        </form>
    </div>
    <script type="text/javascript" src="<%=ResolveUrl("~/js/GenCommon.js") %>"></script>
    <!-- UIcolor JS -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/PageCommon.js") %>"></script>
    <!-- 系統共用 JS -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/NickCommon.js") %>"></script>
    <!-- 系統共用 JS -->
    <script type="text/javascript" src="<%=ResolveUrl("~/js/autoHeight.js") %>"></script>
    <!-- 高度不足頁面的絕對置底footer -->
</body>
</html>
