﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/BackEnd.Master" AutoEventWireup="true" CodeBehind="IDB_Import.aspx.cs" Inherits="ISTI_CityNavigation.Manage.IDB_Import" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
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
                    //var year = $('<input type="hidden" name="year" id="year" value="" />');
                    var form = $("form")[0];

                    //如果沒有重新導頁需要刪除上次資訊
                    $("#postiframe").remove();
                    //$("input[name='year']").remove();

                    form.appendChild(iframe[0]);
                    //form.appendChild(year[0]);
                    var Token_v = document.getElementById('<%=InfoToken.ClientID%>').value;
                    form.setAttribute("action", "mHandler/ImportIDBFile.aspx?Token=" + Token_v);
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

        function feedbackFun(msg) {
            $("#Msg").html(msg);
            $("#load").hide();
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="twocol titleLineA">
        <div class="left"><span class="font-size4">IDB 資料管理</span></div><!-- left -->
        <div class="right">後臺管理 / IDB 資料管理</div><!-- right -->
    </div><!-- twocol -->

    <div class="margin10T">
        <div style="margin-bottom:10px; font-size:12pt;">Excel 上傳範例檔下載：<a href="<%=ResolveUrl("~/Sample/工業局匯入資料範例.xlsx") %>">IDB匯入資料範例.xlsx</a></div>
        選擇檔案：<input id="file0" name="file0" type="file" class="inputex" />
        <input id="upbtn" type="button" class="genbtn" value="上傳" />
    </div>
    <div id="load" class="margin10T" style="display:none;"><img src="<%= ResolveUrl("~/images/loading.gif") %>" width="40" />資料上傳中，請稍後...</div>
    <div id="Msg" class="margin10T" style="color:red;"></div>

    <input type="hidden" id="InfoToken" runat="server" >
</asp:Content>
