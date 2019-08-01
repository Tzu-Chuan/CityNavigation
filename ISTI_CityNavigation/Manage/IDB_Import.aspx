<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/BackEnd.Master" AutoEventWireup="true" CodeBehind="IDB_Import.aspx.cs" Inherits="ISTI_CityNavigation.Manage.IDB_Import" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            GetVersion();
            
            //更換版本
            $(document).on("click", "#ChangeVerbtn", function () {
               $.ajax({
                    type: "POST",
                    async: false, //在沒有返回值之前,不會執行下一步動作
                    url: "mHandler/ChangeIDBVersion.aspx",
                    data: {
                        ver: $("#ddlVer").val()
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
                            GetVersion();
                        }
                    }
                });
            });

            //上傳
            $(document).on("click", "#upbtn", function () {
                $("#Msg").html("");
                try {
                    if ($("#file0").val() == "") {
                        alert("請選擇要匯入的檔案");
                        return;
                    }
                    var exten = $("#file0").val().replace(/^.*\./, '');
                    var PassExten = ["xls", "xlsx"];
                    if ($.inArray(exten, PassExten) == -1) {
                        alert("請上傳Excel檔");
                        return;
                    }
                    var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none" />');
                    //var token = $('<input type="hidden" name="InfoToken" id="InfoToken" value="' + $("#InfoToken").val() + '" />');
                    var form = $("form")[0];

                    //如果沒有重新導頁需要刪除上次資訊
                    $("#postiframe").remove();
                    //$("input[name='token']").remove();

                    form.appendChild(iframe[0]);
                    //form.appendChild(token[0]);

                    form.setAttribute("action", "mHandler/ImportIDBFile.aspx");
                    form.setAttribute("method", "post");
                    form.setAttribute("enctype", "multipart/form-data");
                    form.setAttribute("encoding", "multipart/form-data");
                    form.setAttribute("target", "postiframe");
                    form.submit();
                    $("#load").show();
                }
                catch (ex) {
                    alert(ex.message);
                    $("#load").hide();
                }
            });
        });

        //版本管控
        function GetVersion() {
            $.ajax({
                type: "POST",
                async: false, //在沒有返回值之前,不會執行下一步動作
                url: "mHandler/GetIDBVersionDDL.aspx",
                error: function (xhr) {
                    alert(xhr.responseText);
                },
                success: function (data) {
                    if ($(data).find("Error").length > 0) {
                        alert($(data).find("Error").attr("Message"));
                    }
                    else {
                        var ddlstr = '<option value="">請選擇</option>';
                        if ($(data).find("data_item").length > 0) {
                            $(data).find("data_item").each(function (i) {
                                if ($(this).attr("CS_Version") != $(this).attr("NowVer"))
                                    ddlstr += '<option value="' + $(this).attr("CS_Version") + '">' + $(this).attr("ddlstr") + '</option>';

                                //版本資訊
                                if (i == 0) {
                                    $("#nowVersion").html($(this).attr("NowVer"));
                                    var upDate = new Date($(this).attr("CS_CreateDate"));
                                    var fulldate = upDate.getFullYear() + "/" + (upDate.getMonth() + 1) + "/" + upDate.getDay();
                                    var h = upDate.getHours();
                                    h = (h < 10) ? ("0" + h) : h;
                                    var m = upDate.getMinutes();
                                    m = (m < 10) ? ("0" + m) : m;
                                    var s = upDate.getSeconds();
                                    s = (s < 10) ? ("0" + s) : s;
                                    var fulltime = h + ":" + m + ":" + s;
                                    $("#upday").html(fulldate + "   " + fulltime);
                                }
                            });
                            $("#ddlVer").empty();
                            $("#ddlVer").append(ddlstr);
                        }
                    }
                }
            });
        }

        function feedbackFun(msg) {
            $("#Msg").html(msg);
            $("#load").hide();
            GetVersion();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="twocol titleLineA">
        <div class="left"><span class="font-size4">IDB 資料管理</span></div><!-- left -->
        <div class="right">後臺管理 / IDB 資料管理</div><!-- right -->
    </div><!-- twocol -->

    <div class="stripeMeCS margin10T font-normal">
        <table id="tablist" width="100%" border="1" cellspacing="0" cellpadding="0">
            <tr></tr>
            <tr class="alt">
                <td>版本管控</td>
            </tr>
            <tr>
                <td>
                    <div style="margin-bottom:5px;">當前版本資訊：<span id="upday"></span>&nbsp;&nbsp;Ver.<span id="nowVersion"></span></div>
                    選擇版本：<select id="ddlVer" class="inputex"></select>&nbsp;&nbsp;
                    <input type="button" class="genbtn" id="ChangeVerbtn" value="更換版本" />
                </td>
            </tr>
            <tr>
                <td>資料上傳</td>
            </tr>
            <tr>
                <td>
                    <div style="margin-bottom:10px; font-size:12pt;">Excel 上傳範例檔下載：<a href="<%=ResolveUrl("~/Sample/工業局匯入資料範例.xlsx") %>">IDB匯入資料範例.xlsx</a></div>
                    選擇檔案：<input id="file0" name="file0" type="file" class="inputex" />
                    <input id="upbtn" type="button" class="genbtn" value="上傳" />
                    <div id="load" class="margin10T" style="display:none;"><img src="<%= ResolveUrl("~/images/loading.gif") %>" width="40" />資料上傳中，請稍後...</div>
                    <div id="Msg" class="margin10T" style="color:red;"></div>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
