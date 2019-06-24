<%@ Page Title="" Language="C#" MasterPageFile="~/Manage/BackEnd.Master" AutoEventWireup="true" CodeBehind="IDB_Import.aspx.cs" Inherits="ISTI_CityNavigation.Manage.IDB_Import" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            //上傳
            $(document).on("click", "#upbtn", function () {
                $("#ErrMsg").html("");
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

                    form.setAttribute("action", "mHandler/ImportIDBFile.aspx");
                    form.setAttribute("method", "post");
                    form.setAttribute("enctype", "multipart/form-data");
                    form.setAttribute("encoding", "multipart/form-data");
                    form.setAttribute("target", "postiframe");
                    form.submit();
                    $("#WrapperMainContent").loading({
                        message: "資料上傳中，請稍後"
                    });
                }
                catch (ex) {
                    alert(ex.message);
                     $("#WrapperMainContent").loading('stop');
                }
            });
        });

        function feedbackFun(msg) {
            $("#ErrMsg").html(msg);
            $("#WrapperMainContent").loading('stop');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="margin10T">
        <div style="margin-bottom:10px; font-size:12pt;">Excel 上傳範例檔下載：<a href="<%=ResolveUrl("~/Sample/工業局匯入資料範例.xlsx") %>">IDB匯入資料範例.xlsx</a></div>
        選擇檔案：<input id="file0" name="file0" type="file" class="inputex" />
        <input id="upbtn" type="button" class="genbtn" value="上傳" />
    </div>
    <div id="ErrMsg" class="margin10T" style="color:red;"></div>
</asp:Content>
